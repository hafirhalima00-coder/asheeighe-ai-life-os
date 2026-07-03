import type { CalendarEvent, Task, Reminder, Note, User, ComposioConnectedAccount } from '@pinkz/core';
import { DatabaseError, NotFoundError } from '@pinkz/core/errors';
import { buildUpdateQuery, buildPaginationParams, mapRowToCamelCase, mapRowsToCamelCase } from '@pinkz/core/utils';

type D1Database = import('@cloudflare/workers-types').D1Database;
type D1Result = import('@cloudflare/workers-types').D1Result;

export interface PaginationOptions {
  page?: number;
  limit?: number;
}

export interface QueryOptions extends PaginationOptions {
  orderBy?: string;
  orderDir?: 'ASC' | 'DESC';
  filters?: Record<string, unknown>;
}

export class DB {
  constructor(private readonly db: D1Database) {}

  async query<T = Record<string, unknown>>(sql: string, ...bindings: unknown[]): Promise<T[]> {
    try {
      const result = await this.db.prepare(sql).bind(...bindings).all();
      return result.results as T[];
    } catch (error) {
      throw new DatabaseError(`Query failed: ${(error as Error).message}`);
    }
  }

  async get<T = Record<string, unknown>>(sql: string, ...bindings: unknown[]): Promise<T | null> {
    try {
      const result = await this.db.prepare(sql).bind(...bindings).first();
      return result as T | null;
    } catch (error) {
      throw new DatabaseError(`Get failed: ${(error as Error).message}`);
    }
  }

  async execute(sql: string, ...bindings: unknown[]): Promise<D1Result> {
    try {
      return await this.db.prepare(sql).bind(...bindings).run();
    } catch (error) {
      throw new DatabaseError(`Execute failed: ${(error as Error).message}`);
    }
  }

  async batch(statements: { sql: string; bindings: unknown[] }[]): Promise<D1Result[]> {
    try {
      const stmts = statements.map((s) => this.db.prepare(s.sql).bind(...s.bindings));
      return await this.db.batch(stmts);
    } catch (error) {
      throw new DatabaseError(`Batch failed: ${(error as Error).message}`);
    }
  }

  async insert<T extends Record<string, unknown>>(table: string, data: T): Promise<string> {
    const columns = Object.keys(data).join(', ');
    const placeholders = Object.keys(data).map(() => '?').join(', ');
    const values = Object.values(data);
    await this.execute(`INSERT INTO ${table} (${columns}) VALUES (${placeholders})`, ...values);
    return data.id as string;
  }

  async update<T extends Record<string, unknown>>(table: string, id: string, data: Partial<T>): Promise<void> {
    const { sql, bindings } = buildUpdateQuery(table, data as Record<string, unknown>, 'id', id);
    await this.execute(sql, ...bindings);
  }

  async delete(table: string, id: string, userId?: string): Promise<void> {
    let sql = `DELETE FROM ${table} WHERE id = ?`;
    const bindings: unknown[] = [id];
    if (userId) {
      sql += ' AND user_id = ?';
      bindings.push(userId);
    }
    const result = await this.execute(sql, ...bindings);
    if (result.meta.changes === 0) {
      throw new NotFoundError(table, id);
    }
  }

  async findById<T>(table: string, id: string): Promise<T | null> {
    return this.get<T>(`SELECT * FROM ${table} WHERE id = ?`, id);
  }

  async findByUserId<T>(table: string, userId: string, options: QueryOptions = {}): Promise<{ data: T[]; total: number }> {
    const { limit, offset } = buildPaginationParams(options.page, options.limit);

    let whereClause = 'WHERE user_id = ?';
    const bindings: unknown[] = [userId];

    if (options.filters) {
      for (const [key, value] of Object.entries(options.filters)) {
        if (value !== undefined) {
          whereClause += ` AND ${key} = ?`;
          bindings.push(value);
        }
      }
    }

    const orderBy = options.orderBy ?? 'created_at';
    const orderDir = options.orderDir ?? 'DESC';

    const countResult = await this.get<{ count: number }>(
      `SELECT COUNT(*) as count FROM ${table} ${whereClause}`,
      ...bindings,
    );
    const total = countResult?.count ?? 0;

    const data = await this.query<T>(
      `SELECT * FROM ${table} ${whereClause} ORDER BY ${orderBy} ${orderDir} LIMIT ? OFFSET ?`,
      ...bindings,
      limit,
      offset,
    );

    return { data, total };
  }

  async userExists(email: string): Promise<boolean> {
    const user = await this.get<{ id: string }>('SELECT id FROM users WHERE email = ?', email);
    return user !== null;
  }

  async findByEmail(email: string): Promise<User | null> {
    const row = await this.get<Record<string, unknown>>('SELECT * FROM users WHERE email = ?', email);
    return mapRowToCamelCase<User>(row ?? null);
  }

  async createUser(data: {
    id: string;
    email: string;
    password_hash: string;
    display_name?: string;
  }): Promise<User> {
    await this.insert('users', {
      id: data.id,
      email: data.email,
      password_hash: data.password_hash,
      display_name: data.display_name ?? '',
    });
    const user = await this.findById<Record<string, unknown>>('users', data.id);
    return mapRowToCamelCase<User>(user!)!;
  }

  async getCalendarEvents(userId: string, startDate?: string, endDate?: string): Promise<CalendarEvent[]> {
    let sql = 'SELECT * FROM calendar_events WHERE user_id = ?';
    const bindings: unknown[] = [userId];

    if (startDate) {
      sql += ' AND end_time >= ?';
      bindings.push(startDate);
    }
    if (endDate) {
      sql += ' AND start_time <= ?';
      bindings.push(endDate);
    }

    sql += ' ORDER BY start_time ASC';
    const rows = await this.query<Record<string, unknown>>(sql, ...bindings);
    return mapRowsToCamelCase<CalendarEvent>(rows);
  }

  async getTasksByStatus(userId: string, status?: string): Promise<Task[]> {
    let sql = 'SELECT * FROM tasks WHERE user_id = ?';
    const bindings: unknown[] = [userId];
    if (status) {
      sql += ' AND status = ?';
      bindings.push(status);
    }
    sql += ' ORDER BY sort_order ASC, created_at DESC';
    const rows = await this.query<Record<string, unknown>>(sql, ...bindings);
    return mapRowsToCamelCase<Task>(rows);
  }

  async getPendingReminders(upTo: string): Promise<Reminder[]> {
    const rows = await this.query<Record<string, unknown>>(
      'SELECT * FROM reminders WHERE remind_at <= ? AND dismissed = 0 ORDER BY remind_at ASC',
      upTo,
    );
    return mapRowsToCamelCase<Reminder>(rows);
  }

  async getNotesByNotebook(userId: string, notebookId?: string | null): Promise<Note[]> {
    let sql = 'SELECT * FROM notes WHERE user_id = ? AND archived = 0';
    const bindings: unknown[] = [userId];

    if (notebookId === null) {
      sql += ' AND notebook_id IS NULL';
    } else if (notebookId) {
      sql += ' AND notebook_id = ?';
      bindings.push(notebookId);
    }

    sql += ' ORDER BY pinned DESC, sort_order ASC, updated_at DESC';
    const rows = await this.query<Record<string, unknown>>(sql, ...bindings);
    return mapRowsToCamelCase<Note>(rows);
  }

  async getConnectedAccounts(userId: string): Promise<ComposioConnectedAccount[]> {
    const rows = await this.query<Record<string, unknown>>(
      'SELECT * FROM composio_connections WHERE user_id = ? ORDER BY created_at DESC',
      userId,
    );
    return mapRowsToCamelCase<ComposioConnectedAccount>(rows);
  }

  async saveConnection(data: {
    id: string;
    user_id: string;
    integration_name: string;
    integration_id: string;
    connection_id: string;
    status: string;
    auth_mode: string;
    account_info: string;
  }): Promise<void> {
    await this.insert('composio_connections', data);
  }
}

export function createDB(d1: D1Database): DB {
  return new DB(d1);
}
