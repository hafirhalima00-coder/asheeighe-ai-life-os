import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return {
    findByUserId: vi.fn(),
    findById: vi.fn(),
    insert: vi.fn(),
    update: vi.fn(),
    delete: vi.fn(),
    getNotesByNotebook: vi.fn(),
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
  const { default: notesRoutes } = await import('@asheeighe/workers/api/src/routes/notes');
  const app = new Hono<any>();
  app.route('/', notesRoutes);
  return app;
}

describe('Notes Routes', () => {
  let app: Hono<any>;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    const { createDB } = await import('@asheeighe/db');
    (createDB as any).mockReturnValue(mockDb);
    app = await setup();
  });

  it('GET / - lists non-archived notes by default', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [{ id: 'n1', title: 'Note 1' }], total: 1 });
    const res = await app.request('/', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
  });

  it('GET / - filters by archived', async () => {
    mockDb.findByUserId.mockResolvedValue({ data: [], total: 0 });
    const res = await app.request('/?archived=true', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET / - filters by notebookId', async () => {
    mockDb.getNotesByNotebook.mockResolvedValue([]);
    const res = await app.request('/?notebookId=nb-1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET / - filters by notebookId=null', async () => {
    mockDb.getNotesByNotebook.mockResolvedValue([]);
    const res = await app.request('/?notebookId=null', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns single note', async () => {
    mockDb.findById.mockResolvedValue({ id: 'n1', user_id: 'user1', title: 'My Note' });
    const res = await app.request('/n1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns 404 for non-existent note', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST / - creates note', async () => {
    mockDb.insert.mockResolvedValue(undefined);
    mockDb.findById.mockResolvedValue({ id: 'n1', title: 'New Note' });

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'New Note', content: 'Hello', contentType: 'markdown' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
  });

  it('POST / - creates note with tags and pinned', async () => {
    mockDb.insert.mockResolvedValue(undefined);
    mockDb.findById.mockResolvedValue({ id: 'n2' });

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Pinned', tags: ['important'], pinned: true }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
  });

  it('PUT /:id - updates note', async () => {
    mockDb.findById.mockResolvedValue({ id: 'n1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/n1', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ content: 'Updated content' }),
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

  it('DELETE /:id - deletes note', async () => {
    mockDb.findById.mockResolvedValue({ id: 'n1', user_id: 'user1' });
    mockDb.delete.mockResolvedValue(undefined);
    const res = await app.request('/n1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('DELETE /:id - returns 404 for non-existent', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('POST /:id/pin - toggles pin', async () => {
    mockDb.findById.mockResolvedValue({ id: 'n1', user_id: 'user1', pinned: 0 });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/n1/pin', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /:id/pin - unpins when already pinned', async () => {
    mockDb.findById.mockResolvedValue({ id: 'n1', user_id: 'user1', pinned: 1 });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/n1/pin', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST /:id/pin - returns 404 for non-existent', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing/pin', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });
});
