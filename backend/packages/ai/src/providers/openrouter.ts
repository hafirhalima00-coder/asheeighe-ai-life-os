import type { AIProvider, ChatMessage, ChatCompletionOptions, ChatCompletionResponse } from '../index';
import type { AIProviderConfig } from '@pinkz/core';
import { ExternalServiceError } from '@pinkz/core/errors';

export class OpenRouterProvider implements AIProvider {
  readonly type = 'openrouter' as const;
  private readonly apiKey: string;
  private readonly baseUrl: string;
  private readonly defaultModel: string;
  private readonly defaultMaxTokens: number;
  private readonly defaultTemperature: number;

  constructor(config: AIProviderConfig) {
    if (!config.apiKey) throw new Error('OpenRouter API key is required');
    this.apiKey = config.apiKey;
    this.baseUrl = 'https://openrouter.ai/api/v1';
    this.defaultModel = config.model ?? 'openai/gpt-4o';
    this.defaultMaxTokens = config.maxTokens ?? 4096;
    this.defaultTemperature = config.temperature ?? 0.7;
  }

  isAvailable(): boolean {
    return !!this.apiKey;
  }

  async chat(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ChatCompletionResponse> {
    const response = await fetch(`${this.baseUrl}/chat/completions`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        messages: messages.map(this.formatMessage),
        max_tokens: options?.maxTokens ?? this.defaultMaxTokens,
        temperature: options?.temperature ?? this.defaultTemperature,
        stop: options?.stop,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('OpenRouter', `Request failed: ${response.status} ${body}`);
    }

    const data = await response.json() as {
      id: string;
      model: string;
      choices: { message: { content: string | null }; finish_reason: string }[];
      usage: { prompt_tokens: number; completion_tokens: number; total_tokens: number };
    };

    const choice = data.choices[0];
    if (!choice) throw new ExternalServiceError('OpenRouter', 'No completion returned');

    return {
      id: data.id,
      model: data.model,
      content: choice.message.content ?? '',
      finishReason: choice.finish_reason,
      usage: {
        promptTokens: data.usage.prompt_tokens,
        completionTokens: data.usage.completion_tokens,
        totalTokens: data.usage.total_tokens,
      },
    };
  }

  async chatStream(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ReadableStream> {
    const response = await fetch(`${this.baseUrl}/chat/completions`, {
      method: 'POST',
      headers: { ...this.getHeaders(), Accept: 'text/event-stream' },
      body: JSON.stringify({
        model: options?.model ?? this.defaultModel,
        messages: messages.map(this.formatMessage),
        max_tokens: options?.maxTokens ?? this.defaultMaxTokens,
        temperature: options?.temperature ?? this.defaultTemperature,
        stream: true,
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('OpenRouter', `Stream request failed: ${response.status} ${body}`);
    }

    return response.body!;
  }

  private getHeaders(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${this.apiKey}`,
      'HTTP-Referer': 'https://pinkz.app',
      'X-Title': 'PINKZ',
    };
  }

  private formatMessage(msg: ChatMessage): Record<string, unknown> {
    const formatted: Record<string, unknown> = { role: msg.role, content: msg.content };
    if (msg.name) formatted.name = msg.name;
    return formatted;
  }
}
