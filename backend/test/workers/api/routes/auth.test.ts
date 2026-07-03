import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';
import type { AppEnv } from '@pinkz/workers/api/src/types';

vi.mock('@pinkz/db', () => ({
  createDB: vi.fn(() => ({
    userExists: vi.fn(),
    createUser: vi.fn(),
    findByEmail: vi.fn(),
    findById: vi.fn(),
    get: vi.fn(),
  })),
}));

vi.mock('jsonwebtoken', () => ({
  default: {
    sign: vi.fn(() => 'mock-token'),
    verify: vi.fn(),
    decode: vi.fn(),
  },
}));

function createMockEnv(): AppEnv['Bindings'] {
  return {
    DB: {} as any,
    KV: {
      get: vi.fn(),
      put: vi.fn(),
    } as any,
    R2: {} as any,
    JWT_SECRET: 'test-secret',
    JWT_REFRESH_SECRET: 'test-refresh-secret',
    OPENAI_API_KEY: '',
    GEMINI_API_KEY: '',
    ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '',
    OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '',
    COMPOSIO_BASE_URL: '',
    APP_URL: 'http://localhost',
  };
}

describe('Auth Routes', () => {
  let app: Hono<AppEnv>;
  let mockEnv: AppEnv['Bindings'];

  beforeEach(() => {
    vi.clearAllMocks();
    mockEnv = createMockEnv();
    app = new Hono<AppEnv>();
    const authModule = vi.mocked(require('@pinkz/workers/api/src/routes/auth'));
    app.route('/auth', authModule.default);
  });

  describe('POST /auth/register', () => {
    it('registers a new user successfully', async () => {
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.userExists as any).mockResolvedValue(false);
      (mockDb.createUser as any).mockResolvedValue({ id: 'user-1', email: 'test@test.com', displayName: 'Test' });

      const res = await app.request('/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'test@test.com', password: 'password123', displayName: 'Test' }),
      }, mockEnv);

      expect(res.status).toBe(201);
      const body = await res.json();
      expect(body.success).toBe(true);
    });

    it('returns 409 for duplicate email', async () => {
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.userExists as any).mockResolvedValue(true);

      const res = await app.request('/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'exists@test.com', password: 'password123' }),
      }, mockEnv);

      expect(res.status).toBe(409);
    });

    it('returns 400 for invalid email', async () => {
      const res = await app.request('/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'invalid', password: 'password123' }),
      }, mockEnv);

      expect(res.status).toBe(400);
    });

    it('returns 400 for short password', async () => {
      const res = await app.request('/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'test@test.com', password: 'short' }),
      }, mockEnv);

      expect(res.status).toBe(400);
    });
  });

  describe('POST /auth/login', () => {
    it('logs in successfully', async () => {
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.findByEmail as any).mockResolvedValue({
        id: 'user-1',
        email: 'test@test.com',
        passwordHash: '74657374:hash',
      });

      const res = await app.request('/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'test@test.com', password: 'password123' }),
      }, mockEnv);

      expect(res.status).toBe(200);
    });

    it('returns 401 for wrong password', async () => {
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.findByEmail as any).mockResolvedValue({
        id: 'user-1',
        email: 'test@test.com',
        passwordHash: 'salt:differenthash',
      });

      const res = await app.request('/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'test@test.com', password: 'wrongpassword' }),
      }, mockEnv);

      expect(res.status).toBe(401);
    });

    it('returns 401 for non-existent user', async () => {
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.findByEmail as any).mockResolvedValue(null);

      const res = await app.request('/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'nobody@test.com', password: 'password123' }),
      }, mockEnv);

      expect(res.status).toBe(401);
    });
  });

  describe('POST /auth/refresh', () => {
    it('refreshes token successfully', async () => {
      const jwt = await import('jsonwebtoken');
      (jwt.default.verify as any).mockReturnValue({ sub: 'user-1', email: 'test@test.com', type: 'refresh' });
      const { createDB } = await import('@pinkz/db');
      const mockDb = createDB({} as any);
      (mockDb.findById as any).mockResolvedValue({ id: 'user-1', email: 'test@test.com' });

      const res = await app.request('/auth/refresh', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refreshToken: 'valid-refresh-token' }),
      }, mockEnv);

      expect(res.status).toBe(200);
    });

    it('returns 401 for invalid refresh token', async () => {
      const jwt = await import('jsonwebtoken');
      (jwt.default.verify as any).mockImplementation(() => { throw new Error('invalid'); });

      const res = await app.request('/auth/refresh', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refreshToken: 'invalid-token' }),
      }, mockEnv);

      expect(res.status).toBe(401);
    });
  });

  describe('POST /auth/logout', () => {
    it('logs out successfully', async () => {
      const res = await app.request('/auth/logout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
      }, mockEnv);

      expect(res.status).toBe(200);
    });
  });
});
