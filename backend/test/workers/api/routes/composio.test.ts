import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return {
    getConnectedAccounts: vi.fn(),
    findById: vi.fn(),
    delete: vi.fn(),
  };
}

function createMockEnv() {
  return {
    DB: {} as any, KV: {} as any, R2: {} as any,
    JWT_SECRET: 'test', JWT_REFRESH_SECRET: 'test',
    OPENAI_API_KEY: '', GEMINI_API_KEY: '', ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '', OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: 'composio-key',
    COMPOSIO_BASE_URL: 'https://backend.composio.dev/api',
    APP_URL: '',
  };
}

vi.mock('@pinkz/db', () => ({ createDB: vi.fn() }));
vi.mock('@pinkz/composio-client', () => ({
  ComposioClient: vi.fn(() => ({
    listIntegrations: vi.fn().mockResolvedValue([{ id: 'int-1', name: 'Google Calendar', authScheme: 'OAUTH2', description: '', categories: [] }]),
    getIntegration: vi.fn(),
    initiateConnection: vi.fn().mockResolvedValue({ connectionUrl: 'https://auth.example.com', connectionId: 'conn-1' }),
    validateConnection: vi.fn().mockResolvedValue({ id: 'conn-1', status: 'ACTIVE' }),
    listActions: vi.fn().mockResolvedValue([]),
    executeAction: vi.fn().mockResolvedValue({ success: true, data: {} }),
    deleteConnection: vi.fn().mockResolvedValue(undefined),
  })),
}));

async function setup() {
  const { default: composioRoutes } = await import('@pinkz/workers/api/src/routes/composio');
  const app = new Hono<any>();
  app.route('/', composioRoutes);
  return app;
}

describe('Composio Routes', () => {
  let app: Hono<any>;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    app = await setup();
  });

  it('GET /integrations - lists integrations', async () => {
    const res = await app.request('/integrations', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.data).toHaveLength(1);
  });

  it('GET /connections - lists user connections', async () => {
    mockDb.getConnectedAccounts.mockResolvedValue([{ id: 'c1', integrationName: 'Google' }]);
    const res = await app.request('/connections', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /connections/initiate - initiates connection', async () => {
    const res = await app.request('/connections/initiate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ integrationId: 'int-1', redirectUri: 'https://pinkz.app/callback' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.data.connectionUrl).toBe('https://auth.example.com');
  });

  it('POST /connections/initiate - validates URL', async () => {
    const res = await app.request('/connections/initiate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ integrationId: 'int-1', redirectUri: 'not-a-url' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(400);
  });

  it('POST /connections/:id/validate - validates connection', async () => {
    mockDb.findById.mockResolvedValue({ id: 'conn-1', user_id: 'user1' });
    const res = await app.request('/connections/conn-1/validate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
  });

  it('POST /connections/:id/validate - returns 404 for wrong user', async () => {
    mockDb.findById.mockResolvedValue({ id: 'conn-1', user_id: 'other-user' });
    const res = await app.request('/connections/conn-1/validate', {
      method: 'POST',
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(404);
  });

  it('GET /actions - lists actions', async () => {
    const res = await app.request('/actions', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /actions - filters by appName', async () => {
    const res = await app.request('/actions?appName=slack', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /actions/execute - executes action', async () => {
    const res = await app.request('/actions/execute', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ connectionId: 'conn-1', actionName: 'send_message', input: { text: 'Hello' } }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
  });

  it('DELETE /connections/:id - deletes connection', async () => {
    mockDb.findById.mockResolvedValue({ id: 'conn-1', user_id: 'user1' });
    mockDb.delete.mockResolvedValue(undefined);

    const res = await app.request('/connections/conn-1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('DELETE /connections/:id - returns 404 for wrong user', async () => {
    mockDb.findById.mockResolvedValue({ id: 'conn-1', user_id: 'other-user' });
    const res = await app.request('/connections/conn-1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });
});
