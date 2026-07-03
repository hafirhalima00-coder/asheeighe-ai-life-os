import type { AIProvider, ChatMessage, ChatCompletionOptions, ChatCompletionResponse } from '../index';
import type { AIProviderConfig } from '@asheeighe/core';
import { ExternalServiceError } from '@asheeighe/core/errors';

export class OllamaProvider implements AIProvider {
  readonly type = 'ollama' as const;
  private readonly baseUrl: string;
  private readonly defaultModel: string;
  private readonly defaultMaxTokens: number;
  private readonly defaultTemperature: number;

  constructor(config: AIProviderConfig) {
    this.baseUrl = config.baseUrl ?? 'http://localhost:11434';
    this.defaultModel = config.model ?? 'llama3.2';
    this.defaultMaxTokens = config.maxTokens ?? 4096;
    this.defaultTemperature = config.temperature ?? 0.7;
  }

  isAvailable(): boolean {
    return true;
  }

  async chat(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ChatCompletionResponse> {
    const response = await fetch(`${this.baseUrl}/api/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        messages: messages.map((m) => ({
          role: m.role,
          content: m.content,
        })),
        options: {
          num_predict: options?.maxTokens ?? this.defaultMaxTokens,
          temperature: options?.temperature ?? this.defaultTemperature,
          stop: options?.stop,
        },
        stream: false,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Ollama', `Request failed: ${response.status} ${body}`);
    }

    const data = await response.json() as {
      model: string;
      message?: { content: string };
      done_reason?: string;
    };

    return {
      id: crypto.randomUUID(),
      model: data.model,
      content: data.message?.content ?? '',
      finishReason: data.done_reason ?? 'stop',
      usage: { promptTokens: 0, completionTokens: 0, totalTokens: 0 },
    };
  }

  async chatStream(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ReadableStream> {
    const response = await fetch(`${this.baseUrl}/api/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        messages: messages.map((m) => ({ role: m.role, content: m.content })),
        options: {
          num_predict: options?.maxTokens ?? this.defaultMaxTokens,
          temperature: options?.temperature ?? this.defaultTemperature,
        },
        stream: true,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Ollama', `Stream request failed: ${response.status} ${body}`);
    }

    return response.body!;
  }
}
