import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return {
    findByUserId: vi.fn(),
    findById: vi.fn(),
    insert: vi.fn(),
    update: vi.fn(),
    delete: vi.fn(),
  };
}

function createMockEnv() {
  return {
    DB: {} as any, KV: {} as any, R2: {} as any,
    JWT_SECRET: 'test', JWT_REFRESH_SECRET: 'test',
    OPENAI_API_KEY: '', GEMINI_API_KEY: '', ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '', OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '', COMPOSIO_BASE_URL: '', APP_URL: '',
  };
}

vi.mock('@asheeighe/db', () => ({ createDB: vi.fn() }));

async function setup() {
  const { default: remindersRoutes } = await import('@asheeighe/workers/api/src/routes/reminders');
  const app = new Hono<any>();
  app.route('/', remindersRoutes);
  return app;
}

describe('Reminders Routes', () => {
  let app: Hono<any>;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    const { createDB } = await import('@asheeighe/db');
    (createDB as any).mockReturnValue(mockDb);
    app = await setup();
  });

  it('GET / - lists reminders', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [{ id: 'r1' }], total: 1 });
    const res = await app.request('/', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET / - filters by dismissed status', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [], total: 0 });
    const res = await app.request('/?dismissed=true', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns single reminder', async () => {
    mockDb.findById.mockResolvedValue({ id: 'r1', user_id: 'user1' });
    const res = await app.request('/r1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns 404 for non-existent reminder', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST / - creates reminder', async () => {
    mockDb.insert.mockResolvedValue(undefined);
    mockDb.findById.mockResolvedValue({ id: 'r1', title: 'Test' });

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Test Reminder', remindAt: '2026-07-03T14:00:00Z' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
  });

  it('POST / - creates reminder with linked entity', async () => {
    mockDb.insert.mockResolvedValue(undefined);
    mockDb.findById.mockResolvedValue({ id: 'r2' });

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Linked Reminder',
        remindAt: '2026-07-03T14:00:00Z',
        linkedEntityType: 'task',
        linkedEntityId: 'task-1',
      }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
  });

  it('PUT /:id - updates reminder', async () => {
    mockDb.findById.mockResolvedValue({ id: 'r1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/r1', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
  });

  it('PUT /:id - returns 404 for non-existent', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('DELETE /:id - deletes reminder', async () => {
    mockDb.findById.mockResolvedValue({ id: 'r1', user_id: 'user1' });
    mockDb.delete.mockResolvedValue(undefined);
    const res = await app.request('/r1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('DELETE /:id - returns 404 for non-existent', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST /:id/dismiss - dismisses reminder', async () => {
    mockDb.findById.mockResolvedValue({ id: 'r1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/r1/dismiss', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /:id/dismiss - returns 404 for non-existent', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing/dismiss', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });
});
