import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/errors/failures.dart';
import 'package:pinkz/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:pinkz/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:pinkz/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late GetDashboardDataUseCase useCase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetDashboardDataUseCase(repository: mockRepository);
  });

  const userId = 'user123';
  final testDate = DateTime(2024, 6, 15);
  final testData = DashboardData(greeting: 'Hello', date: testDate);

  group('GetDashboardDataUseCase', () {
    test('should call repository with correct params', () async {
      when(() => mockRepository.getDashboardData(
            userId: any(named: 'userId'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => Right(testData));

      final result = await useCase(userId: userId, date: testDate);

      verify(() => mockRepository.getDashboardData(
            userId: userId,
            date: testDate,
          )).called(1);
      expect(result, equals(Right(testData)));
    });

    test('should return ServerFailure on repository error', () async {
      const failure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getDashboardData(
            userId: any(named: 'userId'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(userId: userId, date: testDate);

      expect(result, equals(const Left(failure)));
    });

    test('should return CacheFailure when cache fails', () async {
      const failure = CacheFailure();
      when(() => mockRepository.getDashboardData(
            userId: any(named: 'userId'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(userId: userId, date: testDate);
      expect(result, equals(const Left(failure)));
    });
  });
}
