import type { AIProvider, ChatMessage, ChatCompletionOptions, ChatCompletionResponse } from '../index';
import type { AIProviderConfig } from '@asheeighe/core';
import { ExternalServiceError } from '@asheeighe/core/errors';

export class GeminiProvider implements AIProvider {
  readonly type = 'gemini' as const;
  private readonly apiKey: string;
  private readonly baseUrl: string;
  private readonly defaultModel: string;
  private readonly defaultMaxTokens: number;
  private readonly defaultTemperature: number;

  constructor(config: AIProviderConfig) {
    if (!config.apiKey) throw new Error('Gemini API key is required');
    this.apiKey = config.apiKey;
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
    this.defaultModel = config.model ?? 'gemini-2.0-flash';
    this.defaultMaxTokens = config.maxTokens ?? 4096;
    this.defaultTemperature = config.temperature ?? 0.7;
  }

  isAvailable(): boolean {
    return !!this.apiKey;
  }

  async chat(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ChatCompletionResponse> {
    const url = `${this.baseUrl}/models/${options?.model ?? this.defaultModel}:generateContent?key=${this.apiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: this.formatMessages(messages),
        generationConfig: {
          maxOutputTokens: options?.maxTokens ?? this.defaultMaxTokens,
          temperature: options?.temperature ?? this.defaultTemperature,
          stopSequences: options?.stop,
        },
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Gemini', `Request failed: ${response.status} ${body}`);
    }

    const data = await response.json() as {
      candidates?: { content?: { parts?: { text?: string }[] }; finishReason?: string }[];
      usageMetadata?: { promptTokenCount?: number; candidatesTokenCount?: number; totalTokenCount?: number };
    };

    const candidate = data.candidates?.[0];
    const text = candidate?.content?.parts?.map((p) => p.text ?? '').join('') ?? '';

    return {
      id: crypto.randomUUID(),
      model: options?.model ?? this.defaultModel,
      content: text,
      finishReason: candidate?.finishReason ?? 'unknown',
      usage: {
        promptTokens: data.usageMetadata?.promptTokenCount ?? 0,
        completionTokens: data.usageMetadata?.candidatesTokenCount ?? 0,
        totalTokens: data.usageMetadata?.totalTokenCount ?? 0,
      },
    };
  }

  async chatStream(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ReadableStream> {
    const url = `${this.baseUrl}/models/${options?.model ?? this.defaultModel}:streamGenerateContent?alt=sse&key=${this.apiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: this.formatMessages(messages),
        generationConfig: {
          maxOutputTokens: options?.maxTokens ?? this.defaultMaxTokens,
          temperature: options?.temperature ?? this.defaultTemperature,
        },
      }),
    });

    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Gemini', `Stream request failed: ${response.status} ${body}`);
    }

    return response.body!;
  }

  private formatMessages(messages: ChatMessage[]): { role: string; parts: { text: string }[] }[] {
    const contents: { role: string; parts: { text: string }[] }[] = [];
    for (const msg of messages) {
      if (msg.role === 'system') {
        contents.push({ role: 'user', parts: [{ text: `[System instruction]: ${msg.content}` }] });
      } else {
        const role = msg.role === 'assistant' ? 'model' : 'user';
        contents.push({ role, parts: [{ text: msg.content }] });
      }
    }
    return contents;
  }
}
