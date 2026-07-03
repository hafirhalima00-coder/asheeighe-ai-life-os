import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/reminders/domain/entities/reminder.dart';

void main() {
  group('LinkedEntityType', () {
    test('should have correct enum values', () {
      expect(LinkedEntityType.values, hasLength(4));
      expect(LinkedEntityType.task.index, 0);
      expect(LinkedEntityType.event.index, 1);
      expect(LinkedEntityType.note.index, 2);
      expect(LinkedEntityType.general.index, 3);
    });
  });

  group('Reminder', () {
    final scheduledAt = DateTime(2024, 6, 15, 14, 30);
    final createdAt = DateTime(2024, 6, 14, 10, 0);
    final updatedAt = DateTime(2024, 6, 14, 10, 0);
    final now = DateTime.now();

    final baseReminder = Reminder(
      id: 'rem1',
      title: 'Team standup',
      scheduledAt: scheduledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    test('should create with required fields and defaults', () {
      expect(baseReminder.id, 'rem1');
      expect(baseReminder.title, 'Team standup');
      expect(baseReminder.description, isNull);
      expect(baseReminder.recurring, false);
      expect(baseReminder.enabled, true);
      expect(baseReminder.priority, 0);
      expect(baseReminder.category, isNull);
      expect(baseReminder.linkedEntityType, isNull);
    });

    group('isCompleted', () {
      test('should return true when completedAt is set', () {
        final reminder = baseReminder.copyWith(completedAt: now);
        expect(reminder.isCompleted, true);
      });

      test('should return false when completedAt is null', () {
        expect(baseReminder.isCompleted, false);
      });
    });

    group('isSnoozed', () {
      test('should return true when snoozedUntil is in the future', () {
        final reminder = baseReminder.copyWith(
          snoozedUntil: now.add(const Duration(hours: 1)),
        );
        expect(reminder.isSnoozed, true);
      });

      test('should return false when snoozedUntil is null', () {
        expect(baseReminder.isSnoozed, false);
      });

      test('should return false when snoozedUntil is in the past', () {
        final reminder = baseReminder.copyWith(
          snoozedUntil: now.subtract(const Duration(hours: 1)),
        );
        expect(reminder.isSnoozed, false);
      });
    });

    group('copyWith', () {
      test('should update title', () {
        final updated = baseReminder.copyWith(title: 'Updated');
        expect(updated.title, 'Updated');
      });

      test('should update description', () {
        final updated = baseReminder.copyWith(description: 'New desc');
        expect(updated.description, 'New desc');
      });

      test('should update scheduledAt', () {
        final newTime = scheduledAt.add(const Duration(hours: 2));
        final updated = baseReminder.copyWith(scheduledAt: newTime);
        expect(updated.scheduledAt, newTime);
      });

      test('should enable recurring', () {
        final updated = baseReminder.copyWith(
          recurring: true,
          recurrenceRule: 'FREQ=DAILY',
        );
        expect(updated.recurring, true);
        expect(updated.recurrenceRule, 'FREQ=DAILY');
      });

      test('should update linked entity', () {
        final updated = baseReminder.copyWith(
          linkedEntityType: LinkedEntityType.task,
          linkedEntityId: 'task123',
        );
        expect(updated.linkedEntityType, LinkedEntityType.task);
        expect(updated.linkedEntityId, 'task123');
      });

      test('should update priority', () {
        final updated = baseReminder.copyWith(priority: 3);
        expect(updated.priority, 3);
      });

      test('should preserve unset fields', () {
        final updated = baseReminder.copyWith(priority: 1);
        expect(updated.id, baseReminder.id);
        expect(updated.title, baseReminder.title);
        expect(updated.scheduledAt, baseReminder.scheduledAt);
      });
    });

    test('equals should use referential identity', () {
      expect(baseReminder == baseReminder, true);
    });
  });
}
