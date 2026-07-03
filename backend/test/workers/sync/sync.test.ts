import { describe, it, expect, vi, beforeEach } from 'vitest';
import { Hono } from 'hono';

function createMockDb() {
  return {
    getPendingReminders: vi.fn(),
    execute: vi.fn(),
    query: vi.fn(),
    get: vi.fn(),
  };
}

function createMockEnv() {
  return {
    DB: {} as any,
    KV: {
      get: vi.fn(),
      put: vi.fn(),
    } as any,
  };
}

vi.mock('@asheeighe/db', () => ({ createDB: vi.fn() }));

async function loadSyncWorker() {
  return (await import('@asheeighe/workers/sync/src/index')).default;
}

describe('Sync Worker', () => {
  let worker: any;
  let mockDb: ReturnType<typeof createMockDb>;
  let mockEnv: ReturnType<typeof createMockEnv>;

  beforeEach(async () => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    mockEnv = createMockEnv();
    const { createDB } = await import('@asheeighe/db');
    (createDB as any).mockReturnValue(mockDb);
    worker = await loadSyncWorker();
  });

  describe('fetch handler', () => {
    it('returns status on root', async () => {
      const req = new Request('http://localhost/');
      const res = await worker.fetch(req, mockEnv);
      expect(res.status).toBe(200);
      const body = await res.json();
      expect(body.success).toBe(true);
    });

    it('POST /sync/reminders processes reminders', async () => {
      mockDb.getPendingReminders.mockResolvedValue([]);

      const req = new Request('http://localhost/sync/reminders', { method: 'POST' });
      const res = await worker.fetch(req, mockEnv);
      expect(res.status).toBe(200);
      expect(mockDb.getPendingReminders).toHaveBeenCalled();
    });

    it('POST /sync/reminders sends notifications', async () => {
      mockDb.getPendingReminders.mockResolvedValue([{
        id: 'r1',
        userId: 'user1',
        title: 'Meeting',
        description: 'Team meeting',
        notificationChannels: ['in_app'],
      }]);
      mockEnv.KV.get.mockResolvedValue(null);
      mockEnv.KV.put.mockResolvedValue(undefined);

      const req = new Request('http://localhost/sync/reminders', { method: 'POST' });
      const res = await worker.fetch(req, mockEnv);
      expect(res.status).toBe(200);
      expect(mockEnv.KV.put).toHaveBeenCalledWith(
        'notification:r1',
        'true',
        expect.objectContaining({ expirationTtl: 86400 }),
      );
    });

    it('POST /sync/reminders skips already notified', async () => {
      mockDb.getPendingReminders.mockResolvedValue([{
        id: 'r1', userId: 'user1', title: 'Done', description: '',
        notificationChannels: ['in_app'],
      }]);
      mockEnv.KV.get.mockResolvedValue('true');

      const req = new Request('http://localhost/sync/reminders', { method: 'POST' });
      const res = await worker.fetch(req, mockEnv);
      expect(res.status).toBe(200);
      expect(mockEnv.KV.put).not.toHaveBeenCalled();
    });

    it('POST /sync/cleanup cleans expired data', async () => {
      mockDb.execute.mockResolvedValue({ meta: { changes: 5 } });

      const req = new Request('http://localhost/sync/cleanup', { method: 'POST' });
      const res = await worker.fetch(req, mockEnv);
      expect(res.status).toBe(200);
      expect(mockDb.execute).toHaveBeenCalledTimes(2);
    });
  });

  describe('scheduled handler', () => {
    it('processes reminders on */5 * * * *', async () => {
      mockDb.getPendingReminders.mockResolvedValue([]);
      const controller = { cron: '*/5 * * * *' } as ScheduledController;

      await worker.scheduled(controller, mockEnv);
      expect(mockDb.getPendingReminders).toHaveBeenCalled();
    });

    it('runs cleanup on 0 * * * *', async () => {
      mockDb.execute.mockResolvedValue({ meta: { changes: 0 } });
      const controller = { cron: '0 * * * *' } as ScheduledController;

      await worker.scheduled(controller, mockEnv);
      expect(mockDb.execute).toHaveBeenCalledTimes(2);
    });

    it('generates daily summary on 0 0 * * *', async () => {
      mockDb.query.mockResolvedValue([{ id: 'user1' }, { id: 'user2' }]);
      mockDb.get.mockResolvedValue({ count: 3 });

      const controller = { cron: '0 0 * * *' } as ScheduledController;
      await worker.scheduled(controller, mockEnv);

      expect(mockDb.query).toHaveBeenCalled();
      expect(mockDb.get).toHaveBeenCalled();
      expect(mockEnv.KV.put).toHaveBeenCalled();
    });

    it('daily summary skips users with no activity', async () => {
      mockDb.query.mockResolvedValue([{ id: 'user1' }]);
      mockDb.get.mockResolvedValue({ count: 0 });

      const controller = { cron: '0 0 * * *' } as ScheduledController;
      await worker.scheduled(controller, mockEnv);

      expect(mockEnv.KV.put).not.toHaveBeenCalled();
    });

    it('logs for unhandled cron', async () => {
      const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {});
      const controller = { cron: '* * * * *' } as ScheduledController;

      await worker.scheduled(controller, mockEnv);
      expect(consoleSpy).toHaveBeenCalledWith('[SYNC] Unhandled cron schedule: * * * * *');

      consoleSpy.mockRestore();
    });
  });
});
