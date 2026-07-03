import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/reminders/domain/entities/reminder.dart';
import 'package:asheeighe/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:asheeighe/features/reminders/domain/usecases/create_reminder_usecase.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  late CreateReminderUseCase useCase;
  late MockReminderRepository mockRepository;

  setUp(() {
    mockRepository = MockReminderRepository();
    useCase = CreateReminderUseCase(mockRepository);
  });

  final scheduledAt = DateTime(2024, 6, 15, 14, 30);

  final testParams = CreateReminderParams(
    title: 'Buy groceries',
    description: 'Milk, eggs, bread',
    scheduledAt: scheduledAt,
    recurring: true,
    recurrenceRule: 'FREQ=WEEKLY',
    category: 'shopping',
    priority: 1,
    linkedEntityType: LinkedEntityType.task,
    linkedEntityId: 'task123',
  );

  group('CreateReminderUseCase', () {
    test('should call repository.createReminder with correct data', () async {
      when(() => mockRepository.createReminder(any()))
          .thenAnswer((_) async => Right(Reminder(
                id: 'new-id',
                title: testParams.title,
                scheduledAt: testParams.scheduledAt,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      final result = await useCase(testParams);

      verify(() => mockRepository.createReminder(any())).called(1);
      expect(result.isRight(), true);
    });

    test('should return created reminder with id', () async {
      when(() => mockRepository.createReminder(any()))
          .thenAnswer((_) async => Right(Reminder(
                id: 'new-id',
                title: 'Buy groceries',
                scheduledAt: scheduledAt,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      final result = await useCase(testParams);
      final reminder = (result as Right).value;
      expect(reminder.id, 'new-id');
      expect(reminder.title, 'Buy groceries');
    });

    test('should set empty string as placeholder id before creation', () async {
      when(() => mockRepository.createReminder(any()))
          .thenAnswer((_) async => Right(Reminder(
                id: 'final-id',
                title: 'Buy groceries',
                scheduledAt: scheduledAt,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      await useCase(testParams);

      final captured = verify(() => mockRepository.createReminder(captureAny()))
          .captured[0] as Reminder;
      expect(captured.id, '');
    });

    test('should return ServerFailure on error', () async {
      const failure = ServerFailure(message: 'Database error');
      when(() => mockRepository.createReminder(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);
      expect(result, equals(const Left(failure)));
    });

    test('should return ValidationFailure for invalid params', () async {
      const failure = ValidationFailure(message: 'Title required');
      when(() => mockRepository.createReminder(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);
      expect(result, equals(const Left(failure)));
    });
  });
}
