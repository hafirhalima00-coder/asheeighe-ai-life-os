import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';
import { RateLimitError } from '@pinkz/core/errors';

const mockKVGet = vi.fn();
const mockKVPut = vi.fn();

function createMockEnv() {
  return {
    DB: {} as any,
    KV: { get: mockKVGet, put: mockKVPut } as any,
    R2: {} as any,
    JWT_SECRET: 'test', JWT_REFRESH_SECRET: 'test',
    OPENAI_API_KEY: '', GEMINI_API_KEY: '', ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '', OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '', COMPOSIO_BASE_URL: '', APP_URL: '',
  };
}

async function setupApp() {
  const { rateLimitMiddleware } = await import('@pinkz/workers/api/src/middleware/rate-limit');
  const app = new Hono<any>();
  app.use('*', rateLimitMiddleware);
  app.get('/test', (c) => c.json({ success: true }));
  app.post('/auth/login', (c) => c.json({ success: true }));
  return app;
}

describe('Rate Limit Middleware', () => {
  let app: Hono<any>;

  beforeEach(async () => {
    vi.clearAllMocks();
    app = await setupApp();
  });

  it('allows requests under the limit', async () => {
    mockKVGet.mockResolvedValue(null);
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.status).toBe(200);
  });

  it('allows requests under the limit with existing count', async () => {
    mockKVGet.mockResolvedValue(JSON.stringify({ windowStart: Date.now(), count: 49 }));
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.status).toBe(200);
  });

  it('returns 429 when over the limit', async () => {
    mockKVGet.mockResolvedValue(JSON.stringify({ windowStart: Date.now() - 1000, count: 100 }));
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.status).toBe(429);
  });

  it('returns 429 on auth routes with lower limit', async () => {
    mockKVGet.mockResolvedValue(JSON.stringify({ windowStart: Date.now() - 1000, count: 10 }));
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    }, createMockEnv());

    expect(res.status).toBe(429);
  });

  it('resets count after window expires', async () => {
    const oldWindow = Date.now() - 120000;
    mockKVGet.mockResolvedValue(JSON.stringify({ windowStart: oldWindow, count: 100 }));
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.status).toBe(200);
  });

  it('sets rate limit headers', async () => {
    mockKVGet.mockResolvedValue(null);
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.headers.get('X-RateLimit-Limit')).toBe('100');
    expect(res.headers.get('X-RateLimit-Remaining')).toBe('99');
    expect(res.headers.get('X-RateLimit-Reset')).toBeTruthy();
  });

  it('sets Retry-After header when rate limited', async () => {
    mockKVGet.mockResolvedValue(JSON.stringify({ windowStart: Date.now() - 1000, count: 100 }));
    mockKVPut.mockResolvedValue(undefined);

    const res = await app.request('/test', {}, createMockEnv());
    expect(res.status).toBe(429);
    expect(res.headers.get('Retry-After')).toBeTruthy();
    expect(res.headers.get('X-RateLimit-Remaining')).toBe('0');
  });
});
