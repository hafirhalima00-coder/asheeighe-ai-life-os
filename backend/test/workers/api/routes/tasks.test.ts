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

vi.mock('@pinkz/db', () => ({ createDB: vi.fn() }));

async function setup() {
  const { default: tasksRoutes } = await import('@pinkz/workers/api/src/routes/tasks');
  const app = new Hono<any>();
  app.route('/', tasksRoutes);
  return app;
}

describe('Tasks Routes', () => {
  let app: Hono<any>;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    const { createDB } = await import('@pinkz/db');
    (createDB as any).mockReturnValue(mockDb);
    app = await setup();
  });

  it('GET / - lists tasks with status filtering', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [{ id: '1', title: 'Task 1' }], total: 1 });
    const res = await app.request('/?status=pending', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
  });

  it('GET / - lists tasks with category and priority', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [], total: 0 });
    const res = await app.request('/?category=work&priority=high', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET / - lists tasks without filters', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [], total: 0 });
    const res = await app.request('/', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns single task', async () => {
    mockDb.findById.mockResolvedValue({ id: 'task-1', user_id: 'user1', title: 'My Task' });
    const res = await app.request('/task-1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns 404 for non-existent task', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('GET /:id - returns 404 for other user task', async () => {
    mockDb.findById.mockResolvedValue({ id: 'task-1', user_id: 'other-user' });
    const res = await app.request('/task-1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST / - creates task', async () => {
    mockDb.findById.mockResolvedValue(null);
    mockDb.insert.mockResolvedValue(undefined);

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'New Task', priority: 'high' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
  });

  it('POST / - validates parent task exists', async () => {
    mockDb.findById.mockResolvedValueOnce(null).mockResolvedValueOnce(null);

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Subtask', parentTaskId: 'missing-parent' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(400);
  });

  it('PUT /:id - updates task', async () => {
    mockDb.findById.mockResolvedValue({ id: 'task-1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/task-1', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated', status: 'completed' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
  });

  it('PUT /:id - returns 404 for non-existent task', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('DELETE /:id - deletes task', async () => {
    mockDb.findById.mockResolvedValue({ id: 'task-1', user_id: 'user1' });
    mockDb.delete.mockResolvedValue(undefined);
    const res = await app.request('/task-1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('DELETE /:id - returns 404 for non-existent task', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST /:id/complete - completes task', async () => {
    mockDb.findById.mockResolvedValue({ id: 'task-1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/task-1/complete', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /:id/complete - returns 404 for non-existent task', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing/complete', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });
});
