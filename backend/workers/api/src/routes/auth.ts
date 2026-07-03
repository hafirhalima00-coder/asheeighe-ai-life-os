import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import jwt from 'jsonwebtoken';
import type { AppEnv } from '../types';
import { createDB } from '@asheeighe/db';
import { AuthError, ConflictError } from '@asheeighe/core/errors';
import { generateId } from '@asheeighe/core/utils';

const auth = new Hono<AppEnv>();

const registerSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters').max(128),
  displayName: z.string().max(100).optional(),
});

const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
});

const refreshSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

function generateTokens(env: AppEnv['Bindings'], userId: string, email: string) {
  const accessToken = jwt.sign(
    { sub: userId, email },
    env.JWT_SECRET,
    { algorithm: 'HS256', expiresIn: '15m' },
  );

  const refreshToken = jwt.sign(
    { sub: userId, email, type: 'refresh' },
    env.JWT_REFRESH_SECRET,
    { algorithm: 'HS256', expiresIn: '7d' },
  );

  return { accessToken, refreshToken, expiresIn: 900 };
}

async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder();
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const keyMaterial = await crypto.subtle.importKey('raw', encoder.encode(password), 'PBKDF2', false, ['deriveBits']);
  const hash = await crypto.subtle.deriveBits(
    { name: 'PBKDF2', salt, iterations: 100_000, hash: 'SHA-256' },
    keyMaterial,
    256,
  );
  const saltHex = Array.from(salt).map((b) => b.toString(16).padStart(2, '0')).join('');
  const hashHex = Array.from(new Uint8Array(hash)).map((b) => b.toString(16).padStart(2, '0')).join('');
  return `${saltHex}:${hashHex}`;
}

async function verifyPassword(password: string, stored: string): Promise<boolean> {
  const [saltHex, hashHex] = stored.split(':');
  if (!saltHex || !hashHex) return false;
  const salt = new Uint8Array(saltHex.match(/.{2}/g)!.map((b) => parseInt(b, 16)));
  const encoder = new TextEncoder();
  const keyMaterial = await crypto.subtle.importKey('raw', encoder.encode(password), 'PBKDF2', false, ['deriveBits']);
  const hash = await crypto.subtle.deriveBits(
    { name: 'PBKDF2', salt, iterations: 100_000, hash: 'SHA-256' },
    keyMaterial,
    256,
  );
  const computedHash = Array.from(new Uint8Array(hash)).map((b) => b.toString(16).padStart(2, '0')).join('');
  return computedHash === hashHex;
}

auth.post('/register', zValidator('json', registerSchema), async (c) => {
  const { email, password, displayName } = c.req.valid('json');
  const db = createDB(c.env.DB);

  const exists = await db.userExists(email);
  if (exists) {
    throw new ConflictError('An account with this email already exists');
  }

  const passwordHash = await hashPassword(password);
  const user = await db.createUser({
    id: generateId(),
    email,
    password_hash: passwordHash,
    display_name: displayName ?? email.split('@')[0] ?? '',
  });

  const tokens = generateTokens(c.env, user.id, user.email);

  return c.json({
    success: true,
    message: 'Registration successful',
    data: { user, ...tokens },
  }, 201);
});

auth.post('/login', zValidator('json', loginSchema), async (c) => {
  const { email, password } = c.req.valid('json');
  const db = createDB(c.env.DB);

  const rawUser = await db.get<Record<string, unknown>>('SELECT * FROM users WHERE email = ?', email);
  if (!rawUser) {
    throw new AuthError('Invalid email or password');
  }

  const valid = await verifyPassword(password, rawUser.password_hash as string);
  if (!valid) {
    throw new AuthError('Invalid email or password');
  }

  const tokens = generateTokens(c.env, rawUser.id as string, rawUser.email as string);

  return c.json({
    success: true,
    message: 'Login successful',
    data: { user: rawUser, ...tokens },
  });
});

auth.post('/refresh', zValidator('json', refreshSchema), async (c) => {
  const { refreshToken } = c.req.valid('json');

  let payload: { sub: string; email: string; type?: string };
  try {
    payload = jwt.verify(refreshToken, c.env.JWT_REFRESH_SECRET, { algorithms: ['HS256'] }) as typeof payload;
  } catch {
    throw new AuthError('Invalid or expired refresh token');
  }

  if (payload.type !== 'refresh') {
    throw new AuthError('Invalid token type');
  }

  const db = createDB(c.env.DB);
  const user = await db.findById<Record<string, unknown>>('users', payload.sub);
  if (!user) {
    throw new AuthError('User not found');
  }

  const tokens = generateTokens(c.env, user.id as string, user.email as string);

  return c.json({
    success: true,
    message: 'Token refreshed',
    data: tokens,
  });
});

auth.post('/logout', async (c) => {
  const authHeader = c.req.header('Authorization');
  const token = authHeader?.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (token) {
    try {
      const payload = jwt.decode(token) as { exp?: number } | null;
      if (payload?.exp) {
        const ttl = Math.max(1, payload.exp - Math.floor(Date.now() / 1000));
        await c.env.KV.put(`blacklist:${token}`, 'true', { expirationTtl: ttl });
      }
    } catch {
      // ignore decode errors
    }
  }

  return c.json({ success: true, message: 'Logged out successfully' });
});

auth.get('/me', async (c) => {
  const authHeader = c.req.header('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    throw new AuthError('Missing authorization header');
  }

  const token = authHeader.slice(7);
  let payload: { sub: string };
  try {
    payload = jwt.verify(token, c.env.JWT_SECRET, { algorithms: ['HS256'] }) as typeof payload;
  } catch {
    throw new AuthError('Invalid or expired token');
  }

  const blacklisted = await c.env.KV.get(`blacklist:${token}`);
  if (blacklisted) {
    throw new AuthError('Token has been revoked');
  }

  const db = createDB(c.env.DB);
  const user = await db.findById<Record<string, unknown>>('users', payload.sub);
  if (!user) {
    throw new AuthError('User not found');
  }

  return c.json({ success: true, data: user });
});

export default auth;
