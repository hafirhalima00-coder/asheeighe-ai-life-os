import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/core/errors/app_exceptions.dart';

void main() {
  group('AppException', () {
    test('should create with message and optional code', () {
      const exception = AppException(message: 'Test error', code: 400);
      expect(exception.message, 'Test error');
      expect(exception.code, 400);
    });

    test('toString should return formatted string', () {
      const exception = AppException(message: 'Error', code: 500);
      expect(exception.toString(), 'AppException: Error (code: 500)');
    });

    test('stackTrace should be null by default', () {
      const exception = AppException(message: 'Error');
      expect(exception.stackTrace, isNull);
    });
  });

  group('AuthException', () {
    test('should have default message', () {
      const exception = AuthException();
      expect(exception.message, 'Authentication error');
    });
  });

  group('ValidationException', () {
    test('should have default message', () {
      const exception = ValidationException();
      expect(exception.message, 'Validation error');
    });

    test('should support fieldErrors', () {
      const exception = ValidationException(
        fieldErrors: {'email': ['invalid']},
      );
      expect(exception.fieldErrors, isNotNull);
      expect(exception.fieldErrors!['email'], contains('invalid'));
    });

    test('fieldErrors should be null when not provided', () {
      const exception = ValidationException();
      expect(exception.fieldErrors, isNull);
    });
  });

  group('NetworkException', () {
    test('should have default message', () {
      const exception = NetworkException();
      expect(exception.message, 'Network error');
    });
  });

  group('CacheException', () {
    test('should have default message', () {
      const exception = CacheException();
      expect(exception.message, 'Cache error');
    });
  });

  group('StorageException', () {
    test('should have default message', () {
      const exception = StorageException();
      expect(exception.message, 'Storage error');
    });
  });

  group('PermissionException', () {
    test('should have default message', () {
      const exception = PermissionException();
      expect(exception.message, 'Permission denied');
    });
  });

  group('TimeoutException', () {
    test('should have default message', () {
      const exception = TimeoutException();
      expect(exception.message, 'Operation timed out');
    });
  });

  group('NotFoundException', () {
    test('should have default code 404', () {
      const exception = NotFoundException();
      expect(exception.message, 'Resource not found');
      expect(exception.code, 404);
    });
  });

  group('BadRequestException', () {
    test('should have default code 400', () {
      const exception = BadRequestException();
      expect(exception.message, 'Bad request');
      expect(exception.code, 400);
    });
  });

  group('ServerException', () {
    test('should have default code 500', () {
      const exception = ServerException();
      expect(exception.message, 'Internal server error');
      expect(exception.code, 500);
    });
  });

  group('custom values across all exceptions', () {
    test('all exceptions accept custom message and code', () {
      const exceptions = [
        AuthException(message: 'x', code: 1),
        ValidationException(message: 'x', code: 2),
        NetworkException(message: 'x', code: 3),
        CacheException(message: 'x', code: 4),
        StorageException(message: 'x', code: 5),
        PermissionException(message: 'x', code: 6),
        TimeoutException(message: 'x', code: 7),
        NotFoundException(message: 'x', code: 404),
        BadRequestException(message: 'x', code: 400),
        ServerException(message: 'x', code: 500),
      ];
      for (final e in exceptions) {
        expect(e.message, 'x');
      }
    });
  });
}
