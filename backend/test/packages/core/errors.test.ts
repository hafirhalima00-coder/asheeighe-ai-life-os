import { describe, it, expect } from 'vitest';
import {
  AppError,
  AuthError,
  NotFoundError,
  ValidationError,
  ConflictError,
  RateLimitError,
  DatabaseError,
  ForbiddenError,
  ExternalServiceError,
  isAppError,
  handleError,
} from '@pinkz/core/errors';

describe('AppError', () => {
  it('creates an error with correct properties', () => {
    const error = new AppError('Test error', 400, 'TEST_CODE', { key: 'value' });
    expect(error).toBeInstanceOf(Error);
    expect(error.message).toBe('Test error');
    expect(error.statusCode).toBe(400);
    expect(error.code).toBe('TEST_CODE');
    expect(error.details).toEqual({ key: 'value' });
    expect(error.name).toBe('AppError');
  });

  it('creates an error without details', () => {
    const error = new AppError('Simple error', 500, 'SIMPLE');
    expect(error.details).toBeUndefined();
  });

  it('toJSON returns correct shape with details', () => {
    const error = new AppError('Test', 400, 'ERR', { field: 'name' });
    expect(error.toJSON()).toEqual({
      success: false,
      error: 'ERR',
      message: 'Test',
      details: { field: 'name' },
    });
  });

  it('toJSON omits details when absent', () => {
    const error = new AppError('Test', 400, 'ERR');
    expect(error.toJSON()).toEqual({
      success: false,
      error: 'ERR',
      message: 'Test',
    });
  });
});

describe('AuthError', () => {
  it('creates with default message', () => {
    const error = new AuthError();
    expect(error.message).toBe('Authentication required');
    expect(error.statusCode).toBe(401);
    expect(error.code).toBe('AUTH_ERROR');
  });

  it('creates with custom message', () => {
    const error = new AuthError('Custom auth message');
    expect(error.message).toBe('Custom auth message');
    expect(error.statusCode).toBe(401);
  });
});

describe('ForbiddenError', () => {
  it('creates with default message', () => {
    const error = new ForbiddenError();
    expect(error.message).toBe('Access denied');
    expect(error.statusCode).toBe(403);
    expect(error.code).toBe('FORBIDDEN');
  });
});

describe('NotFoundError', () => {
  it('creates without id', () => {
    const error = new NotFoundError('User');
    expect(error.message).toBe('User not found');
    expect(error.statusCode).toBe(404);
    expect(error.code).toBe('NOT_FOUND');
  });

  it('creates with id', () => {
    const error = new NotFoundError('Task', 'abc-123');
    expect(error.message).toBe("Task with id 'abc-123' not found");
  });

  it('uses default resource name', () => {
    const error = new NotFoundError();
    expect(error.message).toBe('Resource not found');
  });
});

describe('ValidationError', () => {
  it('creates with default message', () => {
    const error = new ValidationError();
    expect(error.message).toBe('Validation failed');
    expect(error.statusCode).toBe(400);
    expect(error.code).toBe('VALIDATION_ERROR');
  });

  it('creates with details', () => {
    const error = new ValidationError('Invalid input', { field: 'email' });
    expect(error.details).toEqual({ field: 'email' });
  });
});

describe('ConflictError', () => {
  it('creates with default message', () => {
    const error = new ConflictError();
    expect(error.message).toBe('Resource already exists');
    expect(error.statusCode).toBe(409);
    expect(error.code).toBe('CONFLICT');
  });
});

describe('RateLimitError', () => {
  it('creates with default message', () => {
    const error = new RateLimitError();
    expect(error.message).toBe('Too many requests');
    expect(error.statusCode).toBe(429);
    expect(error.code).toBe('RATE_LIMIT');
  });
});

describe('DatabaseError', () => {
  it('creates with default message', () => {
    const error = new DatabaseError();
    expect(error.message).toBe('Database operation failed');
    expect(error.statusCode).toBe(500);
    expect(error.code).toBe('DATABASE_ERROR');
  });
});

describe('ExternalServiceError', () => {
  it('creates with service name', () => {
    const error = new ExternalServiceError('OpenAI');
    expect(error.message).toBe('OpenAI: External service error');
    expect(error.statusCode).toBe(502);
    expect(error.code).toBe('EXTERNAL_SERVICE_ERROR');
  });

  it('creates with custom message', () => {
    const error = new ExternalServiceError('Composio', 'Connection failed');
    expect(error.message).toBe('Composio: Connection failed');
  });
});

describe('isAppError', () => {
  it('returns true for AppError instances', () => {
    expect(isAppError(new AppError('', 500, ''))).toBe(true);
    expect(isAppError(new AuthError())).toBe(true);
    expect(isAppError(new NotFoundError())).toBe(true);
  });

  it('returns false for other errors', () => {
    expect(isAppError(new Error())).toBe(false);
    expect(isAppError('string')).toBe(false);
    expect(isAppError(null)).toBe(false);
    expect(isAppError(undefined)).toBe(false);
    expect(isAppError({})).toBe(false);
  });
});

describe('handleError', () => {
  it('returns AppError unchanged', () => {
    const original = new AppError('test', 400, 'ERR');
    const result = handleError(original);
    expect(result).toBe(original);
  });

  it('wraps Error in AppError', () => {
    const result = handleError(new Error('something broke'));
    expect(result).toBeInstanceOf(AppError);
    expect(result.message).toBe('something broke');
    expect(result.statusCode).toBe(500);
    expect(result.code).toBe('INTERNAL_ERROR');
  });

  it('wraps unknown values', () => {
    const result = handleError('unexpected');
    expect(result.message).toBe('An unexpected error occurred');
    expect(result.statusCode).toBe(500);
  });
});
