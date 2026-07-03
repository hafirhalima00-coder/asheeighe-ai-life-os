import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/composio/domain/entities/composio_integration.dart';
import 'package:pinkz/features/composio/domain/repositories/composio_repository.dart';
import 'package:pinkz/features/composio/domain/usecases/get_integrations_usecase.dart';

class MockComposioRepository extends Mock implements ComposioRepository {}

void main() {
  late GetIntegrationsUseCase useCase;
  late MockComposioRepository mockRepository;

  setUp(() {
    mockRepository = MockComposioRepository();
    useCase = GetIntegrationsUseCase(mockRepository);
  });

  final testIntegrations = [
    const ComposioIntegration(
      id: '1',
      name: 'Google Calendar',
      description: 'Calendar sync',
      category: 'calendar',
    ),
    const ComposioIntegration(
      id: '2',
      name: 'Gmail',
      description: 'Email integration',
      category: 'communication',
    ),
  ];

  group('GetIntegrationsUseCase', () {
    test('should call repository.getIntegrations', () async {
      when(() => mockRepository.getIntegrations())
          .thenAnswer((_) async => Right(testIntegrations));

      final result = await useCase();

      verify(() => mockRepository.getIntegrations()).called(1);
      expect(result, equals(Right(testIntegrations)));
    });

    test('should return list of integrations', () async {
      when(() => mockRepository.getIntegrations())
          .thenAnswer((_) async => Right(testIntegrations));

      final result = await useCase();
      expect(result.isRight(), true);
      expect((result as Right).value.length, 2);
    });

    test('should return empty list when no integrations', () async {
      when(() => mockRepository.getIntegrations())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase();
      expect(result, equals(const Right([])));
    });

    test('should return ServerFailure on error', () async {
      const failure = ServerFailure(message: 'API unavailable');
      when(() => mockRepository.getIntegrations())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();
      expect(result, equals(const Left(failure)));
    });

    test('should return NetworkFailure on connection error', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.getIntegrations())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();
      expect(result, equals(const Left(failure)));
    });
  });
}
