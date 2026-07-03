import { ValidationError } from './errors';

export function generateId(): string {
  return crypto.randomUUID();
}

export function nowISO(): string {
  return new Date().toISOString();
}

export function formatDate(iso: string, timezone = 'UTC'): string {
  const date = new Date(iso);
  return date.toLocaleDateString('en-US', { timeZone: timezone });
}

export function formatDateTime(iso: string, timezone = 'UTC'): string {
  const date = new Date(iso);
  return date.toLocaleString('en-US', { timeZone: timezone });
}

export function formatTime(iso: string, timezone = 'UTC'): string {
  const date = new Date(iso);
  return date.toLocaleTimeString('en-US', { timeZone: timezone });
}

export function isValidEmail(email: string): boolean {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

export function isValidUrl(url: string): boolean {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
}

export function isValidTimezone(tz: string): boolean {
  try {
    Intl.DateTimeFormat(undefined, { timeZone: tz });
    return true;
  } catch {
    return false;
  }
}

export function parseJsonSafe<T>(json: string, fallback: T): T {
  try {
    return JSON.parse(json) as T;
  } catch {
    return fallback;
  }
}

export function toSnakeCase(obj: Record<string, unknown>): Record<string, unknown> {
  const result: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(obj)) {
    const snake = key.replace(/[A-Z]/g, (l) => `_${l.toLowerCase()}`);
    result[snake] = value;
  }
  return result;
}

export function toCamelCase(obj: Record<string, unknown>): Record<string, unknown> {
  const result: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(obj)) {
    const camel = key.replace(/_([a-z])/g, (_, l) => l.toUpperCase());
    result[camel] = value;
  }
  return result;
}

export function mapRowToCamelCase<T>(row: Record<string, unknown> | null): T | null {
  if (!row) return null;
  return toCamelCase(row) as T;
}

export function mapRowsToCamelCase<T>(rows: Record<string, unknown>[]): T[] {
  return rows.map((r) => toCamelCase(r) as T);
}

export function buildUpdateQuery(
  table: string,
  data: Partial<Record<string, unknown>>,
  idField: string,
  id: string,
): { sql: string; bindings: unknown[] } {
  const entries = Object.entries(data).filter(([, v]) => v !== undefined);
  if (entries.length === 0) {
    throw new ValidationError('No fields to update');
  }
  const sets = entries.map(([key]) => `${key} = ?`).join(', ');
  const bindings = entries.map(([, v]) => v);
  bindings.push(id);
  return {
    sql: `UPDATE ${table} SET ${sets}, updated_at = datetime('now') WHERE ${idField} = ?`,
    bindings,
  };
}

export function buildPaginationParams(
  page?: number,
  limit?: number,
): { page: number; limit: number; offset: number } {
  const p = Math.max(1, page ?? 1);
  const l = Math.min(100, Math.max(1, limit ?? 20));
  return { page: p, limit: l, offset: (p - 1) * l };
}
