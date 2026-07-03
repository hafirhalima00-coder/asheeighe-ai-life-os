import { createDB } from '@pinkz/db';

interface Env {
  DB: D1Database;
  KV: KVNamespace;
}

export default {
  async scheduled(controller: ScheduledController, env: Env): Promise<void> {
    const db = createDB(env.DB);

    switch (controller.cron) {
      case '*/5 * * * *':
        await processPendingReminders(db, env);
        break;

      case '0 * * * *':
        await cleanupExpiredData(db, env);
        break;

      case '0 0 * * *':
        await generateDailySummary(db, env);
        break;

      default:
        console.log(`[SYNC] Unhandled cron schedule: ${controller.cron}`);
    }
  },

  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (request.method === 'POST' && url.pathname === '/sync/reminders') {
      const db = createDB(env.DB);
      await processPendingReminders(db, env);
      return new Response(JSON.stringify({ success: true, message: 'Reminders processed' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    if (request.method === 'POST' && url.pathname === '/sync/cleanup') {
      const db = createDB(env.DB);
      await cleanupExpiredData(db, env);
      return new Response(JSON.stringify({ success: true, message: 'Cleanup completed' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    return new Response(JSON.stringify({ success: true, message: 'Sync worker running' }), {
      headers: { 'Content-Type': 'application/json' },
    });
  },
};

async function processPendingReminders(db: ReturnType<typeof createDB>, env: Env): Promise<void> {
  try {
    const now = new Date().toISOString();
    const reminders = await db.getPendingReminders(now);

    for (const reminder of reminders) {
      try {
        const notificationKey = `notification:${reminder.id}`;
        const notified = await env.KV.get(notificationKey);
        if (notified) continue;

        await broadcastNotification(reminder, env);

        await env.KV.put(notificationKey, 'true', { expirationTtl: 86400 });

        console.log(`[SYNC] Processed reminder: ${reminder.id} - ${reminder.title}`);
      } catch (err) {
        console.error(`[SYNC] Failed to process reminder ${reminder.id}:`, err);
      }
    }

    console.log(`[SYNC] Processed ${reminders.length} pending reminders`);
  } catch (err) {
    console.error('[SYNC] Error processing reminders:', err);
  }
}

async function broadcastNotification(
  reminder: { id: string; userId: string; title: string; description: string; notificationChannels: string[] },
  env: Env,
): Promise<void> {
  const channels = reminder.notificationChannels ?? ['in_app'];

  for (const channel of channels) {
    switch (channel) {
      case 'in_app': {
        const notification = {
          type: 'reminder',
          title: reminder.title,
          body: reminder.description || reminder.title,
          data: { reminderId: reminder.id },
          timestamp: new Date().toISOString(),
        };
        const key = `in_app_notifications:${reminder.userId}`;
        const existing = await env.KV.get(key);
        const notifications = existing ? JSON.parse(existing) : [];
        notifications.push(notification);
        const maxNotifications = 50;
        const trimmed = notifications.slice(-maxNotifications);
        await env.KV.put(key, JSON.stringify(trimmed), { expirationTtl: 86400 * 7 });
        break;
      }

      case 'email':
        console.log(`[SYNC] Email notification for ${reminder.userId}: ${reminder.title}`);
        break;

      case 'push':
        console.log(`[SYNC] Push notification for ${reminder.userId}: ${reminder.title}`);
        break;
    }
  }
}

async function cleanupExpiredData(db: ReturnType<typeof createDB>, _env: Env): Promise<void> {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const deletedReminders = await db.execute(
      'DELETE FROM reminders WHERE dismissed = 1 AND updated_at < ?',
      thirtyDaysAgo.toISOString(),
    );

    const deletedNotifications = await db.execute(
      "DELETE FROM tasks WHERE status IN ('completed', 'cancelled') AND updated_at < ?",
      thirtyDaysAgo.toISOString(),
    );

    console.log(`[SYNC] Cleanup: removed ${deletedReminders.meta.changes} reminders, ${deletedNotifications.meta.changes} old tasks`);
  } catch (err) {
    console.error('[SYNC] Error during cleanup:', err);
  }
}

async function generateDailySummary(db: ReturnType<typeof createDB>, env: Env): Promise<void> {
  try {
    const today = new Date().toISOString().split('T')[0];
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = tomorrow.toISOString().split('T')[0];

    const activeUsers = await db.query<{ id: string; email: string }>(
      "SELECT DISTINCT user_id FROM tasks WHERE updated_at >= ? UNION SELECT DISTINCT user_id FROM calendar_events WHERE start_time >= ?",
      `${today}T00:00:00Z`,
      `${today}T00:00:00Z`,
    );

    for (const row of activeUsers) {
      const userId = row.id ?? (row as unknown as Record<string, string>).user_id;

      const [pendingTasks, todayEvents, pendingReminders] = await Promise.all([
        db.get<{ count: number }>(
          "SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND status IN ('pending', 'in_progress')",
          userId,
        ),
        db.get<{ count: number }>(
          'SELECT COUNT(*) as count FROM calendar_events WHERE user_id = ? AND start_time >= ? AND start_time < ?',
          userId,
          `${today}T00:00:00Z`,
          `${tomorrowStr}T00:00:00Z`,
        ),
        db.get<{ count: number }>(
          'SELECT COUNT(*) as count FROM reminders WHERE user_id = ? AND dismissed = 0 AND remind_at >= ? AND remind_at < ?',
          userId,
          `${today}T00:00:00Z`,
          `${tomorrowStr}T00:00:00Z`,
        ),
      ]);

      if ((pendingTasks?.count ?? 0) > 0 || (todayEvents?.count ?? 0) > 0 || (pendingReminders?.count ?? 0) > 0) {
        const summary = {
          type: 'daily_summary',
          date: today,
          pendingTasks: pendingTasks?.count ?? 0,
          todayEvents: todayEvents?.count ?? 0,
          pendingReminders: pendingReminders?.count ?? 0,
          timestamp: new Date().toISOString(),
        };

        const key = `daily_summary:${userId}:${today}`;
        await env.KV.put(key, JSON.stringify(summary), { expirationTtl: 86400 * 7 });
        console.log(`[SYNC] Daily summary generated for user ${userId}`);
      }
    }

    console.log(`[SYNC] Daily summaries generated for ${activeUsers.length} active users`);
  } catch (err) {
    console.error('[SYNC] Error generating daily summary:', err);
  }
}
