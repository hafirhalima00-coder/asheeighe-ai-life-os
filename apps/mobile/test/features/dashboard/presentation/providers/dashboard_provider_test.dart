import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:asheeighe/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:asheeighe/features/dashboard/presentation/providers/dashboard_provider.dart';

class MockGetDashboardDataUseCase extends Mock implements GetDashboardDataUseCase {}

void main() {
  late MockGetDashboardDataUseCase mockUseCase;
  late DashboardNotifier notifier;

  setUp(() {
    mockUseCase = MockGetDashboardDataUseCase();
    notifier = DashboardNotifier(getDashboardData: mockUseCase);
  });

  final testDate = DateTime(2024, 6, 15);
  final testData = DashboardData(greeting: 'Good morning', date: testDate);

  group('DashboardNotifier', () {
    group('loadDashboard', () {
      test('should set loaded status with data on success', () async {
        when(() => mockUseCase(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            )).thenAnswer((_) async => Right(testData));

        await notifier.loadDashboard();

        expect(notifier.state.status, DashboardStatus.loaded);
        expect(notifier.state.data, equals(testData));
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set error status on failure', () async {
        const failure = ServerFailure(message: 'Server error');
        when(() => mockUseCase(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            )).thenAnswer((_) async => const Left(failure));

        await notifier.loadDashboard();

        expect(notifier.state.status, DashboardStatus.error);
        expect(notifier.state.errorMessage, 'Server error');
      });

      test('should set loading status before fetching', () async {
        when(() => mockUseCase(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            )).thenAnswer((_) async => Right(testData));

        final future = notifier.loadDashboard();
        expect(notifier.state.status, DashboardStatus.loading);
        await future;
      });
    });

    group('refresh', () {
      test('should set refreshing status and loaded data on success', () async {
        when(() => mockUseCase(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            )).thenAnswer((_) async => Right(testData));

        await notifier.refresh();

        expect(notifier.state.status, DashboardStatus.loaded);
        expect(notifier.state.data, equals(testData));
      });

      test('should set error on failure', () async {
        const failure = NetworkFailure();
        when(() => mockUseCase(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            )).thenAnswer((_) async => const Left(failure));

        await notifier.refresh();

        expect(notifier.state.status, DashboardStatus.error);
      });
    });

    group('updateUserName', () {
      test('should update userName', () {
        notifier.updateUserName('Alice');
        expect(notifier.state.userName, 'Alice');
      });
    });

    group('updateTaskStatus', () {
      test('should update pending task completion status', () {
        final task = Task(id: '1', title: 'Task 1');
        final data = DashboardData(
          greeting: 'Hi',
          date: testDate,
          pendingTasks: [task],
        );
        notifier = DashboardNotifier(getDashboardData: mockUseCase);
        notifier.loadDashboard();
        notifier.updateTaskStatus('1', true);

        expect(notifier.state.data?.pendingTasks.first.isCompleted, true);
      });
    });
  });
}
