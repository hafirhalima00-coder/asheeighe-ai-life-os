import { describe, it, expect, vi, beforeAll } from 'vitest';
import {
  generateId,
  nowISO,
  formatDate,
  formatDateTime,
  formatTime,
  isValidEmail,
  isValidUrl,
  isValidTimezone,
  parseJsonSafe,
  toSnakeCase,
  toCamelCase,
  mapRowToCamelCase,
  mapRowsToCamelCase,
  buildUpdateQuery,
  buildPaginationParams,
} from '@asheeighe/core/utils';
import { ValidationError } from '@asheeighe/core/errors';

describe('generateId', () => {
  it('returns a string', () => {
    const id = generateId();
    expect(typeof id).toBe('string');
  });

  it('returns unique values', () => {
    const ids = new Set(Array.from({ length: 100 }, () => generateId()));
    expect(ids.size).toBe(100);
  });
});

describe('nowISO', () => {
  it('returns ISO string', () => {
    const result = nowISO();
    expect(() => new Date(result)).not.toThrow();
  });
});

describe('formatDate', () => {
  it('formats date in UTC by default', () => {
    const result = formatDate('2026-07-03T12:00:00Z');
    expect(result).toBe('7/3/2026');
  });

  it('formats date with timezone', () => {
    const result = formatDate('2026-07-03T12:00:00Z', 'America/New_York');
    expect(result).toBe('7/3/2026');
  });
});

describe('formatDateTime', () => {
  it('formats date-time', () => {
    const result = formatDateTime('2026-07-03T12:00:00Z');
    expect(result).toContain('2026');
  });
});

describe('formatTime', () => {
  it('formats time', () => {
    const result = formatTime('2026-07-03T12:00:00Z');
    expect(result).toContain('12');
  });
});

describe('isValidEmail', () => {
  it('accepts valid emails', () => {
    expect(isValidEmail('test@example.com')).toBe(true);
    expect(isValidEmail('user+tag@domain.co')).toBe(true);
    expect(isValidEmail('a@b.c')).toBe(true);
  });

  it('rejects invalid emails', () => {
    expect(isValidEmail('')).toBe(false);
    expect(isValidEmail('notanemail')).toBe(false);
    expect(isValidEmail('@domain.com')).toBe(false);
    expect(isValidEmail('user@')).toBe(false);
  });
});

describe('isValidUrl', () => {
  it('accepts valid URLs', () => {
    expect(isValidUrl('https://example.com')).toBe(true);
    expect(isValidUrl('http://localhost:3000')).toBe(true);
    expect(isValidUrl('https://pinkz.app/path?q=1')).toBe(true);
  });

  it('rejects invalid URLs', () => {
    expect(isValidUrl('')).toBe(false);
    expect(isValidUrl('not-a-url')).toBe(false);
  });
});

describe('isValidTimezone', () => {
  it('accepts valid timezones', () => {
    expect(isValidTimezone('UTC')).toBe(true);
    expect(isValidTimezone('America/New_York')).toBe(true);
    expect(isValidTimezone('Asia/Tokyo')).toBe(true);
  });

  it('rejects invalid timezones', () => {
    expect(isValidTimezone('')).toBe(false);
    expect(isValidTimezone('Fake/Zone')).toBe(false);
  });
});

describe('parseJsonSafe', () => {
  it('parses valid JSON', () => {
    expect(parseJsonSafe('{"a":1}', {})).toEqual({ a: 1 });
    expect(parseJsonSafe('[1,2,3]', [])).toEqual([1, 2, 3]);
  });

  it('returns fallback for invalid JSON', () => {
    expect(parseJsonSafe('invalid', { fallback: true })).toEqual({ fallback: true });
    expect(parseJsonSafe('', [])).toEqual([]);
  });
});

describe('toSnakeCase', () => {
  it('converts camelCase to snake_case', () => {
    expect(toSnakeCase({ firstName: 'John', lastName: 'Doe' })).toEqual({
      first_name: 'John',
      last_name: 'Doe',
    });
  });

  it('handles single word keys', () => {
    expect(toSnakeCase({ name: 'test' })).toEqual({ name: 'test' });
  });

  it('handles empty object', () => {
    expect(toSnakeCase({})).toEqual({});
  });
});

describe('toCamelCase', () => {
  it('converts snake_case to camelCase', () => {
    expect(toCamelCase({ first_name: 'John', last_name: 'Doe' })).toEqual({
      firstName: 'John',
      lastName: 'Doe',
    });
  });

  it('handles single word keys', () => {
    expect(toCamelCase({ name: 'test' })).toEqual({ name: 'test' });
  });

  it('handles empty object', () => {
    expect(toCamelCase({})).toEqual({});
  });
});

describe('mapRowToCamelCase', () => {
  it('converts row to camelCase', () => {
    const result = mapRowToCamelCase<{ firstName: string }>({ first_name: 'Jane' });
    expect(result).toEqual({ firstName: 'Jane' });
  });

  it('returns null for null input', () => {
    expect(mapRowToCamelCase(null)).toBeNull();
  });
});

describe('mapRowsToCamelCase', () => {
  it('converts all rows', () => {
    const result = mapRowsToCamelCase([{ user_id: '1' }, { user_id: '2' }]);
    expect(result).toEqual([{ userId: '1' }, { userId: '2' }]);
  });

  it('handles empty array', () => {
    expect(mapRowsToCamelCase([])).toEqual([]);
  });
});

describe('buildUpdateQuery', () => {
  it('builds query with fields', () => {
    const result = buildUpdateQuery('users', { name: 'John', email: 'john@test.com' }, 'id', 'abc');
    expect(result.sql).toBe("UPDATE users SET name = ?, email = ?, updated_at = datetime('now') WHERE id = ?");
    expect(result.bindings).toEqual(['John', 'john@test.com', 'abc']);
  });

  it('filters undefined values', () => {
    const result = buildUpdateQuery('tasks', { title: 'Task', description: undefined }, 'id', '1');
    expect(result.bindings).toEqual(['Task', '1']);
  });

  it('throws ValidationError for no fields', () => {
    expect(() => buildUpdateQuery('x', {}, 'id', '1')).toThrow(ValidationError);
  });
});

describe('buildPaginationParams', () => {
  it('returns defaults when no args', () => {
    expect(buildPaginationParams()).toEqual({ page: 1, limit: 20, offset: 0 });
  });

  it('computes correct offset', () => {
    expect(buildPaginationParams(3, 10)).toEqual({ page: 3, limit: 10, offset: 20 });
  });

  it('clamps minimum page to 1', () => {
    expect(buildPaginationParams(0)).toHaveProperty('page', 1);
    expect(buildPaginationParams(-5)).toHaveProperty('page', 1);
  });

  it('clamps limit between 1 and 100', () => {
    expect(buildPaginationParams(1, 0)).toHaveProperty('limit', 1);
    expect(buildPaginationParams(1, 200)).toHaveProperty('limit', 100);
  });
});
