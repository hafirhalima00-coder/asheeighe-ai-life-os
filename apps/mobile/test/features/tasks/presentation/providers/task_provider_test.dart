import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/tasks/domain/entities/task.dart';
import 'package:asheeighe/features/tasks/domain/repositories/task_repository.dart';
import 'package:asheeighe/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:asheeighe/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:asheeighe/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:asheeighe/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:asheeighe/features/tasks/domain/usecases/complete_task_usecase.dart';
import 'package:asheeighe/features/tasks/presentation/providers/task_provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class MockCompleteTaskUseCase extends Mock implements CompleteTaskUseCase {}

void main() {
  late TaskNotifier notifier;
  late MockGetTasksUseCase mockGetTasks;
  late MockCreateTaskUseCase mockCreateTask;
  late MockUpdateTaskUseCase mockUpdateTask;
  late MockDeleteTaskUseCase mockDeleteTask;
  late MockCompleteTaskUseCase mockCompleteTask;

  setUp(() {
    mockGetTasks = MockGetTasksUseCase();
    mockCreateTask = MockCreateTaskUseCase();
    mockUpdateTask = MockUpdateTaskUseCase();
    mockDeleteTask = MockDeleteTaskUseCase();
    mockCompleteTask = MockCompleteTaskUseCase();
  });

  final now = DateTime(2024, 6, 15);
  final testTask = Task(id: '1', title: 'Test', createdAt: now, updatedAt: now);

  group('TaskState', () {
    test('should have default values', () {
      const state = TaskState();
      expect(state.tasks, isEmpty);
      expect(state.filter, TaskFilter.all);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.isSelecting, false);
    });
  });

  group('TaskState.filteredTasks', () {
    test('should exclude archived tasks', () {
      final state = TaskState(tasks: [
        testTask,
        testTask.copyWith(id: '2', status: TaskStatus.archived),
      ]);
      expect(state.filteredTasks.length, 1);
    });
  });

  group('TaskState.categories', () {
    test('should return unique sorted categories', () {
      final state = TaskState(tasks: [
        testTask.copyWith(category: 'work'),
        testTask.copyWith(id: '2', category: 'personal'),
        testTask.copyWith(id: '3', category: 'work'),
      ]);
      expect(state.categories, ['personal', 'work']);
    });
  });

  group('TaskState.categoryCounts', () {
    test('should count tasks per category', () {
      final state = TaskState(tasks: [
        testTask.copyWith(category: 'work'),
        testTask.copyWith(id: '2', category: 'work'),
        testTask.copyWith(id: '3', category: 'personal'),
      ]);
      expect(state.categoryCounts['work'], 2);
      expect(state.categoryCounts['personal'], 1);
    });
  });

  group('TaskNotifier', () {
    test('setFilter should update filter and clear others', () {
      notifier.setFilter(TaskFilter.today);
      expect(notifier.state.filter, TaskFilter.today);
    });

    test('filterByCategory should set category filter', () {
      notifier.filterByCategory('work');
      expect(notifier.state.categoryFilter, 'work');
    });

    test('filterByPriority should set priority filter', () {
      notifier.filterByPriority(TaskPriority.high);
      expect(notifier.state.priorityFilter, TaskPriority.high);
    });

    test('clearFilters should reset all filters', () {
      notifier.setFilter(TaskFilter.today);
      notifier.filterByCategory('work');
      notifier.clearFilters();
      expect(notifier.state.filter, TaskFilter.all);
      expect(notifier.state.categoryFilter, isNull);
      expect(notifier.state.priorityFilter, isNull);
    });
  });
}
