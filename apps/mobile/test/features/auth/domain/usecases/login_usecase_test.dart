import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/auth/domain/entities/auth_user.dart';
import 'package:pinkz/features/auth/domain/repositories/auth_repository.dart';
import 'package:pinkz/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const testUser = AuthUser(id: '1', email: 'test@example.com');
  const testParams = LoginParams(
    email: 'test@example.com',
    password: 'Password123',
  );

  group('LoginUseCase', () {
    test('should call repository.login with correct params', () async {
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(testUser));

      final result = await useCase(testParams);

      verify(() => mockRepository.login(
            email: 'test@example.com',
            password: 'Password123',
          )).called(1);
      expect(result, equals(const Right(testUser)));
    });

    test('should return AuthFailure when login fails', () async {
      const failure = AuthFailure(message: 'Invalid credentials');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);

      expect(result, equals(const Left(failure)));
    });

    test('should return ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'Server error');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);

      expect(result, equals(const Left(failure)));
    });

    test('should return NetworkFailure on connection error', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);

      expect(result, equals(const Left(failure)));
    });
  });
}
