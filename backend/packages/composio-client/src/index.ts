import { ExternalServiceError } from '@pinkz/core/errors';

export interface ComposioConfig {
  apiKey: string;
  baseUrl?: string;
}

export interface Integration {
  id: string;
  name: string;
  authScheme: string;
  description: string;
  categories: string[];
  logo?: string;
}

export interface Action {
  id: string;
  name: string;
  displayName: string;
  description: string;
  appName: string;
  parameters: Record<string, unknown>;
  response: Record<string, unknown>;
}

export interface Trigger {
  id: string;
  name: string;
  displayName: string;
  description: string;
  appName: string;
  payload: Record<string, unknown>;
}

export interface ExecuteActionResponse {
  success: boolean;
  data: unknown;
  error?: string;
}

export interface ConnectionStatus {
  id: string;
  integrationId: string;
  integrationName: string;
  status: 'ACTIVE' | 'EXPIRED' | 'REVOKED';
  accountInfo: Record<string, unknown>;
  createdAt: string;
}

export class ComposioClient {
  private readonly apiKey: string;
  private readonly baseUrl: string;

  constructor(config: ComposioConfig) {
    this.apiKey = config.apiKey;
    this.baseUrl = config.baseUrl ?? 'https://backend.composio.dev/api';
  }

  async listIntegrations(): Promise<Integration[]> {
    return this.get<Integration[]>('/v1/integrations');
  }

  async getIntegration(id: string): Promise<Integration> {
    return this.get<Integration>(`/v1/integrations/${id}`);
  }

  async initiateConnection(integrationId: string, redirectUri: string): Promise<{ connectionUrl: string; connectionId: string }> {
    return this.post<{ connectionUrl: string; connectionId: string }>('/v1/connections/initiate', {
      integrationId,
      redirectUri,
    });
  }

  async validateConnection(connectionId: string): Promise<ConnectionStatus> {
    return this.get<ConnectionStatus>(`/v1/connections/${connectionId}/status`);
  }

  async getConnection(connectionId: string): Promise<ConnectionStatus> {
    return this.get<ConnectionStatus>(`/v1/connections/${connectionId}`);
  }

  async listConnections(): Promise<ConnectionStatus[]> {
    return this.get<ConnectionStatus[]>('/v1/connections');
  }

  async deleteConnection(connectionId: string): Promise<void> {
    await this.delete(`/v1/connections/${connectionId}`);
  }

  async listActions(integrationName?: string): Promise<Action[]> {
    const path = integrationName ? `/v1/actions?appName=${integrationName}` : '/v1/actions';
    return this.get<Action[]>(path);
  }

  async getAction(actionId: string): Promise<Action> {
    return this.get<Action>(`/v1/actions/${actionId}`);
  }

  async executeAction(
    connectionId: string,
    actionName: string,
    input: Record<string, unknown>,
  ): Promise<ExecuteActionResponse> {
    return this.post<ExecuteActionResponse>('/v1/actions/execute', {
      connectionId,
      actionName,
      input,
    });
  }

  async listTriggers(integrationName?: string): Promise<Trigger[]> {
    const path = integrationName ? `/v1/triggers?appName=${integrationName}` : '/v1/triggers';
    return this.get<Trigger[]>(path);
  }

  async enableTrigger(connectionId: string, triggerId: string, config?: Record<string, unknown>): Promise<void> {
    await this.post('/v1/triggers/enable', { connectionId, triggerId, config });
  }

  async disableTrigger(connectionId: string, triggerId: string): Promise<void> {
    await this.post('/v1/triggers/disable', { connectionId, triggerId });
  }

  async getAuthToken(): Promise<string> {
    return this.post<string>('/v1/auth/token', {});
  }

  private async get<T>(path: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'GET',
      headers: this.getHeaders(),
    });
    return this.handleResponse<T>(response, path);
  }

  private async post<T>(path: string, body: unknown): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify(body),
    });
    return this.handleResponse<T>(response, path);
  }

  private async delete(path: string): Promise<void> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'DELETE',
      headers: this.getHeaders(),
    });
    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Composio', `DELETE ${path} failed: ${response.status} ${body}`);
    }
  }

  private getHeaders(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      'x-api-key': this.apiKey,
    };
  }

  private async handleResponse<T>(response: Response, path: string): Promise<T> {
    if (!response.ok) {
      const body = await response.text();
      throw new ExternalServiceError('Composio', `Request ${path} failed: ${response.status} ${body}`);
    }
    return response.json() as Promise<T>;
  }
}
