import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/complete_task_usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';

enum TaskFilter { all, today, thisWeek, priority, completed }

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskRemoteDataSource(apiClient);
});

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl(
    remoteDataSource: ref.watch(taskRemoteDataSourceProvider),
    localDataSource: ref.watch(taskLocalDataSourceProvider),
  );
});

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
});

final createTaskUseCaseProvider = Provider<CreateTaskUseCase>((ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final completeTaskUseCaseProvider = Provider<CompleteTaskUseCase>((ref) {
  return CompleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final taskProvider = NotifierProvider<TaskNotifier, TaskState>(
  TaskNotifier.new,
);

class TaskState {
  final List<Task> tasks;
  final TaskFilter filter;
  final String? categoryFilter;
  final TaskPriority? priorityFilter;
  final bool isLoading;
  final String? error;
  final bool isSelecting;

  const TaskState({
    this.tasks = const [],
    this.filter = TaskFilter.all,
    this.categoryFilter,
    this.priorityFilter,
    this.isLoading = false,
    this.error,
    this.isSelecting = false,
  });

  TaskState copyWith({
    List<Task>? tasks,
    TaskFilter? filter,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    TaskPriority? priorityFilter,
    bool clearPriorityFilter = false,
    bool? isLoading,
    String? error,
    bool? isSelecting,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      categoryFilter: clearCategoryFilter
          ? null
          : (categoryFilter ?? this.categoryFilter),
      priorityFilter: clearPriorityFilter
          ? null
          : (priorityFilter ?? this.priorityFilter),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSelecting: isSelecting ?? this.isSelecting,
    );
  }

  List<Task> get filteredTasks {
    var result = tasks.where((t) => t.status != TaskStatus.archived).toList();

    switch (filter) {
      case TaskFilter.all:
        break;
      case TaskFilter.today:
        final now = DateTime.now();
        result = result.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.day == now.day &&
              t.dueDate!.month == now.month &&
              t.dueDate!.year == now.year;
        }).toList();
      case TaskFilter.thisWeek:
        final weekStart = DateTime.now().startOfWeek;
        final weekEnd = weekStart.add(const Duration(days: 7));
        result = result.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.isAfter(weekStart) &&
              t.dueDate!.isBefore(weekEnd);
        }).toList();
      case TaskFilter.priority:
        result = result
          ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case TaskFilter.completed:
        result = result.where((t) => t.status == TaskStatus.done).toList();
        break;
    }

    if (categoryFilter != null) {
      result = result.where((t) => t.category == categoryFilter).toList();
    }

    if (priorityFilter != null) {
      result = result.where((t) => t.priority == priorityFilter).toList();
    }

    result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return result;
  }

  List<Task> get completedToday {
    final now = DateTime.now();
    return tasks.where((t) {
      if (t.completedAt == null) return false;
      return t.completedAt!.day == now.day &&
          t.completedAt!.month == now.month &&
          t.completedAt!.year == now.year;
    }).toList();
  }

  List<Task> get overdue {
    return tasks.where((t) => t.isOverdue).toList();
  }

  List<String> get categories {
    return tasks
        .where((t) => t.category != null && t.category!.isNotEmpty)
        .map((t) => t.category!)
        .toSet()
        .toList()
      ..sort();
  }

  Map<String, int> get categoryCounts {
    final counts = <String, int>{};
    for (final t in tasks) {
      if (t.category != null && t.category!.isNotEmpty) {
        counts[t.category!] = (counts[t.category!] ?? 0) + 1;
      }
    }
    return counts;
  }
}

class TaskNotifier extends Notifier<TaskState> {
  @override
  TaskState build() {
    _loadTasks();
    return const TaskState(isLoading: true);
  }

  void _loadTasks() {
    final useCase = ref.read(getTasksUseCaseProvider);
    useCase().then((result) {
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message, isLoading: false);
        },
        (tasks) {
          state = state.copyWith(tasks: tasks, isLoading: false, error: null);
        },
      );
    });
  }

  void setFilter(TaskFilter filter) {
    state = state.copyWith(
      filter: filter,
      priorityFilter: null,
      categoryFilter: null,
      clearCategoryFilter: true,
      clearPriorityFilter: true,
    );
  }

  void filterByCategory(String category) {
    state = state.copyWith(
      categoryFilter: category,
      filter: TaskFilter.all,
      priorityFilter: null,
      clearPriorityFilter: true,
    );
  }

  void filterByPriority(TaskPriority priority) {
    state = state.copyWith(
      priorityFilter: priority,
      filter: TaskFilter.all,
      categoryFilter: null,
      clearCategoryFilter: true,
    );
  }

  void clearFilters() {
    state = state.copyWith(
      filter: TaskFilter.all,
      categoryFilter: null,
      priorityFilter: null,
      clearCategoryFilter: true,
      clearPriorityFilter: true,
    );
  }

  Future<void> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    String? category,
    List<String> tags = const [],
    TaskRecurrence recurrence = TaskRecurrence.none,
    int? estimatedMinutes,
  }) async {
    final now = DateTime.now();
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      category: category,
      tags: tags,
      recurrence: recurrence,
      estimatedMinutes: estimatedMinutes,
      sortOrder: state.tasks.length,
      createdAt: now,
      updatedAt: now,
    );
    final useCase = ref.read(createTaskUseCaseProvider);
    final result = await useCase(task);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (created) {
        state = state.copyWith(tasks: [...state.tasks, created]);
      },
    );
  }

  Future<void> updateTask(Task task) async {
    final useCase = ref.read(updateTaskUseCaseProvider);
    final result = await useCase(task);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (updated) {
        state = state.copyWith(
          tasks: state.tasks.map((t) => t.id == updated.id ? updated : t).toList(),
        );
      },
    );
  }

  Future<void> deleteTask(String id) async {
    final useCase = ref.read(deleteTaskUseCaseProvider);
    final result = await useCase(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {
        state = state.copyWith(
          tasks: state.tasks.where((t) => t.id != id).toList(),
        );
      },
    );
  }

  Future<void> completeTask(String id) async {
    final useCase = ref.read(completeTaskUseCaseProvider);
    final result = await useCase(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (completed) {
        state = state.copyWith(
          tasks: state.tasks.map((t) => t.id == completed.id ? completed : t).toList(),
        );
      },
    );
  }

  Future<void> toggleComplete(String id) async {
    final task = state.tasks.firstWhere((t) => t.id == id);
    if (task.status == TaskStatus.done) {
      final reopened = task.copyWith(
        status: TaskStatus.todo,
        completedAt: null,
        updatedAt: DateTime.now(),
      );
      await updateTask(reopened);
    } else {
      await completeTask(id);
    }
  }

  void reorderTasks(int oldIndex, int newIndex) {
    final tasks = List<Task>.from(state.tasks);
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, task);
    final reordered = tasks.asMap().entries.map((entry) {
      return entry.value.copyWith(sortOrder: entry.key);
    }).toList();
    state = state.copyWith(tasks: reordered);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    _loadTasks();
  }
}

extension _DateHelpers on DateTime {
  DateTime get startOfWeek {
    final weekDay = weekday - 1;
    return subtract(Duration(days: weekDay)).startOfDay;
  }
}
