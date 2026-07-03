import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/auth/domain/repositories/auth_repository.dart';
import 'package:pinkz/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should call repository.logout and return void', () async {
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      final result = await useCase();

      verify(() => mockRepository.logout()).called(1);
      expect(result, equals(const Right(null)));
    });

    test('should return AuthFailure when logout fails', () async {
      const failure = AuthFailure(message: 'Logout failed');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, equals(const Left(failure)));
    });

    test('should return ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'Server unavailable');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();
      expect(result, equals(const Left(failure)));
    });
  });
}
