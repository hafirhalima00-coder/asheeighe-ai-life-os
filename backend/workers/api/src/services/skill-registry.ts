import type { DB } from '@pinkz/db';
import type { AIProvider } from '@pinkz/ai';
import type { Skill, SkillIntent, SkillContext, SkillResult } from '@pinkz/core';

export class SkillRegistry {
  private readonly skills: Map<SkillIntent, Skill> = new Map();

  constructor(
    private readonly db: DB,
    private readonly ai: AIProvider,
    private readonly userId: string,
  ) {
    this.registerDefaults();
  }

  private registerDefaults(): void {
    this.register({
      intent: 'create_task',
      name: 'Create Task',
      description: 'Create a new task for the user',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const { generateId } = await import('@pinkz/core/utils');
        const id = generateId();
        await db.insert('tasks', {
          id,
          user_id: ctx.userId,
          title: (params.title as string) ?? 'Untitled Task',
          description: (params.description as string) ?? '',
          status: 'pending',
          priority: (params.priority as string) ?? 'medium',
          due_date: (params.dueDate as string) ?? null,
          tags: JSON.stringify(params.tags ?? []),
          category: (params.category as string) ?? 'default',
          sort_order: Date.now(),
        });
        return { success: true, message: 'Task created successfully', data: { id } };
      },
    });

    this.register({
      intent: 'update_task',
      name: 'Update Task',
      description: 'Update an existing task',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const id = params.id as string;
        const existing = await db.findById<Record<string, unknown>>('tasks', id);
        if (!existing || existing.user_id !== ctx.userId) {
          return { success: false, message: 'Task not found' };
        }
        const updateData: Record<string, unknown> = {};
        if (params.title) updateData.title = params.title;
        if (params.status) updateData.status = params.status;
        if (params.priority) updateData.priority = params.priority;
        if (params.dueDate !== undefined) updateData.due_date = params.dueDate;
        if (params.description) updateData.description = params.description;
        await db.update('tasks', id, updateData);
        return { success: true, message: 'Task updated' };
      },
    });

    this.register({
      intent: 'delete_task',
      name: 'Delete Task',
      description: 'Delete a task',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const id = params.id as string;
        await db.delete('tasks', id, ctx.userId);
        return { success: true, message: 'Task deleted' };
      },
    });

    this.register({
      intent: 'list_tasks',
      name: 'List Tasks',
      description: 'List all tasks for the user',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const status = params.status as string | undefined;
        const tasks = await db.getTasksByStatus(ctx.userId, status);
        return { success: true, message: `Found ${tasks.length} tasks`, data: tasks };
      },
    });

    this.register({
      intent: 'create_event',
      name: 'Create Calendar Event',
      description: 'Create a new calendar event',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const { generateId } = await import('@pinkz/core/utils');
        const id = generateId();
        await db.insert('calendar_events', {
          id,
          user_id: ctx.userId,
          title: (params.title as string) ?? 'Untitled Event',
          description: (params.description as string) ?? '',
          location: (params.location as string) ?? '',
          start_time: params.startTime as string,
          end_time: params.endTime as string,
          all_day: params.allDay ? 1 : 0,
          color: (params.color as string) ?? '#3B82F6',
          category: (params.category as string) ?? 'default',
          status: 'confirmed',
        });
        return { success: true, message: 'Event created', data: { id } };
      },
    });

    this.register({
      intent: 'update_event',
      name: 'Update Calendar Event',
      description: 'Update an existing calendar event',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const id = params.id as string;
        const existing = await db.findById<Record<string, unknown>>('calendar_events', id);
        if (!existing || existing.user_id !== ctx.userId) {
          return { success: false, message: 'Event not found' };
        }
        const updateData: Record<string, unknown> = {};
        if (params.title) updateData.title = params.title;
        if (params.description !== undefined) updateData.description = params.description;
        if (params.startTime) updateData.start_time = params.startTime;
        if (params.endTime) updateData.end_time = params.endTime;
        if (params.location !== undefined) updateData.location = params.location;
        await db.update('calendar_events', id, updateData);
        return { success: true, message: 'Event updated' };
      },
    });

    this.register({
      intent: 'delete_event',
      name: 'Delete Calendar Event',
      description: 'Delete a calendar event',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const id = params.id as string;
        await db.delete('calendar_events', id, ctx.userId);
        return { success: true, message: 'Event deleted' };
      },
    });

    this.register({
      intent: 'list_events',
      name: 'List Calendar Events',
      description: 'List calendar events',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const events = await db.getCalendarEvents(
          ctx.userId,
          params.startDate as string | undefined,
          params.endDate as string | undefined,
        );
        return { success: true, message: `Found ${events.length} events`, data: events };
      },
    });

    this.register({
      intent: 'create_note',
      name: 'Create Note',
      description: 'Create a new note',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const { generateId } = await import('@pinkz/core/utils');
        const id = generateId();
        await db.insert('notes', {
          id,
          user_id: ctx.userId,
          title: (params.title as string) ?? '',
          content: (params.content as string) ?? '',
          content_type: (params.contentType as string) ?? 'markdown',
          tags: JSON.stringify(params.tags ?? []),
          pinned: params.pinned ? 1 : 0,
          sort_order: Date.now(),
        });
        return { success: true, message: 'Note created', data: { id } };
      },
    });

    this.register({
      intent: 'update_note',
      name: 'Update Note',
      description: 'Update an existing note',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const id = params.id as string;
        const existing = await db.findById<Record<string, unknown>>('notes', id);
        if (!existing || existing.user_id !== ctx.userId) {
          return { success: false, message: 'Note not found' };
        }
        const updateData: Record<string, unknown> = {};
        if (params.title !== undefined) updateData.title = params.title;
        if (params.content !== undefined) updateData.content = params.content;
        if (params.contentType !== undefined) updateData.content_type = params.contentType;
        await db.update('notes', id, updateData);
        return { success: true, message: 'Note updated' };
      },
    });

    this.register({
      intent: 'list_notes',
      name: 'List Notes',
      description: 'List all notes',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const notes = await db.getNotesByNotebook(ctx.userId, params.notebookId as string | null);
        return { success: true, message: `Found ${notes.length} notes`, data: notes };
      },
    });

    this.register({
      intent: 'create_reminder',
      name: 'Create Reminder',
      description: 'Create a new reminder',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const { generateId } = await import('@pinkz/core/utils');
        const id = generateId();
        await db.insert('reminders', {
          id,
          user_id: ctx.userId,
          title: (params.title as string) ?? 'Reminder',
          description: (params.description as string) ?? '',
          remind_at: params.remindAt as string,
          notification_channels: JSON.stringify(params.notificationChannels ?? ['in_app']),
        });
        return { success: true, message: 'Reminder created', data: { id } };
      },
    });

    this.register({
      intent: 'analyze',
      name: 'Analyze Data',
      description: 'Analyze user data and provide insights',
      handler: async (params, ctx) => {
        const db = ctx.db as DB;
        const period = (params.period as string) ?? 'week';

        const sevenDaysAgo = new Date();
        sevenDaysAgo.setDate(sevenDaysAgo.getDate() - (period === 'month' ? 30 : 7));

        const [completedTasks, events, notes] = await Promise.all([
          db.query<Record<string, unknown>>(
            'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND status = ? AND updated_at >= ?',
            ctx.userId, 'completed', sevenDaysAgo.toISOString(),
          ),
          db.query<Record<string, unknown>>(
            'SELECT COUNT(*) as count FROM calendar_events WHERE user_id = ? AND start_time >= ?',
            ctx.userId, sevenDaysAgo.toISOString(),
          ),
          db.query<Record<string, unknown>>(
            'SELECT COUNT(*) as count FROM notes WHERE user_id = ? AND updated_at >= ?',
            ctx.userId, sevenDaysAgo.toISOString(),
          ),
        ]);

        return {
          success: true,
          message: 'Analysis complete',
          data: {
            period,
            completedTasks: completedTasks[0]?.count ?? 0,
            eventsCreated: events[0]?.count ?? 0,
            notesEdited: notes[0]?.count ?? 0,
          },
        };
      },
    });
  }

  register(skill: Skill): void {
    this.skills.set(skill.intent, skill);
  }

  get(intent: SkillIntent): Skill | undefined {
    return this.skills.get(intent);
  }

  list(): Skill[] {
    return Array.from(this.skills.values());
  }

  async execute(intent: SkillIntent, params: Record<string, unknown>): Promise<SkillResult> {
    const skill = this.skills.get(intent);
    if (!skill) {
      return { success: false, message: `Unknown skill: ${intent}` };
    }
    const context: SkillContext = {
      userId: this.userId,
      db: this.db,
      ai: this.ai,
      composio: null,
    };
    return skill.handler(params, context);
  }

  async detectAndExecute(message: string): Promise<{ action: string; data: unknown } | null> {
    const lower = message.toLowerCase();

    if (lower.includes('create task') || lower.includes('add task') || lower.includes('new task')) {
      const params = this.extractTaskParams(message);
      const result = await this.execute('create_task', params);
      return { action: 'create_task', data: result };
    }

    if (lower.includes('list task') || lower.includes('show task') || lower.includes('my tasks')) {
      const result = await this.execute('list_tasks', {});
      return { action: 'list_tasks', data: result };
    }

    if (lower.includes('create event') || lower.includes('add event') || lower.includes('schedule')) {
      const result = await this.execute('create_event', this.extractEventParams(message));
      return { action: 'create_event', data: result };
    }

    if (lower.includes('list event') || lower.includes('show event') || lower.includes('my events')) {
      const result = await this.execute('list_events', {});
      return { action: 'list_events', data: result };
    }

    if (lower.includes('create note') || lower.includes('add note') || lower.includes('new note')) {
      const result = await this.execute('create_note', this.extractNoteParams(message));
      return { action: 'create_note', data: result };
    }

    if (lower.includes('list note') || lower.includes('show note') || lower.includes('my notes')) {
      const result = await this.execute('list_notes', {});
      return { action: 'list_notes', data: result };
    }

    if (lower.includes('create reminder') || lower.includes('remind me') || lower.includes('set reminder')) {
      const result = await this.execute('create_reminder', this.extractReminderParams(message));
      return { action: 'create_reminder', data: result };
    }

    if (lower.includes('analyze') || lower.includes('insight') || lower.includes('summary') || lower.includes('stats')) {
      const result = await this.execute('analyze', { period: lower.includes('month') ? 'month' : 'week' });
      return { action: 'analyze', data: result };
    }

    return null;
  }

  private extractTaskParams(message: string): Record<string, unknown> {
    const params: Record<string, unknown> = {};
    const titleMatch = message.match(/(?:called|titled|named|to)\s+"([^"]+)"|(?:called|titled|named|to)\s+'([^']+)'/i);
    if (titleMatch) {
      params.title = titleMatch[1] ?? titleMatch[2];
    }

    if (/high|urgent/i.test(message)) params.priority = 'high';
    else if (/low/i.test(message)) params.priority = 'low';
    else params.priority = 'medium';

    const dueMatch = message.match(/due\s+(.+?)(?:\.|$)/i);
    if (dueMatch) {
      params.dueDate = dueMatch[1]?.trim();
    }

    return params;
  }

  private extractEventParams(message: string): Record<string, unknown> {
    const params: Record<string, unknown> = {};
    const titleMatch = message.match(/(?:called|titled|named)\s+"([^"]+)"|(?:called|titled|named)\s+'([^']+)'/i);
    if (titleMatch) {
      params.title = titleMatch[1] ?? titleMatch[2];
    }
    return params;
  }

  private extractNoteParams(message: string): Record<string, unknown> {
    const params: Record<string, unknown> = {};
    const titleMatch = message.match(/(?:called|titled|named|about)\s+"([^"]+)"|(?:called|titled|named|about)\s+'([^']+)'/i);
    if (titleMatch) {
      params.title = titleMatch[1] ?? titleMatch[2];
    }
    const contentMatch = message.match(/content\s+"([^"]+)"|content\s+'([^']+)'/i);
    if (contentMatch) {
      params.content = contentMatch[1] ?? contentMatch[2];
    }
    return params;
  }

  private extractReminderParams(message: string): Record<string, unknown> {
    const params: Record<string, unknown> = {};
    const titleMatch = message.match(/(?:to|about)\s+"([^"]+)"|(?:to|about)\s+'([^']+)'|remind\s+me\s+(?:to|about)\s+(.+?)(?:\.|$)/i);
    if (titleMatch) {
      params.title = titleMatch[1] ?? titleMatch[2] ?? titleMatch[3]?.trim();
    }

    const timeMatch = message.match(/(?:at|in)\s+(.+?)(?:\.|$)/i);
    if (timeMatch) {
      params.remindAt = timeMatch[1]?.trim();
    }

    return params;
  }
}
