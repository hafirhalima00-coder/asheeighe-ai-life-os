import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension-based Result pattern using dartz Either
/// This tests the Either pattern used throughout the app.
typedef Result<T> = Either<String, T>;

/// Success result
Result<T> success<T>(T value) => Right(value);

/// Failure result
Result<T> failure<T>(String message) => Left(message);

void main() {
  group('Result (Either)', () {
    group('success', () {
      test('should contain the value', () {
        final result = success(42);
        expect(result, isA<Right<String, int>>());
        expect(result.getOrElse(() => 0), 42);
      });

      test('should be Right type', () {
        final result = success('hello');
        expect(result.isRight(), true);
        expect(result.isLeft(), false);
      });

      test('should support fold with success handler', () {
        final result = success('data');
        final output = result.fold(
          (l) => 'error: $l',
          (r) => 'value: $r',
        );
        expect(output, 'value: data');
      });
    });

    group('failure', () {
      test('should contain error message', () {
        final result = failure<String>('Something went wrong');
        expect(result, isA<Left<String, String>>());
      });

      test('should be Left type', () {
        final result = failure<String>('error');
        expect(result.isLeft(), true);
        expect(result.isRight(), false);
      });

      test('should support fold with error handler', () {
        final result = failure<String>('not found');
        final output = result.fold(
          (l) => 'error: $l',
          (r) => 'value: $r',
        );
        expect(output, 'error: not found');
      });
    });

    group('map', () {
      test('should transform success value', () {
        final result = success(10);
        final mapped = result.map((r) => r * 2);
        expect(mapped, equals(success(20)));
      });

      test('should propagate failure through map', () {
        final result = failure<int>('error');
        final mapped = result.map((r) => r * 2);
        expect(mapped, equals(failure('error')));
      });
    });

    group('flatMap / bind', () {
      test('should chain successful operations', () {
        final result = success(5);
        final chained = result.flatMap((r) => success(r * 3));
        expect(chained, equals(success(15)));
      });

      test('should short-circuit on failure', () {
        final result = failure<int>('initial error');
        final chained = result.flatMap((r) => success(r * 3));
        expect(chained, equals(failure('initial error')));
      });
    });

    group('getOrElse', () {
      test('should return value on success', () {
        final result = success('data');
        expect(result.getOrElse(() => 'default'), 'data');
      });

      test('should return default on failure', () {
        final result = failure<String>('error');
        expect(result.getOrElse(() => 'default'), 'default');
      });
    });

    group('fold', () {
      test('should handle success path', () {
        final result = success(100);
        final folded = result.fold(
          (l) => -1,
          (r) => r,
        );
        expect(folded, 100);
      });

      test('should handle failure path', () {
        final result = failure<int>('err');
        final folded = result.fold(
          (l) => -1,
          (r) => r,
        );
        expect(folded, -1);
      });
    });

    group('usage with async operations', () {
      test('should work with Future results', () async {
        Future<Result<int>> fetchData() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return success(42);
        }

        final result = await fetchData();
        expect(result.isRight(), true);
        expect(result.getOrElse(() => 0), 42);
      });

      test('should work with Future failures', () async {
        Future<Result<int>> fetchWithError() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return failure('Network error');
        }

        final result = await fetchWithError();
        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, 'Network error'),
          (r) => fail('Should not succeed'),
        );
      });
    });

    group('comparison with nullable', () {
      test('Result should distinguish error from null value', () {
        final nullResult = success(null) as Result<Null>;
        final errorResult = failure<Null>('error');

        expect(nullResult.isRight(), true);
        expect(errorResult.isLeft(), true);
      });
    });
  });
}
