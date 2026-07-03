import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/core/errors/failures.dart';

void main() {
  group('Failure sealed class hierarchy', () {
    group('ServerFailure', () {
      test('should create with default message', () {
        const failure = ServerFailure();
        expect(failure.message, 'Server error occurred.');
        expect(failure.statusCode, isNull);
        expect(failure.error, isNull);
      });

      test('should create with custom values', () {
        const failure = ServerFailure(
          message: 'Custom server error',
          statusCode: 500,
          error: 'details',
        );
        expect(failure.message, 'Custom server error');
        expect(failure.statusCode, 500);
        expect(failure.error, 'details');
      });

      test('should support equality', () {
        const failure1 = ServerFailure(statusCode: 500);
        const failure2 = ServerFailure(statusCode: 500);
        const failure3 = ServerFailure(statusCode: 502);
        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });

      test('should have correct props', () {
        const failure = ServerFailure(
          message: 'error',
          statusCode: 500,
          error: 'err',
        );
        expect(failure.props, ['error', 500, 'err']);
      });
    });

    group('CacheFailure', () {
      test('should create with default message', () {
        const failure = CacheFailure();
        expect(failure.message, 'Cache error occurred.');
        expect(failure.statusCode, isNull);
      });

      test('should support equality', () {
        const failure1 = CacheFailure();
        const failure2 = CacheFailure();
        expect(failure1, equals(failure2));
      });
    });

    group('AuthFailure', () {
      test('should create with default message', () {
        const failure = AuthFailure();
        expect(failure.message, 'Authentication failed.');
      });

      test('should create with custom status code', () {
        const failure = AuthFailure(statusCode: 401);
        expect(failure.statusCode, 401);
      });
    });

    group('NetworkFailure', () {
      test('should create with default message', () {
        const failure = NetworkFailure();
        expect(failure.message, 'No internet connection.');
      });
    });

    group('TimeoutFailure', () {
      test('should create with default message', () {
        const failure = TimeoutFailure();
        expect(failure.message, 'Request timed out.');
      });
    });

    group('ValidationFailure', () {
      test('should create with default message', () {
        const failure = ValidationFailure();
        expect(failure.message, 'Validation failed.');
      });
    });

    group('NotFoundFailure', () {
      test('should create with default status code 404', () {
        const failure = NotFoundFailure();
        expect(failure.message, 'Resource not found.');
        expect(failure.statusCode, 404);
      });
    });

    group('PermissionFailure', () {
      test('should create with default status code 403', () {
        const failure = PermissionFailure();
        expect(failure.message, 'Permission denied.');
        expect(failure.statusCode, 403);
      });
    });

    group('UnexpectedFailure', () {
      test('should create with default message', () {
        const failure = UnexpectedFailure();
        expect(failure.message, 'An unexpected error occurred.');
      });
    });

    group('equality across types', () {
      test('different types should not be equal', () {
        const server = ServerFailure();
        const network = NetworkFailure();
        expect(server, isNot(equals(network)));
      });

      test('same type with same values should be equal', () {
        const f1 = AuthFailure(message: 'test', statusCode: 401);
        const f2 = AuthFailure(message: 'test', statusCode: 401);
        expect(f1, equals(f2));
      });

      test('hashCode should match equality', () {
        const f1 = AuthFailure(message: 'test');
        const f2 = AuthFailure(message: 'test');
        expect(f1.hashCode, equals(f2.hashCode));
      });
    });
  });
}
