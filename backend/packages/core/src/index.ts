export type UserRole = 'user' | 'admin';

export interface User {
  id: string;
  email: string;
  displayName: string;
  avatarUrl: string | null;
  timezone: string;
  preferences: Record<string, unknown>;
  emailVerified: boolean;
  role: UserRole;
  createdAt: string;
  updatedAt: string;
}

export interface CalendarEvent {
  id: string;
  userId: string;
  title: string;
  description: string;
  location: string;
  startTime: string;
  endTime: string;
  allDay: boolean;
  recurrenceRule: string | null;
  recurrenceExceptions: string[];
  color: string;
  category: string;
  status: 'confirmed' | 'tentative' | 'cancelled';
  externalProvider: string | null;
  externalEventId: string | null;
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export type TaskStatus = 'pending' | 'in_progress' | 'completed' | 'cancelled';
export type TaskPriority = 'low' | 'medium' | 'high' | 'urgent';

export interface Task {
  id: string;
  userId: string;
  title: string;
  description: string;
  status: TaskStatus;
  priority: TaskPriority;
  dueDate: string | null;
  completedAt: string | null;
  estimatedMinutes: number | null;
  actualMinutes: number | null;
  recurrenceRule: string | null;
  recurrenceExceptions: string[];
  parentTaskId: string | null;
  tags: string[];
  category: string;
  sortOrder: number;
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export interface Reminder {
  id: string;
  userId: string;
  title: string;
  description: string;
  remindAt: string;
  dismissed: boolean;
  repeatInterval: string | null;
  linkedEntityType: 'task' | 'calendar_event' | null;
  linkedEntityId: string | null;
  notificationChannels: ('in_app' | 'email' | 'push')[];
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export interface Note {
  id: string;
  userId: string;
  title: string;
  content: string;
  contentType: 'markdown' | 'plain' | 'rich';
  tags: string[];
  color: string | null;
  pinned: boolean;
  archived: boolean;
  notebookId: string | null;
  sortOrder: number;
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export type AIProviderType = 'openai' | 'gemini' | 'anthropic' | 'ollama' | 'openrouter';

export interface AIProviderConfig {
  type: AIProviderType;
  apiKey?: string;
  baseUrl?: string;
  model?: string;
  maxTokens?: number;
  temperature?: number;
}

export type SkillIntent =
  | 'create_task'
  | 'update_task'
  | 'delete_task'
  | 'list_tasks'
  | 'create_event'
  | 'update_event'
  | 'delete_event'
  | 'list_events'
  | 'create_note'
  | 'update_note'
  | 'delete_note'
  | 'list_notes'
  | 'create_reminder'
  | 'dismiss_reminder'
  | 'list_reminders'
  | 'summarize'
  | 'general_chat'
  | 'analyze';

export interface Skill {
  intent: SkillIntent;
  name: string;
  description: string;
  handler: (params: Record<string, unknown>, context: SkillContext) => Promise<SkillResult>;
}

export interface SkillContext {
  userId: string;
  db: unknown;
  ai: unknown;
  composio: unknown;
}

export interface SkillResult {
  success: boolean;
  message: string;
  data?: unknown;
}

export interface ComposioConnectedAccount {
  id: string;
  userId: string;
  integrationName: string;
  integrationId: string;
  connectionId: string;
  status: 'active' | 'expired' | 'revoked';
  authMode: string;
  accountInfo: Record<string, unknown>;
  metadata: Record<string, unknown>;
  lastSyncAt: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface PaginationParams {
  page: number;
  limit: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface ApiResponse<T = unknown> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}
