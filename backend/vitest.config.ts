import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['test/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov', 'html'],
      include: ['packages/**/*.ts', 'workers/**/*.ts'],
      exclude: ['**/*.d.ts', '**/*.test.ts'],
      thresholds: {
        statements: 60,
        branches: 50,
        functions: 60,
        lines: 60,
      },
    },
  },
  resolve: {
    alias: {
      '@asheeighe/core': path.resolve(__dirname, './packages/core/src'),
      '@asheeighe/ai': path.resolve(__dirname, './packages/ai/src'),
      '@asheeighe/db': path.resolve(__dirname, './packages/db/src'),
      '@asheeighe/composio-client': path.resolve(__dirname, './packages/composio-client/src'),
    },
  },
});
