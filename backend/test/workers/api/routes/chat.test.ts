import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return { query: vi.fn() };
}

function createMockEnv() {
  return {
    DB: {} as any, KV: {} as any, R2: {} as any,
    JWT_SECRET: 'test', JWT_REFRESH_SECRET: 'test',
    OPENAI_API_KEY: 'sk-openai',
    GEMINI_API_KEY: '',
    ANTHROPIC_API_KEY: '',
    OLLAMA_BASE_URL: 'http://localhost:11434',
    OPENROUTER_API_KEY: '',
    COMPOSIO_API_KEY: '', COMPOSIO_BASE_URL: '', APP_URL: '',
  };
}

vi.mock('@pinkz/db', () => ({ createDB: vi.fn() }));
vi.mock('@pinkz/ai', () => ({
  createAIProvider: vi.fn(() => ({
    chat: vi.fn().mockResolvedValue({
      id: 'resp-1',
      model: 'gpt-4o',
      content: 'Hello! How can I help?',
      finishReason: 'stop',
      usage: { promptTokens: 10, completionTokens: 5, totalTokens: 15 },
    }),
    chatStream: vi.fn(),
    isAvailable: vi.fn().mockReturnValue(true),
    type: 'openai',
  })),
}));
vi.mock('@pinkz/workers/api/src/services/skill-registry', () => ({
  SkillRegistry: vi.fn(() => ({
    detectAndExecute: vi.fn().mockResolvedValue(null),
  })),
}));

async function setup() {
  const { default: chatRoutes } = await import('@pinkz/workers/api/src/routes/chat');
  const app = new Hono<any>();
  app.route('/', chatRoutes);
  return app;
}

describe('Chat Routes', () => {
  let app: Hono<any>;

  beforeEach(async () => {
    vi.clearAllMocks();
    app = await setup();
  });

  it('POST / - sends message with default provider', async () => {
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'Hello' }),
    }, { ...createMockEnv(), userId: 'user1', db: createMockDb() });

    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.data.message).toBe('Hello! How can I help?');
  });

  it('POST / - sends message with specific provider', async () => {
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'Hi', provider: 'openai' }),
    }, { ...createMockEnv(), userId: 'user1', db: createMockDb() });

    expect(res.status).toBe(200);
  });

  it('POST / - sends message with history', async () => {
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: 'What was that?',
        history: [{ role: 'assistant', content: 'Something' }],
      }),
    }, { ...createMockEnv(), userId: 'user1', db: createMockDb() });

    expect(res.status).toBe(200);
  });

  it('POST / - returns error when provider not available', async () => {
    const { createAIProvider } = await import('@pinkz/ai');
    (createAIProvider as any).mockReturnValueOnce({
      chat: vi.fn(),
      chatStream: vi.fn(),
      isAvailable: vi.fn().mockReturnValue(false),
      type: 'gemini',
    });

    const env = createMockEnv();
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'Hi', provider: 'gemini' }),
    }, { ...env, userId: 'user1', db: createMockDb() });

    expect(res.status).toBe(400);
  });

  it('POST / - returns 400 for empty message', async () => {
    const res = await app.request('/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: '' }),
    }, { ...createMockEnv(), userId: 'user1', db: createMockDb() });

    expect(res.status).toBe(400);
  });

  it('POST /providers - lists available providers', async () => {
    const res = await app.request('/providers', { method: 'POST' }, { ...createMockEnv(), userId: 'user1', db: createMockDb() });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.data.providers).toHaveLength(5);
  });
});
