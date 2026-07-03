import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import { generateId } from '@asheeighe/core/utils';

interface Env {
  Bindings: {
    DB: D1Database;
    COMPOSIO_API_KEY: string;
    COMPOSIO_WEBHOOK_SECRET: string;
  };
}

const app = new Hono<{ Bindings: Env['Bindings'] }>();

const webhookSchema = z.object({
  event: z.enum([
    'connection.created',
    'connection.updated',
    'connection.deleted',
    'connection.expired',
    'action.executed',
    'trigger.fired',
  ]),
  connectionId: z.string(),
  integrationId: z.string().optional(),
  integrationName: z.string().optional(),
  accountInfo: z.record(z.unknown()).optional(),
  payload: z.record(z.unknown()).optional(),
  timestamp: z.string().optional(),
});

app.post('/webhook', zValidator('json', webhookSchema), async (c) => {
  const secret = c.req.header('x-webhook-secret');
  if (secret !== c.env.COMPOSIO_WEBHOOK_SECRET) {
    return c.json({ success: false, error: 'UNAUTHORIZED', message: 'Invalid webhook secret' }, 401);
  }

  const body = c.req.valid('json');

  switch (body.event) {
    case 'connection.created': {
      const existing = await c.env.DB.prepare(
        'SELECT id FROM composio_connections WHERE connection_id = ?',
      ).bind(body.connectionId).first();

      if (!existing) {
        await c.env.DB.prepare(
          `INSERT INTO composio_connections (id, user_id, integration_name, integration_id, connection_id, status, auth_mode, account_info)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        ).bind(
          generateId(),
          'pending',
          body.integrationName ?? 'unknown',
          body.integrationId ?? '',
          body.connectionId,
          'active',
          'oauth',
          JSON.stringify(body.accountInfo ?? {}),
        ).run();
      }
      break;
    }

    case 'connection.updated': {
      await c.env.DB.prepare(
        `UPDATE composio_connections SET account_info = ?, updated_at = datetime('now') WHERE connection_id = ?`,
      ).bind(JSON.stringify(body.accountInfo ?? {}), body.connectionId).run();
      break;
    }

    case 'connection.deleted':
    case 'connection.expired': {
      const status = body.event === 'connection.deleted' ? 'revoked' : 'expired';
      await c.env.DB.prepare(
        `UPDATE composio_connections SET status = ?, updated_at = datetime('now') WHERE connection_id = ?`,
      ).bind(status, body.connectionId).run();
      break;
    }

    case 'action.executed': {
      await c.env.DB.prepare(
        `UPDATE composio_connections SET last_sync_at = datetime('now'), updated_at = datetime('now') WHERE connection_id = ?`,
      ).bind(body.connectionId).run();
      break;
    }

    case 'trigger.fired': {
      // triggers can be logged or forwarded to the user
      console.log(`[COMPOSIO] Trigger fired for connection ${body.connectionId}:`, JSON.stringify(body.payload));
      break;
    }
  }

  return c.json({ success: true, message: 'Webhook processed' });
});

app.get('/health', (c) => {
  return c.json({ success: true, message: 'Composio webhook worker running', timestamp: new Date().toISOString() });
});

app.all('*', (c) => {
  return c.json({ success: false, error: 'NOT_FOUND', message: `Route not found: ${c.req.method} ${c.req.path}` }, 404);
});

app.onError((err, c) => {
  console.error('[COMPOSIO ERROR]', err);
  return c.json({ success: false, error: 'INTERNAL_ERROR', message: err.message || 'Internal server error' }, 500);
});

export default app;
