import type { User } from '@pinkz/core';
import type { DB } from '@pinkz/db';

export interface AppEnv {
  Bindings: {
    DB: D1Database;
    KV: KVNamespace;
    R2: R2Bucket;
    JWT_SECRET: string;
    JWT_REFRESH_SECRET: string;
    OPENAI_API_KEY: string;
    GEMINI_API_KEY: string;
    ANTHROPIC_API_KEY: string;
    OLLAMA_BASE_URL: string;
    OPENROUTER_API_KEY: string;
    COMPOSIO_API_KEY: string;
    COMPOSIO_BASE_URL: string;
    APP_URL: string;
  };
  Variables: {
    user: User;
    userId: string;
    db: DB;
    requestId: string;
  };
}

export type { User };
