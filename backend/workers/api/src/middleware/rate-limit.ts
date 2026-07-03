import type { MiddlewareHandler } from 'hono';
import type { AppEnv } from '../types';
import { RateLimitError } from '@asheeighe/core/errors';

interface RateLimitConfig {
  windowMs: number;
  maxRequests: number;
}

const DEFAULT_CONFIG: RateLimitConfig = {
  windowMs: 60_000,
  maxRequests: 100,
};

const AUTH_CONFIG: RateLimitConfig = {
  windowMs: 60_000,
  maxRequests: 10,
};

export const rateLimitMiddleware: MiddlewareHandler<AppEnv> = async (c, next) => {
  const isAuthRoute = c.req.path.startsWith('/auth');
  const config = isAuthRoute ? AUTH_CONFIG : DEFAULT_CONFIG;

  const ip = c.req.header('cf-connecting-ip') ?? c.req.header('x-forwarded-for') ?? 'unknown';
  const key = `rate_limit:${ip}:${isAuthRoute ? 'auth' : 'api'}`;

  try {
    const current = await c.env.KV.get(key);
    const now = Date.now();
    let windowStart: number;
    let count: number;

    if (current) {
      const parsed = JSON.parse(current) as { windowStart: number; count: number };
      windowStart = parsed.windowStart;
      count = parsed.count;

      if (now - windowStart > config.windowMs) {
        windowStart = now;
        count = 0;
      }
    } else {
      windowStart = now;
      count = 0;
    }

    count += 1;

    if (count > config.maxRequests) {
      const retryAfter = Math.ceil((config.windowMs - (now - windowStart)) / 1000);
      c.header('Retry-After', String(retryAfter));
      c.header('X-RateLimit-Limit', String(config.maxRequests));
      c.header('X-RateLimit-Remaining', '0');
      c.header('X-RateLimit-Reset', String(Math.ceil((windowStart + config.windowMs) / 1000)));
      throw new RateLimitError(`Too many requests. Retry after ${retryAfter} seconds.`);
    }

    const ttl = Math.ceil((config.windowMs - (now - windowStart)) / 1000);
    await c.env.KV.put(key, JSON.stringify({ windowStart, count }), { expirationTtl: ttl > 0 ? ttl : 60 });

    c.header('X-RateLimit-Limit', String(config.maxRequests));
    c.header('X-RateLimit-Remaining', String(config.maxRequests - count));
    c.header('X-RateLimit-Reset', String(Math.ceil((windowStart + config.windowMs) / 1000)));

    await next();
  } catch (error) {
    if (error instanceof RateLimitError) throw error;
    await next();
  }
};
