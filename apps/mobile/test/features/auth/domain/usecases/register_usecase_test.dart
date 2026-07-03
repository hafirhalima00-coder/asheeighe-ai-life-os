import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/auth/domain/entities/auth_user.dart';
import 'package:pinkz/features/auth/domain/repositories/auth_repository.dart';
import 'package:pinkz/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  const testUser = AuthUser(id: '1', email: 'test@example.com', name: 'Test');
  const testParams = RegisterParams(
    name: 'Test User',
    email: 'test@example.com',
    password: 'Password123',
  );

  group('RegisterUseCase', () {
    test('should call repository.register with correct params', () async {
      when(() => mockRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(testUser));

      final result = await useCase(testParams);

      verify(() => mockRepository.register(
            name: 'Test User',
            email: 'test@example.com',
            password: 'Password123',
          )).called(1);
      expect(result, equals(const Right(testUser)));
    });

    test('should return ValidationFailure when email is invalid', () async {
      const failure = ValidationFailure(message: 'Invalid email');
      when(() => mockRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);

      expect(result, equals(const Left(failure)));
    });

    test('should return AuthFailure on duplicate email', () async {
      const failure = AuthFailure(message: 'Email already registered');
      when(() => mockRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);

      expect(result, equals(const Left(failure)));
    });

    test('should return ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'Server unavailable');
      when(() => mockRepository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);
      expect(result, equals(const Left(failure)));
    });
  });
}
