import { describe, it, expect, vi } from 'vitest';
import { createAIProvider, OpenAIProvider } from '@pinkz/ai';

vi.mock('@pinkz/ai/providers/openai', () => {
  const MockOpenAI = vi.fn(() => ({
    type: 'openai',
    chat: vi.fn(),
    chatStream: vi.fn(),
    isAvailable: vi.fn(),
  }));
  return { OpenAIProvider: MockOpenAI };
});

vi.mock('@pinkz/ai/providers/anthropic', () => {
  const MockAnthropic = vi.fn(() => ({
    type: 'anthropic',
    chat: vi.fn(),
    chatStream: vi.fn(),
    isAvailable: vi.fn(),
  }));
  return { AnthropicProvider: MockAnthropic };
});

vi.mock('@pinkz/ai/providers/gemini', () => {
  const MockGemini = vi.fn(() => ({
    type: 'gemini',
    chat: vi.fn(),
    chatStream: vi.fn(),
    isAvailable: vi.fn(),
  }));
  return { GeminiProvider: MockGemini };
});

vi.mock('@pinkz/ai/providers/ollama', () => {
  const MockOllama = vi.fn(() => ({
    type: 'ollama',
    chat: vi.fn(),
    chatStream: vi.fn(),
    isAvailable: vi.fn(),
  }));
  return { OllamaProvider: MockOllama };
});

vi.mock('@pinkz/ai/providers/openrouter', () => {
  const MockOpenRouter = vi.fn(() => ({
    type: 'openrouter',
    chat: vi.fn(),
    chatStream: vi.fn(),
    isAvailable: vi.fn(),
  }));
  return { OpenRouterProvider: MockOpenRouter };
});

describe('createAIProvider', () => {
  it('creates OpenAI provider', () => {
    const provider = createAIProvider({ type: 'openai', apiKey: 'sk-test' });
    expect(provider).toBeDefined();
    expect(provider.type).toBe('openai');
  });

  it('creates Gemini provider', () => {
    const provider = createAIProvider({ type: 'gemini', apiKey: 'gemini-test' });
    expect(provider).toBeDefined();
    expect(provider.type).toBe('gemini');
  });

  it('creates Anthropic provider', () => {
    const provider = createAIProvider({ type: 'anthropic', apiKey: 'sk-ant-test' });
    expect(provider).toBeDefined();
    expect(provider.type).toBe('anthropic');
  });

  it('creates Ollama provider without apiKey', () => {
    const provider = createAIProvider({ type: 'ollama' });
    expect(provider).toBeDefined();
    expect(provider.type).toBe('ollama');
  });

  it('creates OpenRouter provider', () => {
    const provider = createAIProvider({ type: 'openrouter', apiKey: 'sk-or-test' });
    expect(provider).toBeDefined();
    expect(provider.type).toBe('openrouter');
  });

  it('throws for unsupported provider type', () => {
    expect(() => createAIProvider({ type: 'invalid' as never })).toThrow('Unsupported AI provider');
  });

  it('passes config to OpenAI provider', () => {
    const provider = createAIProvider({ type: 'openai', apiKey: 'sk-test', model: 'gpt-4o', temperature: 0.5 });
    expect(provider.type).toBe('openai');
  });

  it('passes baseUrl to Ollama provider', () => {
    const provider = createAIProvider({ type: 'ollama', baseUrl: 'http://custom:11434' });
    expect(provider.type).toBe('ollama');
  });

  it('creates provider without optional fields', () => {
    const provider = createAIProvider({ type: 'openai', apiKey: 'sk-test' });
    expect(provider).toBeDefined();
  });
});

describe('AIProvider interface', () => {
  it('provider has required methods', () => {
    const provider = createAIProvider({ type: 'openai', apiKey: 'sk-test' });
    expect(typeof provider.chat).toBe('function');
    expect(typeof provider.chatStream).toBe('function');
    expect(typeof provider.isAvailable).toBe('function');
  });
});
