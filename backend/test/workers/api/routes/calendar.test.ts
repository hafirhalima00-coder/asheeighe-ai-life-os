import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return {
    getCalendarEvents: vi.fn(),
    findById: vi.fn(),
    insert: vi.fn(),
    update: vi.fn(),
    delete: vi.fn(),
    query: vi.fn(),
  };
}

function createMockEnv() {
  return {
    DB: {} as any,
    KV: {} as any,
    R2: {} as any,
    JWT_SECRET: 'test',
    JWT_REFRESH_SECRET: 'test',
    OPENAI_API_KEY: '',
    GEMINI_API_KEY: '',
    ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: '',
    OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '',
    COMPOSIO_BASE_URL: '',
    APP_URL: '',
  };
}

vi.mock('@asheeighe/db', () => ({ createDB: vi.fn() }));

async function setup() {
  const { default: calendarRoutes } = await import('@asheeighe/workers/api/src/routes/calendar');
  const app = new Hono<any>();
  app.route('/', calendarRoutes);
  return app;
}

describe('Calendar Routes', () => {
  let app: Hono<any>;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    const { createDB } = await import('@asheeighe/db');
    (createDB as any).mockReturnValue(mockDb);
    app = await setup();
  });

  it('GET / - lists events with date range', async () => {
    mockDb.getCalendarEvents.mockResolvedValue([{ id: '1', title: 'Meeting' }]);
    const res = await app.request('/?startDate=2026-01-01&endDate=2026-12-31', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.data).toHaveLength(1);
  });

  it('GET / - lists events without date range', async () => {
    mockDb.getCalendarEvents.mockResolvedValue([]);
    const res = await app.request('/', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('POST / - creates event successfully', async () => {
    mockDb.insert.mockResolvedValue(undefined);
    mockDb.findById.mockResolvedValue({ id: 'evt-1', title: 'Test Event', start_time: '2026-07-03T10:00:00Z' });

    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Test Event',
        startTime: '2026-07-03T10:00:00Z',
        endTime: '2026-07-03T11:00:00Z',
      }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(201);
    const body = await res.json();
    expect(body.success).toBe(true);
  });

  it('POST / - returns 400 when startTime >= endTime', async () => {
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Bad Event',
        startTime: '2026-07-03T12:00:00Z',
        endTime: '2026-07-03T11:00:00Z',
      }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(400);
  });

  it('GET /:id - returns single event', async () => {
    mockDb.findById.mockResolvedValue({ id: 'evt-1', user_id: 'user1', title: 'My Event' });
    const res = await app.request('/evt-1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('GET /:id - returns 404 for non-existent event', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('GET /:id - returns 404 for other user event', async () => {
    mockDb.findById.mockResolvedValue({ id: 'evt-1', user_id: 'other-user' });
    const res = await app.request('/evt-1', {}, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('PUT /:id - updates event', async () => {
    mockDb.findById.mockResolvedValue({ id: 'evt-1', user_id: 'user1' });
    mockDb.update.mockResolvedValue(undefined);

    const res = await app.request('/evt-1', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated Title' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });

    expect(res.status).toBe(200);
  });

  it('PUT /:id - returns 404 for non-existent event', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: 'Updated' }),
    }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });

  it('DELETE /:id - deletes event', async () => {
    mockDb.findById.mockResolvedValue({ id: 'evt-1', user_id: 'user1' });
    mockDb.delete.mockResolvedValue(undefined);

    const res = await app.request('/evt-1', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(200);
  });

  it('DELETE /:id - returns 404 for non-existent event', async () => {
    mockDb.findById.mockResolvedValue(null);
    const res = await app.request('/missing', { method: 'DELETE' }, { ...createMockEnv(), userId: 'user1', db: mockDb });
    expect(res.status).toBe(404);
  });
});
