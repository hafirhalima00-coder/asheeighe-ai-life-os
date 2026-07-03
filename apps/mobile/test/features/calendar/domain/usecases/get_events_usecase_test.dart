import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/calendar/domain/entities/calendar_event.dart';
import 'package:asheeighe/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:asheeighe/features/calendar/domain/usecases/get_events_usecase.dart';

class MockCalendarRepository extends Mock implements CalendarRepository {}

void main() {
  late GetEventsUseCase useCase;
  late MockCalendarRepository mockRepository;

  setUp(() {
    mockRepository = MockCalendarRepository();
    useCase = GetEventsUseCase(mockRepository);
  });

  final startDate = DateTime(2024, 6, 1);
  final endDate = DateTime(2024, 6, 30);
  final createdAt = DateTime(2024, 6, 1);
  final updatedAt = DateTime(2024, 6, 1);

  final testEvents = [
    CalendarEvent(
      id: '1',
      title: 'Event 1',
      startTime: DateTime(2024, 6, 15, 10),
      endTime: DateTime(2024, 6, 15, 11),
      createdAt: createdAt,
      updatedAt: updatedAt,
    ),
    CalendarEvent(
      id: '2',
      title: 'Event 2',
      startTime: DateTime(2024, 6, 20, 14),
      endTime: DateTime(2024, 6, 20, 15),
      createdAt: createdAt,
      updatedAt: updatedAt,
    ),
  ];

  group('GetEventsUseCase', () {
    test('should call repository.getEvents with correct dates', () async {
      when(() => mockRepository.getEvents(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => Right(testEvents));

      final result = await useCase(startDate: startDate, endDate: endDate);

      verify(() => mockRepository.getEvents(
            startDate: startDate,
            endDate: endDate,
          )).called(1);
      expect(result, equals(Right(testEvents)));
    });

    test('should return empty list when no events', () async {
      when(() => mockRepository.getEvents(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => const Right([]));

      final result = await useCase(startDate: startDate, endDate: endDate);
      expect(result, equals(const Right([])));
    });

    test('should return ServerFailure on error', () async {
      const failure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getEvents(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(startDate: startDate, endDate: endDate);
      expect(result, equals(const Left(failure)));
    });
  });
}
