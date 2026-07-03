import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ComposioClient } from '@asheeighe/composio-client';
import { ExternalServiceError } from '@asheeighe/core/errors';

const mockFetch = vi.fn();
vi.stubGlobal('fetch', mockFetch);

describe('ComposioClient', () => {
  let client: ComposioClient;

  beforeEach(() => {
    vi.clearAllMocks();
    client = new ComposioClient({
      apiKey: 'test-api-key',
      baseUrl: 'https://custom.composio.dev/api',
    });
  });

  describe('constructor', () => {
    it('uses default baseUrl when not provided', () => {
      const c = new ComposioClient({ apiKey: 'key' });
      expect(c).toBeInstanceOf(ComposioClient);
    });
  });

  describe('listIntegrations', () => {
    it('returns integrations list', async () => {
      const integrations = [{ id: '1', name: 'Google Calendar', authScheme: 'OAUTH2', description: 'Calendar', categories: ['productivity'] }];
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(integrations) });

      const result = await client.listIntegrations();
      expect(result).toEqual(integrations);
      expect(mockFetch).toHaveBeenCalledWith('https://custom.composio.dev/api/v1/integrations', expect.objectContaining({ method: 'GET' }));
    });

    it('throws on error', async () => {
      mockFetch.mockResolvedValueOnce({ ok: false, status: 500, text: () => Promise.resolve('Server error') });
      await expect(client.listIntegrations()).rejects.toThrow(ExternalServiceError);
    });
  });

  describe('getIntegration', () => {
    it('returns single integration', async () => {
      const integration = { id: '1', name: 'Slack', authScheme: 'OAUTH2', description: 'Messaging', categories: ['communication'] };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(integration) });

      const result = await client.getIntegration('1');
      expect(result).toEqual(integration);
    });
  });

  describe('initiateConnection', () => {
    it('returns connection URL and ID', async () => {
      const response = { connectionUrl: 'https://auth.composio.dev/start', connectionId: 'conn-123' };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(response) });

      const result = await client.initiateConnection('int-1', 'https://pinkz.app/callback');
      expect(result.connectionUrl).toBe('https://auth.composio.dev/start');
      expect(result.connectionId).toBe('conn-123');
      expect(mockFetch).toHaveBeenCalledWith(
        'https://custom.composio.dev/api/v1/connections/initiate',
        expect.objectContaining({
          method: 'POST',
          body: JSON.stringify({ integrationId: 'int-1', redirectUri: 'https://pinkz.app/callback' }),
        }),
      );
    });
  });

  describe('validateConnection', () => {
    it('returns connection status', async () => {
      const status = { id: 'conn-1', integrationId: 'int-1', integrationName: 'Google', status: 'ACTIVE', accountInfo: {}, createdAt: '' };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(status) });

      const result = await client.validateConnection('conn-1');
      expect(result.status).toBe('ACTIVE');
    });
  });

  describe('getConnection', () => {
    it('returns connection details', async () => {
      const data = { id: 'conn-1', status: 'ACTIVE', accountInfo: { email: 'user@test.com' } };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(data) });
      const result = await client.getConnection('conn-1');
      expect(result.accountInfo).toEqual({ email: 'user@test.com' });
    });
  });

  describe('listConnections', () => {
    it('returns all connections', async () => {
      const list = [{ id: 'c1' }, { id: 'c2' }];
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(list) });
      const result = await client.listConnections();
      expect(result).toHaveLength(2);
    });
  });

  describe('deleteConnection', () => {
    it('deletes successfully', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true });
      await expect(client.deleteConnection('conn-1')).resolves.toBeUndefined();
    });

    it('throws on delete error', async () => {
      mockFetch.mockResolvedValueOnce({ ok: false, status: 404, text: () => Promise.resolve('Not found') });
      await expect(client.deleteConnection('conn-1')).rejects.toThrow(ExternalServiceError);
    });
  });

  describe('listActions', () => {
    it('returns all actions', async () => {
      const actions = [{ id: 'a1', name: 'send_email', displayName: 'Send Email', description: 'Send an email', appName: 'gmail', parameters: {}, response: {} }];
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(actions) });
      const result = await client.listActions();
      expect(result).toHaveLength(1);
    });

    it('filters by app name', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve([]) });
      await client.listActions('slack');
      expect(mockFetch).toHaveBeenCalledWith(
        'https://custom.composio.dev/api/v1/actions?appName=slack',
        expect.anything(),
      );
    });
  });

  describe('getAction', () => {
    it('returns action details', async () => {
      const action = { id: 'a1', name: 'create_event', appName: 'calendar' };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(action) });
      const result = await client.getAction('a1');
      expect(result.name).toBe('create_event');
    });
  });

  describe('executeAction', () => {
    it('executes and returns result', async () => {
      const response = { success: true, data: { id: 'event-1' } };
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(response) });

      const result = await client.executeAction('conn-1', 'create_event', { title: 'Test' });
      expect(result.success).toBe(true);
      expect(mockFetch).toHaveBeenCalledWith(
        'https://custom.composio.dev/api/v1/actions/execute',
        expect.objectContaining({
          body: JSON.stringify({ connectionId: 'conn-1', actionName: 'create_event', input: { title: 'Test' } }),
        }),
      );
    });
  });

  describe('listTriggers', () => {
    it('returns triggers', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve([{ id: 't1' }]) });
      const result = await client.listTriggers();
      expect(result).toHaveLength(1);
    });
  });

  describe('enableTrigger', () => {
    it('enables trigger', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true });
      await expect(client.enableTrigger('conn-1', 'trigger-1')).resolves.toBeUndefined();
    });
  });

  describe('disableTrigger', () => {
    it('disables trigger', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true });
      await expect(client.disableTrigger('conn-1', 'trigger-1')).resolves.toBeUndefined();
    });
  });

  describe('getAuthToken', () => {
    it('returns auth token', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve('token-abc') });
      const result = await client.getAuthToken();
      expect(result).toBe('token-abc');
    });
  });

  describe('headers', () => {
    it('includes API key in requests', async () => {
      mockFetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve([]) });
      await client.listIntegrations();
      const callArgs = mockFetch.mock.calls[0][1];
      expect(callArgs.headers['x-api-key']).toBe('test-api-key');
      expect(callArgs.headers['Content-Type']).toBe('application/json');
    });
  });

  describe('error handling', () => {
    it('wraps error with service name', async () => {
      mockFetch.mockResolvedValueOnce({ ok: false, status: 403, text: () => Promise.resolve('Forbidden') });
      await expect(client.listIntegrations()).rejects.toThrow('Composio');
    });
  });
});
