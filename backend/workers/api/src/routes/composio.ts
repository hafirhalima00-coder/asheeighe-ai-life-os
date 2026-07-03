import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { ComposioClient } from '@asheeighe/composio-client';
import { NotFoundError } from '@asheeighe/core/errors';

const composio = new Hono<AppEnv>();

const initiateConnectionSchema = z.object({
  integrationId: z.string().min(1),
  redirectUri: z.string().url(),
});

const executeActionSchema = z.object({
  connectionId: z.string().min(1),
  actionName: z.string().min(1),
  input: z.record(z.unknown()),
});

composio.get('/integrations', async (c) => {
  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  const integrations = await client.listIntegrations();
  return c.json({ success: true, data: integrations });
});

composio.get('/connections', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');

  const connections = await db.getConnectedAccounts(userId);
  return c.json({ success: true, data: connections });
});

composio.post('/connections/initiate', zValidator('json', initiateConnectionSchema), async (c) => {
  const body = c.req.valid('json');

  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  const result = await client.initiateConnection(body.integrationId, body.redirectUri);
  return c.json({ success: true, data: result });
});

composio.post('/connections/:connectionId/validate', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const connectionId = c.req.param('connectionId');

  const existingConn = await db.findById<Record<string, unknown>>('composio_connections', connectionId);
  if (existingConn && existingConn.user_id !== userId) {
    throw new NotFoundError('Connection');
  }

  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  const status = await client.validateConnection(connectionId);
  return c.json({ success: true, data: status });
});

composio.get('/actions', async (c) => {
  const appName = c.req.query('appName');

  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  const actions = await client.listActions(appName);
  return c.json({ success: true, data: actions });
});

composio.post('/actions/execute', zValidator('json', executeActionSchema), async (c) => {
  const body = c.req.valid('json');

  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  const result = await client.executeAction(body.connectionId, body.actionName, body.input);
  return c.json({ success: true, data: result });
});

composio.delete('/connections/:connectionId', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const connectionId = c.req.param('connectionId');

  const existing = await db.findById<Record<string, unknown>>('composio_connections', connectionId);
  if (!existing || existing.user_id !== userId) {
    throw new NotFoundError('Connection');
  }

  const client = new ComposioClient({
    apiKey: c.env.COMPOSIO_API_KEY,
    baseUrl: c.env.COMPOSIO_BASE_URL,
  });

  await client.deleteConnection(connectionId);
  await db.delete('composio_connections', connectionId);

  return c.json({ success: true, message: 'Connection deleted' });
});

export default composio;
