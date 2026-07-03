import type { AIProvider, ChatMessage, ChatCompletionOptions, ChatCompletionResponse } from '../index';
import type { AIProviderConfig } from '@asheeighe/core';
import { ExternalServiceError } from '@asheeighe/core/errors';

export class AnthropicProvider implements AIProvider {
  readonly type = 'anthropic' as const;
  private readonly apiKey: string;
  private readonly baseUrl: string;
  private readonly defaultModel: string;
  private readonly defaultMaxTokens: number;
  private readonly defaultTemperature: number;

  constructor(config: AIProviderConfig) {
    if (!config.apiKey) throw new Error('Anthropic API key is required');
    this.apiKey = config.apiKey;
    this.baseUrl = 'https://api.anthropic.com/v1';
    this.defaultModel = config.model ?? 'claude-sonnet-4-20250514';
    this.defaultMaxTokens = config.maxTokens ?? 4096;
    this.defaultTemperature = config.temperature ?? 0.7;
  }

  isAvailable(): boolean {
    return !!this.apiKey;
  }

  async chat(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ChatCompletionResponse> {
    const { system, nonSystem } = this.splitMessages(messages);

    const response = await fetch(`${this.baseUrl}/messages`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        system: system.length > 0 ? system.map((m) => m.content).join('\n') : undefined,
        messages: nonSystem.map((m) => ({ role: m.role as 'user' | 'assistant', content: m.content })),
        max_tokens: options?.maxTokens ?? this.defaultMaxTokens,
        temperature: options?.temperature ?? this.defaultTemperature,
        stop_sequences: options?.stop,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Anthropic', `Request failed: ${response.status} ${body}`);
    }

    const data = await response.json() as {
      id: string;
      model: string;
      content: { text: string }[];
      stop_reason: string;
      usage: { input_tokens: number; output_tokens: number };
    };

    return {
      id: data.id,
      model: data.model,
      content: data.content.map((c) => c.text).join(''),
      finishReason: data.stop_reason,
      usage: {
        promptTokens: data.usage.input_tokens,
        completionTokens: data.usage.output_tokens,
        totalTokens: data.usage.input_tokens + data.usage.output_tokens,
      },
    };
  }

  async chatStream(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ReadableStream> {
    const { system, nonSystem } = this.splitMessages(messages);

    const response = await fetch(`${this.baseUrl}/messages`, {
      method: 'POST',
      headers: { ...this.getHeaders(), Accept: 'text/event-stream' },
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        system: system.length > 0 ? system.map((m) => m.content).join('\n') : undefined,
        messages: nonSystem.map((m) => ({ role: m.role as 'user' | 'assistant', content: m.content })),
        max_tokens: options?.maxTokens ?? this.defaultMaxTokens,
        temperature: options?.temperature ?? this.defaultTemperature,
        stream: true,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Anthropic', `Stream request failed: ${response.status} ${body}`);
    }

    return response.body!;
  }

  private getHeaders(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      'x-api-key': this.apiKey,
      'anthropic-version': '2023-06-01',
    };
  }

  private splitMessages(messages: ChatMessage[]): { system: ChatMessage[]; nonSystem: ChatMessage[] } {
    const system: ChatMessage[] = [];
    const nonSystem: ChatMessage[] = [];
    for (const m of messages) {
      if (m.role === 'system') system.push(m);
      else nonSystem.push(m);
    }
    return { system, nonSystem };
  }
}
