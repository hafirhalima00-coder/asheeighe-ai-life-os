import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/auth/domain/entities/auth_user.dart';
import 'package:asheeighe/features/auth/domain/repositories/auth_repository.dart';
import 'package:asheeighe/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthNotifier authNotifier;

  setUp(() {
    mockRepository = MockAuthRepository();
    authNotifier = AuthNotifier();
  });

  const testUser = AuthUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test',
  );

  group('AuthNotifier', () {
    group('login', () {
      test('should set user and authenticated status on success', () async {
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Right(testUser));

        await authNotifier.login(email: 'test@example.com', password: 'pass');

        expect(authNotifier.state.valueOrNull?.user, equals(testUser));
        expect(
          authNotifier.state.valueOrNull?.status,
          AuthStatus.authenticated,
        );
      });

      test('should set error on failure', () async {
        const failure = AuthFailure(message: 'Invalid credentials');
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(failure));

        await authNotifier.login(email: 'test@example.com', password: 'pass');

        expect(authNotifier.state.hasError, true);
      });
    });

    group('register', () {
      test('should set user and authenticated status on success', () async {
        when(() => mockRepository.register(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Right(testUser));

        await authNotifier.register(
          name: 'Test',
          email: 'test@example.com',
          password: 'pass',
        );

        expect(authNotifier.state.valueOrNull?.user, equals(testUser));
        expect(
          authNotifier.state.valueOrNull?.status,
          AuthStatus.authenticated,
        );
      });

      test('should set error on failure', () async {
        when(() => mockRepository.register(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async =>
            const Left(ValidationFailure(message: 'Invalid email')));

        await authNotifier.register(
          name: 'Test',
          email: 'bad',
          password: 'pass',
        );

        expect(authNotifier.state.hasError, true);
      });
    });

    group('logout', () {
      test('should set unauthenticated status', () async {
        when(() => mockRepository.logout())
            .thenAnswer((_) async => const Right(null));

        await authNotifier.logout();

        expect(
          authNotifier.state.valueOrNull?.status,
          AuthStatus.unauthenticated,
        );
        expect(authNotifier.state.valueOrNull?.user, isNull);
      });
    });
  });
}
