import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';

const users = new Hono<AppEnv>();

const updateProfileSchema = z.object({
  displayName: z.string().max(100).optional(),
  avatarUrl: z.string().url().max(500).optional().nullable(),
  timezone: z.string().max(50).optional(),
  preferences: z.record(z.unknown()).optional(),
});

users.get('/me', async (c) => {
  const user = c.get('user');
  return c.json({ success: true, data: user });
});

users.patch('/me', zValidator('json', updateProfileSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');

  const updateData: Record<string, unknown> = {};
  if (body.displayName !== undefined) updateData.display_name = body.displayName;
  if (body.avatarUrl !== undefined) updateData.avatar_url = body.avatarUrl;
  if (body.timezone !== undefined) updateData.timezone = body.timezone;
  if (body.preferences !== undefined) updateData.preferences = JSON.stringify(body.preferences);

  await db.update('users', userId, updateData);
  const updated = await db.findById('users', userId);
  return c.json({ success: true, message: 'Profile updated', data: updated });
});

users.delete('/me', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');

  await db.delete('users', userId);
  return c.json({ success: true, message: 'Account deleted' });
});

users.get('/stats', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');

  const [taskCount, eventCount, noteCount, reminderCount] = await Promise.all([
    db.get<{ count: number }>('SELECT COUNT(*) as count FROM tasks WHERE user_id = ?', userId),
    db.get<{ count: number }>('SELECT COUNT(*) as count FROM calendar_events WHERE user_id = ?', userId),
    db.get<{ count: number }>('SELECT COUNT(*) as count FROM notes WHERE user_id = ? AND archived = 0', userId),
    db.get<{ count: number }>('SELECT COUNT(*) as count FROM reminders WHERE user_id = ? AND dismissed = 0', userId),
  ]);

  const pendingTasks = await db.get<{ count: number }>(
    "SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND status IN ('pending', 'in_progress')",
    userId,
  );

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 999);

  const todayEvents = await db.get<{ count: number }>(
    'SELECT COUNT(*) as count FROM calendar_events WHERE user_id = ? AND start_time >= ? AND start_time <= ?',
    userId,
    todayStart.toISOString(),
    todayEnd.toISOString(),
  );

  return c.json({
    success: true,
    data: {
      totalTasks: taskCount?.count ?? 0,
      pendingTasks: pendingTasks?.count ?? 0,
      totalEvents: eventCount?.count ?? 0,
      todayEvents: todayEvents?.count ?? 0,
      totalNotes: noteCount?.count ?? 0,
      pendingReminders: reminderCount?.count ?? 0,
    },
  });
});

export default users;
