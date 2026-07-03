import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { createAIProvider, type ChatMessage } from '@pinkz/ai';
import { SkillRegistry } from '../services/skill-registry';
import { ValidationError } from '@pinkz/core/errors';
import type { AIProviderType } from '@pinkz/core';

const chat = new Hono<AppEnv>();

const chatSchema = z.object({
  message: z.string().min(1).max(10000),
  provider: z.enum(['openai', 'gemini', 'anthropic', 'ollama', 'openrouter']).optional().default('openai'),
  model: z.string().optional(),
  temperature: z.number().min(0).max(2).optional(),
  stream: z.boolean().optional().default(false),
  history: z.array(z.object({
    role: z.enum(['user', 'assistant', 'system']),
    content: z.string(),
  })).optional().default([]),
});

function getProviderConfig(env: AppEnv['Bindings'], provider: AIProviderType) {
  const configs: Record<AIProviderType, { apiKey?: string; baseUrl?: string }> = {
    openai: { apiKey: env.OPENAI_API_KEY },
    gemini: { apiKey: env.GEMINI_API_KEY },
    anthropic: { apiKey: env.ANTHROPIC_API_KEY },
    ollama: { baseUrl: env.OLLAMA_BASE_URL },
    openrouter: { apiKey: env.OPENROUTER_API_KEY },
  };
  return configs[provider] ?? {};
}

chat.post('/', zValidator('json', chatSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');
  const env = c.env;

  const providerConfig = getProviderConfig(env, body.provider as AIProviderType);
  const ai = createAIProvider({
    type: body.provider as AIProviderType,
    ...providerConfig,
    model: body.model,
    temperature: body.temperature,
  });

  if (!ai.isAvailable()) {
    throw new ValidationError(`AI provider '${body.provider}' is not configured. Set ${body.provider.toUpperCase()}_API_KEY.`);
  }

  const skillRegistry = new SkillRegistry(db, ai, userId);
  const systemPrompt = `You are PINKZ AI, a helpful productivity assistant integrated with the user's calendar, tasks, notes, and reminders.

You have access to skills that let you interact with the user's data. When the user asks to:
- Create, update, delete, or list tasks → use the task skills
- Create, update, delete, or list calendar events → use the event skills
- Create, update, delete, or list notes → use the note skills
- Create, dismiss, or list reminders → use the reminder skills
- Summarize or analyze data → use the analyze skill

For general conversation, respond helpfully.
Always be concise and action-oriented.

Current time: ${new Date().toISOString()}`;

  const allHistory: ChatMessage[] = [
    { role: 'system', content: systemPrompt },
    ...body.history.map((h) => ({ role: h.role as ChatMessage['role'], content: h.content })),
    { role: 'user', content: body.message },
  ];

  if (body.stream) {
    const stream = await ai.chatStream(allHistory);
    return new Response(stream, {
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        Connection: 'keep-alive',
      },
    });
  }

  const response = await ai.chat(allHistory, { temperature: body.temperature });
  const assistantMessage = response.content;

  let skillResult: { action: string; data: unknown } | null = null;
  try {
    skillResult = await skillRegistry.detectAndExecute(assistantMessage);
  } catch {
    // skill execution is best-effort
  }

  return c.json({
    success: true,
    data: {
      message: assistantMessage,
      usage: response.usage,
      model: response.model,
      skillResult,
    },
  });
});

chat.post('/providers', async (c) => {
  const env = c.env;
  const providers = [
    { type: 'openai', available: !!env.OPENAI_API_KEY, models: ['gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo'] },
    { type: 'gemini', available: !!env.GEMINI_API_KEY, models: ['gemini-2.0-flash', 'gemini-2.0-pro'] },
    { type: 'anthropic', available: !!env.ANTHROPIC_API_KEY, models: ['claude-sonnet-4-20250514', 'claude-haiku-3-5'] },
    { type: 'ollama', available: true, models: ['llama3.2', 'mistral', 'codellama'] },
    { type: 'openrouter', available: !!env.OPENROUTER_API_KEY, models: ['openai/gpt-4o', 'anthropic/claude-sonnet-4'] },
  ] as const;

  return c.json({ success: true, data: { providers } });
});

export default chat;
