import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/calendar/domain/entities/calendar_event.dart';

void main() {
  group('Reminder', () {
    test('should create with default values', () {
      final reminder = Reminder(id: '1');
      expect(reminder.id, '1');
      expect(reminder.minutesBefore, 15);
      expect(reminder.isEnabled, true);
    });

    test('copyWith should update fields', () {
      final reminder = Reminder(id: '1', minutesBefore: 30, isEnabled: false);
      final updated = reminder.copyWith(minutesBefore: 10);
      expect(updated.minutesBefore, 10);
      expect(updated.id, '1');
      expect(updated.isEnabled, false);
    });

    test('props should contain all fields', () {
      final reminder = Reminder(id: '1', minutesBefore: 15, isEnabled: true);
      expect(reminder.props, ['1', 15, true]);
    });
  });

  group('CalendarEvent', () {
    final startTime = DateTime(2024, 6, 15, 10);
    final endTime = DateTime(2024, 6, 15, 11);
    final createdAt = DateTime(2024, 6, 14);
    final updatedAt = DateTime(2024, 6, 14);

    final baseEvent = CalendarEvent(
      id: 'evt1',
      title: 'Team Meeting',
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    test('should create with required fields and defaults', () {
      expect(baseEvent.id, 'evt1');
      expect(baseEvent.title, 'Team Meeting');
      expect(baseEvent.allDay, false);
      expect(baseEvent.recurrence, Recurrence.none);
      expect(baseEvent.calendarType, CalendarType.personal);
      expect(baseEvent.isCompleted, false);
      expect(baseEvent.reminders, isEmpty);
    });

    group('duration', () {
      test('should calculate correct duration', () {
        expect(baseEvent.duration, const Duration(hours: 1));
      });
    });

    group('isPast', () {
      test('should return true for past event', () {
        final past = baseEvent.copyWith(
          endTime: DateTime.now().subtract(const Duration(hours: 1)),
        );
        expect(past.isPast, true);
      });

      test('should return false for future event', () {
        final future = baseEvent.copyWith(
          endTime: DateTime.now().add(const Duration(hours: 1)),
        );
        expect(future.isPast, false);
      });
    });

    group('copyWith', () {
      test('should update title', () {
        final updated = baseEvent.copyWith(title: 'Updated');
        expect(updated.title, 'Updated');
        expect(updated.id, baseEvent.id);
      });

      test('should update allDay and recurrence', () {
        final updated = baseEvent.copyWith(
          allDay: true,
          recurrence: Recurrence.weekly,
        );
        expect(updated.allDay, true);
        expect(updated.recurrence, Recurrence.weekly);
      });

      test('should update isCompleted', () {
        final updated = baseEvent.copyWith(isCompleted: true);
        expect(updated.isCompleted, true);
      });
    });

    group('value equality', () {
      test('identical events should be equal', () {
        final e1 = CalendarEvent(
          id: '1',
          title: 'Test',
          startTime: startTime,
          endTime: endTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        final e2 = CalendarEvent(
          id: '1',
          title: 'Test',
          startTime: startTime,
          endTime: endTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        expect(e1, equals(e2));
      });

      test('different ids should not be equal', () {
        final e1 = CalendarEvent(
          id: '1',
          title: 'Test',
          startTime: startTime,
          endTime: endTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        final e2 = CalendarEvent(
          id: '2',
          title: 'Test',
          startTime: startTime,
          endTime: endTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        expect(e1, isNot(equals(e2)));
      });
    });

    test('props should contain all fields', () {
      final props = baseEvent.props;
      expect(props, contains('evt1'));
      expect(props, contains('Team Meeting'));
      expect(props, contains(startTime));
      expect(props, contains(endTime));
      expect(props, contains(false));
      expect(props, contains(Recurrence.none));
    });

    test('should support all CalendarType and Recurrence values', () {
      for (final r in Recurrence.values) {
        for (final ct in CalendarType.values) {
          final event = CalendarEvent(
            id: 'e',
            title: 'E',
            startTime: startTime,
            endTime: endTime,
            recurrence: r,
            calendarType: ct,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
          expect(event.recurrence, r);
          expect(event.calendarType, ct);
        }
      }
    });
  });
}
