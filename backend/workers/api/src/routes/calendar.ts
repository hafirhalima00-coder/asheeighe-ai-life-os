import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { ValidationError } from '@pinkz/core/errors';
import { generateId } from '@pinkz/core/utils';

const calendar = new Hono<AppEnv>();

const createEventSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().max(5000).optional().default(''),
  location: z.string().max(500).optional().default(''),
  startTime: z.string().datetime(),
  endTime: z.string().datetime(),
  allDay: z.boolean().optional().default(false),
  recurrenceRule: z.string().optional().nullable().default(null),
  color: z.string().regex(/^#[0-9a-fA-F]{6}$/).optional().default('#3B82F6'),
  category: z.string().max(50).optional().default('default'),
  status: z.enum(['confirmed', 'tentative', 'cancelled']).optional().default('confirmed'),
});

const updateEventSchema = createEventSchema.partial();

calendar.get('/', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const startDate = c.req.query('startDate');
  const endDate = c.req.query('endDate');

  const events = await db.getCalendarEvents(userId, startDate, endDate);
  return c.json({ success: true, data: events });
});

calendar.get('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const event = await db.findById<Record<string, unknown>>('calendar_events', id);
  if (!event || event.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Event not found' }, 404);
  }

  return c.json({ success: true, data: event });
});

calendar.post('/', zValidator('json', createEventSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');

  if (new Date(body.startTime) >= new Date(body.endTime)) {
    throw new ValidationError('Start time must be before end time');
  }

  const id = generateId();
  await db.insert('calendar_events', {
    id,
    user_id: userId,
    title: body.title,
    description: body.description,
    location: body.location,
    start_time: body.startTime,
    end_time: body.endTime,
    all_day: body.allDay ? 1 : 0,
    recurrence_rule: body.recurrenceRule,
    recurrence_exceptions: '[]',
    color: body.color,
    category: body.category,
    status: body.status,
  });

  const event = await db.findById('calendar_events', id);
  return c.json({ success: true, message: 'Event created', data: event }, 201);
});

calendar.put('/:id', zValidator('json', updateEventSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');
  const body = c.req.valid('json');

  const existing = await db.findById<Record<string, unknown>>('calendar_events', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Event not found' }, 404);
  }

  const updateData: Record<string, unknown> = {};
  if (body.title !== undefined) updateData.title = body.title;
  if (body.description !== undefined) updateData.description = body.description;
  if (body.location !== undefined) updateData.location = body.location;
  if (body.startTime !== undefined) updateData.start_time = body.startTime;
  if (body.endTime !== undefined) updateData.end_time = body.endTime;
  if (body.allDay !== undefined) updateData.all_day = body.allDay ? 1 : 0;
  if (body.recurrenceRule !== undefined) updateData.recurrence_rule = body.recurrenceRule;
  if (body.color !== undefined) updateData.color = body.color;
  if (body.category !== undefined) updateData.category = body.category;
  if (body.status !== undefined) updateData.status = body.status;

  await db.update('calendar_events', id, updateData);
  const updated = await db.findById('calendar_events', id);
  return c.json({ success: true, message: 'Event updated', data: updated });
});

calendar.delete('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('calendar_events', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Event not found' }, 404);
  }

  await db.delete('calendar_events', id);
  return c.json({ success: true, message: 'Event deleted' });
});

export default calendar;
