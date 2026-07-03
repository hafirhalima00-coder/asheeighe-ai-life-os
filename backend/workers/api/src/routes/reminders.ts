import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { generateId } from '@asheeighe/core/utils';

const reminders = new Hono<AppEnv>();

const createReminderSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().max(2000).optional().default(''),
  remindAt: z.string().datetime(),
  repeatInterval: z.string().optional().nullable().default(null),
  linkedEntityType: z.enum(['task', 'calendar_event']).optional().nullable().default(null),
  linkedEntityId: z.string().optional().nullable().default(null),
  notificationChannels: z.array(z.enum(['in_app', 'email', 'push'])).optional().default(['in_app']),
});

const updateReminderSchema = createReminderSchema.partial();

reminders.get('/', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const dismissed = c.req.query('dismissed');

  const filters: Record<string, unknown> = {};
  if (dismissed !== undefined) filters.dismissed = dismissed === 'true' ? 1 : 0;

  const result = await db.findByUserId<Record<string, unknown>>('reminders', userId, { filters, orderBy: 'remind_at', orderDir: 'ASC' });
  return c.json({ success: true, ...result });
});

reminders.get('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const reminder = await db.findById<Record<string, unknown>>('reminders', id);
  if (!reminder || reminder.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Reminder not found' }, 404);
  }

  return c.json({ success: true, data: reminder });
});

reminders.post('/', zValidator('json', createReminderSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');

  const id = generateId();
  await db.insert('reminders', {
    id,
    user_id: userId,
    title: body.title,
    description: body.description,
    remind_at: body.remindAt,
    repeat_interval: body.repeatInterval,
    linked_entity_type: body.linkedEntityType,
    linked_entity_id: body.linkedEntityId,
    notification_channels: JSON.stringify(body.notificationChannels),
  });

  const reminder = await db.findById('reminders', id);
  return c.json({ success: true, message: 'Reminder created', data: reminder }, 201);
});

reminders.put('/:id', zValidator('json', updateReminderSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');
  const body = c.req.valid('json');

  const existing = await db.findById<Record<string, unknown>>('reminders', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Reminder not found' }, 404);
  }

  const updateData: Record<string, unknown> = {};
  if (body.title !== undefined) updateData.title = body.title;
  if (body.description !== undefined) updateData.description = body.description;
  if (body.remindAt !== undefined) updateData.remind_at = body.remindAt;
  if (body.repeatInterval !== undefined) updateData.repeat_interval = body.repeatInterval;
  if (body.linkedEntityType !== undefined) updateData.linked_entity_type = body.linkedEntityType;
  if (body.linkedEntityId !== undefined) updateData.linked_entity_id = body.linkedEntityId;
  if (body.notificationChannels !== undefined) updateData.notification_channels = JSON.stringify(body.notificationChannels);

  await db.update('reminders', id, updateData);
  const updated = await db.findById('reminders', id);
  return c.json({ success: true, message: 'Reminder updated', data: updated });
});

reminders.delete('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('reminders', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Reminder not found' }, 404);
  }

  await db.delete('reminders', id);
  return c.json({ success: true, message: 'Reminder deleted' });
});

reminders.post('/:id/dismiss', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('reminders', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Reminder not found' }, 404);
  }

  await db.update('reminders', id, { dismissed: 1 });
  return c.json({ success: true, message: 'Reminder dismissed' });
});

export default reminders;
