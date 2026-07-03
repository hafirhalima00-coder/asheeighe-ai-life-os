import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { ValidationError } from '@pinkz/core/errors';
import { generateId } from '@pinkz/core/utils';

const tasks = new Hono<AppEnv>();

const createTaskSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().max(5000).optional().default(''),
  status: z.enum(['pending', 'in_progress', 'completed', 'cancelled']).optional().default('pending'),
  priority: z.enum(['low', 'medium', 'high', 'urgent']).optional().default('medium'),
  dueDate: z.string().datetime().optional().nullable().default(null),
  estimatedMinutes: z.number().int().min(0).optional().nullable().default(null),
  recurrenceRule: z.string().optional().nullable().default(null),
  parentTaskId: z.string().optional().nullable().default(null),
  tags: z.array(z.string().max(50)).max(20).optional().default([]),
  category: z.string().max(50).optional().default('default'),
});

const updateTaskSchema = createTaskSchema.partial();

tasks.get('/', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const status = c.req.query('status');
  const category = c.req.query('category');
  const priority = c.req.query('priority');

  const filters: Record<string, unknown> = {};
  if (status) filters.status = status;
  if (category) filters.category = category;
  if (priority) filters.priority = priority;

  const result = await db.findByUserId<Record<string, unknown>>('tasks', userId, { filters, orderBy: 'sort_order', orderDir: 'ASC' });
  return c.json({ success: true, ...result });
});

tasks.get('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const task = await db.findById<Record<string, unknown>>('tasks', id);
  if (!task || task.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Task not found' }, 404);
  }

  return c.json({ success: true, data: task });
});

tasks.post('/', zValidator('json', createTaskSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');

  if (body.parentTaskId) {
    const parent = await db.findById('tasks', body.parentTaskId);
    if (!parent) {
      throw new ValidationError('Parent task not found');
    }
  }

  const id = generateId();
  const now = new Date().toISOString();
  await db.insert('tasks', {
    id,
    user_id: userId,
    title: body.title,
    description: body.description,
    status: body.status,
    priority: body.priority,
    due_date: body.dueDate,
    estimated_minutes: body.estimatedMinutes,
    recurrence_rule: body.recurrenceRule,
    parent_task_id: body.parentTaskId,
    tags: JSON.stringify(body.tags),
    category: body.category,
    sort_order: Date.now(),
    completed_at: body.status === 'completed' ? now : null,
  });

  const task = await db.findById('tasks', id);
  return c.json({ success: true, message: 'Task created', data: task }, 201);
});

tasks.put('/:id', zValidator('json', updateTaskSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');
  const body = c.req.valid('json');

  const existing = await db.findById<Record<string, unknown>>('tasks', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Task not found' }, 404);
  }

  const updateData: Record<string, unknown> = {};
  if (body.title !== undefined) updateData.title = body.title;
  if (body.description !== undefined) updateData.description = body.description;
  if (body.status !== undefined) {
    updateData.status = body.status;
    updateData.completed_at = body.status === 'completed' ? new Date().toISOString() : null;
  }
  if (body.priority !== undefined) updateData.priority = body.priority;
  if (body.dueDate !== undefined) updateData.due_date = body.dueDate;
  if (body.estimatedMinutes !== undefined) updateData.estimated_minutes = body.estimatedMinutes;
  if (body.recurrenceRule !== undefined) updateData.recurrence_rule = body.recurrenceRule;
  if (body.parentTaskId !== undefined) updateData.parent_task_id = body.parentTaskId;
  if (body.tags !== undefined) updateData.tags = JSON.stringify(body.tags);
  if (body.category !== undefined) updateData.category = body.category;

  await db.update('tasks', id, updateData);
  const updated = await db.findById('tasks', id);
  return c.json({ success: true, message: 'Task updated', data: updated });
});

tasks.delete('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('tasks', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Task not found' }, 404);
  }

  await db.delete('tasks', id);
  return c.json({ success: true, message: 'Task deleted' });
});

tasks.post('/:id/complete', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('tasks', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Task not found' }, 404);
  }

  const now = new Date().toISOString();
  await db.update('tasks', id, { status: 'completed', completed_at: now });
  const updated = await db.findById('tasks', id);
  return c.json({ success: true, message: 'Task completed', data: updated });
});

export default tasks;
