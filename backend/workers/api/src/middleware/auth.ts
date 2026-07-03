import type { MiddlewareHandler } from 'hono';
import jwt from 'jsonwebtoken';
import type { AppEnv } from '../types';
import { AuthError } from '@asheeighe/core/errors';
import { createDB } from '@asheeighe/db';
import type { User } from '@asheeighe/core';

interface JwtPayload {
  sub: string;
  email: string;
  iat: number;
  exp: number;
}

export const authMiddleware: MiddlewareHandler<AppEnv> = async (c, next) => {
  const authHeader = c.req.header('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    throw new AuthError('Missing or invalid Authorization header');
  }

  const token = authHeader.slice(7);
  if (!token) {
    throw new AuthError('Token is empty');
  }

  let payload: JwtPayload;
  try {
    payload = jwt.verify(token, c.env.JWT_SECRET, { algorithms: ['HS256'] }) as JwtPayload;
  } catch (err) {
    if (err instanceof jwt.TokenExpiredError) {
      throw new AuthError('Token has expired');
    }
    if (err instanceof jwt.JsonWebTokenError) {
      throw new AuthError('Invalid token');
    }
    throw new AuthError('Token verification failed');
  }

  const db = createDB(c.env.DB);
  const user = await db.findById<Record<string, unknown>>('users', payload.sub);

  if (!user) {
    throw new AuthError('User not found');
  }

  const mappedUser: User = {
    id: user.id as string,
    email: user.email as string,
    displayName: (user.display_name as string) ?? '',
    avatarUrl: user.avatar_url as string | null,
    timezone: (user.timezone as string) ?? 'UTC',
    preferences: typeof user.preferences === 'string' ? JSON.parse(user.preferences as string) : (user.preferences ?? {}),
    emailVerified: (user.email_verified as number) === 1,
    role: (user.role as User['role']) ?? 'user',
    createdAt: user.created_at as string,
    updatedAt: user.updated_at as string,
  };

  c.set('user', mappedUser);
  c.set('userId', mappedUser.id);
  c.set('db', db);

  await next();
};
