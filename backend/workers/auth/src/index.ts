import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import jwt from 'jsonwebtoken';
import { generateId } from '@asheeighe/core/utils';
import { AuthError, ConflictError } from '@asheeighe/core/errors';

interface Env {
  Bindings: {
    DB: D1Database;
    KV: KVNamespace;
    JWT_SECRET: string;
    JWT_REFRESH_SECRET: string;
  };
}

const app = new Hono<{ Bindings: Env['Bindings'] }>();

app.use('*', cors({
  origin: ['http://localhost:5173', 'https://asheeighe.app'],
  credentials: true,
}));

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

function generateTokens(env: Env['Bindings'], userId: string, email: string) {
  const accessToken = jwt.sign({ sub: userId, email }, env.JWT_SECRET, {
    algorithm: 'HS256',
    expiresIn: '15m',
  });
  const refreshToken = jwt.sign({ sub: userId, email, type: 'refresh' }, env.JWT_REFRESH_SECRET, {
    algorithm: 'HS256',
    expiresIn: '7d',
  });
  return { accessToken, refreshToken, expiresIn: 900 };
}

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(128),
  displayName: z.string().max(100).optional(),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

app.post('/register', zValidator('json', registerSchema), async (c) => {
  const { email, password, displayName } = c.req.valid('json');

  const existing = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?').bind(email).first();
  if (existing) {
    throw new ConflictError('Email already registered');
  }

  const passwordHash = await hashPassword(password);
  const id = generateId();
  const now = new Date().toISOString();

  await c.env.DB.prepare(
    'INSERT INTO users (id, email, password_hash, display_name, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)',
  ).bind(id, email, passwordHash, displayName ?? email.split('@')[0] ?? '', now, now).run();

  const tokens = generateTokens(c.env, id, email);

  return c.json({ success: true, message: 'Registration successful', data: { userId: id, ...tokens } }, 201);
});

app.post('/login', zValidator('json', loginSchema), async (c) => {
  const { email, password } = c.req.valid('json');

  const user = await c.env.DB.prepare('SELECT * FROM users WHERE email = ?').bind(email).first<{
    id: string; email: string; password_hash: string; display_name: string;
  }>();

  if (!user) {
    throw new AuthError('Invalid email or password');
  }

  const valid = await verifyPassword(password, user.password_hash);
  if (!valid) {
    throw new AuthError('Invalid email or password');
  }

  const tokens = generateTokens(c.env, user.id, user.email);

  return c.json({ success: true, message: 'Login successful', data: { userId: user.id, ...tokens } });
});

app.post('/verify', async (c) => {
  const authHeader = c.req.header('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    throw new AuthError('Missing token');
  }

  const token = authHeader.slice(7);
  try {
    const payload = jwt.verify(token, c.env.JWT_SECRET, { algorithms: ['HS256'] }) as { sub: string; email: string };
    return c.json({ success: true, data: { userId: payload.sub, email: payload.email } });
  } catch {
    throw new AuthError('Invalid or expired token');
  }
});

app.post('/refresh', async (c) => {
  const { refreshToken } = await c.req.json<{ refreshToken: string }>();
  if (!refreshToken) {
    throw new AuthError('Refresh token is required');
  }

  let payload: { sub: string; email: string; type?: string };
  try {
    payload = jwt.verify(refreshToken, c.env.JWT_REFRESH_SECRET, { algorithms: ['HS256'] }) as typeof payload;
  } catch {
    throw new AuthError('Invalid or expired refresh token');
  }

  if (payload.type !== 'refresh') {
    throw new AuthError('Invalid token type');
  }

  const tokens = generateTokens(c.env, payload.sub, payload.email);
  return c.json({ success: true, data: tokens });
});

app.onError((err, c) => {
  const status = 'statusCode' in err ? (err as { statusCode: number }).statusCode : 500;
  const message = err.message || 'Internal server error';
  return c.json({ success: false, error: err.name, message }, status as 400 | 401 | 403 | 404 | 409 | 429 | 500);
});

export default app;
