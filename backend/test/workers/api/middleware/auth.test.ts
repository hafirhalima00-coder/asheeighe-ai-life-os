import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';
import { AuthError } from '@pinkz/core/errors';

vi.mock('jsonwebtoken', () => ({
  default: {
    verify: vi.fn(),
    TokenExpiredError: class TokenExpiredError extends Error {
      constructor() { super('Token expired'); this.name = 'TokenExpiredError'; }
    },
    JsonWebTokenError: class JsonWebTokenError extends Error {
      constructor() { super('Invalid token'); this.name = 'JsonWebTokenError'; }
    },
  },
}));

vi.mock('@pinkz/db', () => ({
  createDB: vi.fn(() => ({
    findById: vi.fn(),
  })),
}));

function createMockEnv() {
  return {
    DB: {} as any, KV: {} as any, R2: {} as any,
    JWT_SECRET: 'test-secret', JWT_REFRESH_SECRET: 'test-refresh',
    OPENAI_API_KEY: '', GEMINI_API_KEY: '', ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '', OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '', COMPOSIO_BASE_URL: '', APP_URL: '',
  };
}

async function setupApp() {
  const { authMiddleware } = await import('@pinkz/workers/api/src/middleware/auth');
  const app = new Hono<any>();
  app.use('*', authMiddleware);
  app.get('/protected', (c) => c.json({ success: true, userId: c.get('userId') }));
  return app;
}

describe('Auth Middleware', () => {
  let app: Hono<any>;

  beforeEach(async () => {
    vi.clearAllMocks();
    app = await setupApp();
  });

  it('passes through with valid JWT', async () => {
    const jwt = await import('jsonwebtoken');
    (jwt.default.verify as any).mockReturnValue({ sub: 'user-1', email: 'test@test.com', iat: 100, exp: 9999999999 });

    const { createDB } = await import('@pinkz/db');
    const mockDb = createDB({} as any);
    (mockDb.findById as any).mockResolvedValue({
      id: 'user-1', email: 'test@test.com', display_name: 'Test',
      timezone: 'UTC', email_verified: 1, role: 'user',
      created_at: '2026-01-01', updated_at: '2026-01-01',
    });

    const res = await app.request('/protected', {
      headers: { Authorization: 'Bearer valid-token' },
    }, createMockEnv());

    expect(res.status).toBe(200);
  });

  it('returns 401 when Authorization header is missing', async () => {
    const res = await app.request('/protected', {}, createMockEnv());
    expect(res.status).toBe(401);
  });

  it('returns 401 when Authorization header is malformed', async () => {
    const res = await app.request('/protected', {
      headers: { Authorization: 'NotBearer token' },
    }, createMockEnv());
    expect(res.status).toBe(401);
  });

  it('returns 401 when token is empty', async () => {
    const res = await app.request('/protected', {
      headers: { Authorization: 'Bearer ' },
    }, createMockEnv());
    expect(res.status).toBe(401);
  });

  it('returns 401 when token has expired', async () => {
    const jwt = await import('jsonwebtoken');
    (jwt.default.verify as any).mockImplementation(() => {
      throw new (jwt as any).TokenExpiredError();
    });

    const res = await app.request('/protected', {
      headers: { Authorization: 'Bearer expired-token' },
    }, createMockEnv());

    expect(res.status).toBe(401);
  });

  it('returns 401 when token is invalid', async () => {
    const jwt = await import('jsonwebtoken');
    (jwt.default.verify as any).mockImplementation(() => {
      throw new (jwt as any).JsonWebTokenError();
    });

    const res = await app.request('/protected', {
      headers: { Authorization: 'Bearer bad-token' },
    }, createMockEnv());

    expect(res.status).toBe(401);
  });

  it('returns 401 when user not found in DB', async () => {
    const jwt = await import('jsonwebtoken');
    (jwt.default.verify as any).mockReturnValue({ sub: 'missing-user', email: 'test@test.com', iat: 100, exp: 9999999999 });

    const { createDB } = await import('@pinkz/db');
    const mockDb = createDB({} as any);
    (mockDb.findById as any).mockResolvedValue(null);

    const res = await app.request('/protected', {
      headers: { Authorization: 'Bearer valid-token' },
    }, createMockEnv());

    expect(res.status).toBe(401);
  });
});
