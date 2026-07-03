import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DB, createDB } from '@asheeighe/db';
import { DatabaseError, NotFoundError } from '@asheeighe/core/errors';

function createMockD1() {
  const mockPrepare = vi.fn().mockReturnThis();
  const mockBind = vi.fn().mockReturnThis();
  const mockAll = vi.fn();
  const mockFirst = vi.fn();
  const mockRun = vi.fn();
  const mockBatch = vi.fn();

  const mockStmt = {
    bind: mockBind,
    all: mockAll,
    first: mockFirst,
    run: mockRun,
  };

  mockPrepare.mockReturnValue(mockStmt);

  return {
    prepare: mockPrepare,
    bind: mockBind,
    all: mockAll,
    first: mockFirst,
    run: mockRun,
    batch: mockBatch,
    _stmt: mockStmt,
  };
}

describe('DB', () => {
  let db: DB;
  let mockD1: ReturnType<typeof createMockD1>;

  beforeEach(() => {
    mockD1 = createMockD1();
    db = new DB(mockD1 as any);
  });

  describe('query', () => {
    it('returns results', async () => {
      const rows = [{ id: '1', name: 'test' }];
      mockD1.all.mockResolvedValue({ results: rows });

      const result = await db.query('SELECT * FROM test');
      expect(result).toEqual(rows);
      expect(mockD1.prepare).toHaveBeenCalledWith('SELECT * FROM test');
    });

    it('throws DatabaseError on failure', async () => {
      mockD1.all.mockRejectedValue(new Error('DB crash'));
      await expect(db.query('SELECT * FROM test')).rejects.toThrow(DatabaseError);
    });
  });

  describe('get', () => {
    it('returns single row', async () => {
      mockD1.first.mockResolvedValue({ id: '1' });
      const result = await db.get('SELECT * FROM users WHERE id = ?', '1');
      expect(result).toEqual({ id: '1' });
    });

    it('returns null when not found', async () => {
      mockD1.first.mockResolvedValue(null);
      const result = await db.get('SELECT * FROM users WHERE id = ?', 'missing');
      expect(result).toBeNull();
    });

    it('throws DatabaseError on failure', async () => {
      mockD1.first.mockRejectedValue(new Error('fail'));
      await expect(db.get('SELECT 1')).rejects.toThrow(DatabaseError);
    });
  });

  describe('execute', () => {
    it('executes write statement', async () => {
      const result = { meta: { changes: 1 } };
      mockD1.run.mockResolvedValue(result);
      const res = await db.execute('DELETE FROM test WHERE id = ?', '1');
      expect(res.meta.changes).toBe(1);
    });

    it('throws DatabaseError on failure', async () => {
      mockD1.run.mockRejectedValue(new Error('write fail'));
      await expect(db.execute('DELETE FROM test')).rejects.toThrow(DatabaseError);
    });
  });

  describe('batch', () => {
    it('executes multiple statements', async () => {
      mockD1.batch.mockResolvedValue([{ meta: { changes: 1 } }, { meta: { changes: 1 } }]);
      const result = await db.batch([{ sql: 'INSERT INTO t (id) VALUES (?)', bindings: ['1'] }]);
      expect(result).toHaveLength(1);
    });

    it('throws DatabaseError on failure', async () => {
      mockD1.batch.mockRejectedValue(new Error('batch fail'));
      await expect(db.batch([])).rejects.toThrow(DatabaseError);
    });
  });

  describe('insert', () => {
    it('inserts row and returns id', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      const id = await db.insert('users', { id: 'abc', email: 'test@test.com', name: 'Test' });
      expect(id).toBe('abc');
      expect(mockD1.prepare).toHaveBeenCalledWith('INSERT INTO users (id, email, name) VALUES (?, ?, ?)');
    });
  });

  describe('update', () => {
    it('updates row', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      await db.update('users', 'abc', { name: 'Updated' });
      expect(mockD1.run).toHaveBeenCalled();
    });
  });

  describe('delete', () => {
    it('deletes row by id', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      await db.delete('users', 'abc');
      expect(mockD1.prepare).toHaveBeenCalledWith('DELETE FROM users WHERE id = ?');
    });

    it('deletes with userId scoping', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      await db.delete('tasks', 'abc', 'user1');
      expect(mockD1.prepare).toHaveBeenCalledWith('DELETE FROM tasks WHERE id = ? AND user_id = ?');
    });

    it('throws NotFoundError when no rows affected', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 0 } });
      await expect(db.delete('users', 'missing')).rejects.toThrow(NotFoundError);
    });
  });

  describe('findById', () => {
    it('returns found row', async () => {
      mockD1.first.mockResolvedValue({ id: '1', name: 'Test' });
      const result = await db.findById('users', '1');
      expect(result).toEqual({ id: '1', name: 'Test' });
    });
  });

  describe('findByUserId', () => {
    it('returns paginated results', async () => {
      mockD1.first.mockResolvedValue({ count: 2 });
      mockD1.all.mockResolvedValue({ results: [{ id: '1' }, { id: '2' }] });

      const result = await db.findByUserId('tasks', 'user1', { page: 1, limit: 10 });
      expect(result.total).toBe(2);
      expect(result.data).toHaveLength(2);
    });

    it('applies filters', async () => {
      mockD1.first.mockResolvedValue({ count: 0 });
      mockD1.all.mockResolvedValue({ results: [] });

      await db.findByUserId('tasks', 'user1', {
        filters: { status: 'pending' },
      });

      const sql = mockD1.prepare.mock.calls[0][0];
      expect(sql).toContain('AND status = ?');
    });

    it('uses default pagination', async () => {
      mockD1.first.mockResolvedValue({ count: 0 });
      mockD1.all.mockResolvedValue({ results: [] });

      await db.findByUserId('notes', 'user1');
      expect(mockD1.prepare.mock.calls[1][0]).toContain('LIMIT ? OFFSET ?');
    });
  });

  describe('userExists', () => {
    it('returns true when user exists', async () => {
      mockD1.first.mockResolvedValue({ id: '1' });
      expect(await db.userExists('test@test.com')).toBe(true);
    });

    it('returns false when user does not exist', async () => {
      mockD1.first.mockResolvedValue(null);
      expect(await db.userExists('missing@test.com')).toBe(false);
    });
  });

  describe('findByEmail', () => {
    it('returns user when found', async () => {
      mockD1.first.mockResolvedValue({ id: '1', email: 'test@test.com', display_name: 'Test' });
      const user = await db.findByEmail('test@test.com');
      expect(user).not.toBeNull();
      expect(user!.id).toBe('1');
    });

    it('returns null when not found', async () => {
      mockD1.first.mockResolvedValue(null);
      expect(await db.findByEmail('missing@test.com')).toBeNull();
    });
  });

  describe('createUser', () => {
    it('creates and returns user', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      mockD1.first
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce({ id: 'abc', email: 'test@test.com', display_name: 'Test', password_hash: 'hash' });

      const user = await db.createUser({ id: 'abc', email: 'test@test.com', password_hash: 'hash', display_name: 'Test' });
      expect(user.id).toBe('abc');
      expect(user.email).toBe('test@test.com');
    });
  });

  describe('getCalendarEvents', () => {
    it('returns events without date filter', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      const events = await db.getCalendarEvents('user1');
      expect(events).toEqual([]);
    });

    it('applies date range filters', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      await db.getCalendarEvents('user1', '2026-01-01T00:00:00Z', '2026-12-31T23:59:59Z');
      const sql = mockD1.prepare.mock.calls[0][0];
      expect(sql).toContain('end_time >=');
      expect(sql).toContain('start_time <=');
    });
  });

  describe('getTasksByStatus', () => {
    it('returns tasks without status filter', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      const tasks = await db.getTasksByStatus('user1');
      expect(tasks).toEqual([]);
    });

    it('filters by status', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      await db.getTasksByStatus('user1', 'pending');
      const sql = mockD1.prepare.mock.calls[0][0];
      expect(sql).toContain('AND status = ?');
    });
  });

  describe('getPendingReminders', () => {
    it('returns pending reminders', async () => {
      mockD1.all.mockResolvedValue({ results: [{ id: 'r1', title: 'Meeting', dismissed: 0 }] });
      const reminders = await db.getPendingReminders('2026-07-03T12:00:00Z');
      expect(reminders).toHaveLength(1);
      expect(reminders[0]).toHaveProperty('id', 'r1');
    });
  });

  describe('getNotesByNotebook', () => {
    it('returns notes without notebook filter', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      const notes = await db.getNotesByNotebook('user1');
      expect(notes).toEqual([]);
    });

    it('filters by null notebook', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      await db.getNotesByNotebook('user1', null);
      const sql = mockD1.prepare.mock.calls[0][0];
      expect(sql).toContain('AND notebook_id IS NULL');
    });

    it('filters by specific notebook', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      await db.getNotesByNotebook('user1', 'nb-1');
      const sql = mockD1.prepare.mock.calls[0][0];
      expect(sql).toContain('AND notebook_id = ?');
    });
  });

  describe('getConnectedAccounts', () => {
    it('returns accounts ordered by creation date', async () => {
      mockD1.all.mockResolvedValue({ results: [] });
      const accounts = await db.getConnectedAccounts('user1');
      expect(accounts).toEqual([]);
    });
  });

  describe('saveConnection', () => {
    it('inserts connection data', async () => {
      mockD1.run.mockResolvedValue({ meta: { changes: 1 } });
      await db.saveConnection({
        id: 'c1',
        user_id: 'u1',
        integration_name: 'google',
        integration_id: 'int-1',
        connection_id: 'conn-1',
        status: 'active',
        auth_mode: 'OAUTH2',
        account_info: '{}',
      });
      expect(mockD1.prepare).toHaveBeenCalledWith(expect.stringContaining('INSERT INTO composio_connections'));
    });
  });

  describe('createDB', () => {
    it('returns a DB instance', () => {
      const result = createDB(mockD1 as any);
      expect(result).toBeInstanceOf(DB);
    });
  });
});
