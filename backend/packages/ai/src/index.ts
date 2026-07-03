import type { AIProviderConfig, AIProviderType } from '@asheeighe/core';
import { OpenAIProvider } from './providers/openai';
import { GeminiProvider } from './providers/gemini';
import { AnthropicProvider } from './providers/anthropic';
import { OllamaProvider } from './providers/ollama';
import { OpenRouterProvider } from './providers/openrouter';

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant' | 'tool';
  content: string;
  name?: string;
  toolCallId?: string;
}

export interface ChatCompletionOptions {
  model?: string;
  temperature?: number;
  maxTokens?: number;
  stream?: boolean;
  stop?: string[];
}

export interface ChatCompletionResponse {
  id: string;
  model: string;
  content: string;
  finishReason: string;
  usage: {
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
}

export interface AIProvider {
  readonly type: AIProviderType;
  chat(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ChatCompletionResponse>;
  chatStream(messages: ChatMessage[], options?: ChatCompletionOptions): Promise<ReadableStream>;
  embed?(text: string): Promise<number[]>;
  isAvailable(): boolean;
}

export function createAIProvider(config: AIProviderConfig): AIProvider {
  switch (config.type) {
    case 'openai':
      return new OpenAIProvider(config);
    case 'gemini':
      return new GeminiProvider(config);
    case 'anthropic':
      return new AnthropicProvider(config);
    case 'ollama':
      return new OllamaProvider(config);
    case 'openrouter':
      return new OpenRouterProvider(config);
    default: {
      const _exhaustive: never = config.type;
      throw new Error(`Unsupported AI provider: ${String(_exhaustive)}`);
    }
  }
}
