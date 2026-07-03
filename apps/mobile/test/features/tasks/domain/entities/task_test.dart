import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/tasks/domain/entities/task.dart';

void main() {
  group('TaskPriority', () {
    test('should have correct enum values', () {
      expect(TaskPriority.values, hasLength(4));
      expect(TaskPriority.low.index, 0);
      expect(TaskPriority.medium.index, 1);
      expect(TaskPriority.high.index, 2);
      expect(TaskPriority.urgent.index, 3);
    });
  });

  group('TaskStatus', () {
    test('should have correct enum values', () {
      expect(TaskStatus.values, hasLength(4));
      expect(TaskStatus.todo.index, 0);
      expect(TaskStatus.inProgress.index, 1);
      expect(TaskStatus.done.index, 2);
      expect(TaskStatus.archived.index, 3);
    });
  });

  group('TaskRecurrence', () {
    test('should have correct enum values', () {
      expect(TaskRecurrence.values, hasLength(5));
    });
  });

  group('Task', () {
    final now = DateTime(2024, 6, 15, 10, 0);
    final dueDate = DateTime(2024, 6, 20, 10, 0);

    final baseTask = Task(
      id: 'task1',
      title: 'Complete report',
      createdAt: now,
      updatedAt: now,
    );

    test('should create with required fields and defaults', () {
      expect(baseTask.id, 'task1');
      expect(baseTask.title, 'Complete report');
      expect(baseTask.priority, TaskPriority.medium);
      expect(baseTask.status, TaskStatus.todo);
      expect(baseTask.tags, isEmpty);
      expect(baseTask.sortOrder, 0);
      expect(baseTask.recurrence, TaskRecurrence.none);
    });

    group('isOverdue', () {
      test('should return true when past due and not done', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(task.isOverdue, true);
      });

      test('should return false when no due date', () {
        expect(baseTask.isOverdue, false);
      });

      test('should return false when completed', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
          status: TaskStatus.done,
        );
        expect(task.isOverdue, false);
      });
    });

    group('isDueSoon', () {
      test('should return true for due within 24 hours', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().add(const Duration(hours: 12)),
        );
        expect(task.isDueSoon, true);
      });

      test('should return false for due beyond 24 hours', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().add(const Duration(hours: 48)),
        );
        expect(task.isDueSoon, false);
      });

      test('should return false when overdue', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().subtract(const Duration(hours: 1)),
        );
        expect(task.isDueSoon, false);
      });
    });

    group('timeUntilDue', () {
      test('should return duration when dueDate is set', () {
        final task = baseTask.copyWith(
          dueDate: DateTime.now().add(const Duration(days: 1)),
        );
        expect(task.timeUntilDue, isNotNull);
        expect(task.timeUntilDue!.inDays, 1);
      });

      test('should return null when no dueDate', () {
        expect(baseTask.timeUntilDue, isNull);
      });
    });

    group('copyWith', () {
      test('should update title', () {
        final updated = baseTask.copyWith(title: 'Updated');
        expect(updated.title, 'Updated');
      });

      test('should update priority', () {
        final updated = baseTask.copyWith(priority: TaskPriority.high);
        expect(updated.priority, TaskPriority.high);
      });

      test('should update status', () {
        final updated = baseTask.copyWith(status: TaskStatus.done);
        expect(updated.status, TaskStatus.done);
      });

      test('should clear dueDate when clearDueDate is true', () {
        final task = baseTask.copyWith(dueDate: dueDate);
        final updated = task.copyWith(clearDueDate: true);
        expect(updated.dueDate, isNull);
      });

      test('should clear category when clearCategory is true', () {
        final task = baseTask.copyWith(category: 'work');
        final updated = task.copyWith(clearCategory: true);
        expect(updated.category, isNull);
      });

      test('should preserve unset fields', () {
        final updated = baseTask.copyWith(priority: TaskPriority.high);
        expect(updated.id, baseTask.id);
        expect(updated.title, baseTask.title);
      });
    });

    group('props', () {
      test('should contain all fields', () {
        final props = baseTask.props;
        expect(props, contains('task1'));
        expect(props, contains('Complete report'));
        expect(props, contains(TaskPriority.medium));
        expect(props, contains(TaskStatus.todo));
      });
    });

    group('value equality', () {
      test('identical tasks should be equal', () {
        final t1 = Task(id: '1', title: 'A', createdAt: now, updatedAt: now);
        final t2 = Task(id: '1', title: 'A', createdAt: now, updatedAt: now);
        expect(t1, equals(t2));
      });

      test('different ids should not be equal', () {
        final t1 = Task(id: '1', title: 'A', createdAt: now, updatedAt: now);
        final t2 = Task(id: '2', title: 'A', createdAt: now, updatedAt: now);
        expect(t1, isNot(equals(t2)));
      });
    });
  });
}
