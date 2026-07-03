import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final remoteTasks = await remoteDataSource.getTasks();
      await localDataSource.cacheTasks(remoteTasks);
      return Right(remoteTasks.map((t) => t.toEntity()).toList());
    } catch (e) {
      try {
        final cachedTasks = localDataSource.getCachedTasks();
        if (cachedTasks != null && cachedTasks.isNotEmpty) {
          return Right(cachedTasks.map((t) => t.toEntity()).toList());
        }
        return Left(CacheFailure(message: 'No cached tasks available.'));
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to fetch tasks.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final remoteTask = await remoteDataSource.getTask(id);
      await localDataSource.cacheTask(remoteTask);
      return Right(remoteTask.toEntity());
    } catch (e) {
      try {
        final cachedTask = localDataSource.getCachedTask(id);
        if (cachedTask != null) {
          return Right(cachedTask.toEntity());
        }
        return Left(NotFoundFailure(message: 'Task not found.'));
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to fetch task.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final created = await remoteDataSource.createTask(model);
      await localDataSource.cacheTask(created);
      return Right(created.toEntity());
    } catch (e) {
      try {
        await localDataSource.cacheTask(TaskModel.fromEntity(task));
        return Right(task);
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to create task.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final updated = await remoteDataSource.updateTask(model);
      await localDataSource.cacheTask(updated);
      return Right(updated.toEntity());
    } catch (e) {
      try {
        await localDataSource.cacheTask(TaskModel.fromEntity(task));
        return Right(task);
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to update task.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      await localDataSource.deleteCachedTask(id);
      return const Right(null);
    } catch (e) {
      try {
        await localDataSource.deleteCachedTask(id);
        return const Right(null);
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to delete task.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Task>> completeTask(String id) async {
    try {
      final completed = await remoteDataSource.completeTask(id);
      await localDataSource.cacheTask(completed);
      return Right(completed.toEntity());
    } catch (e) {
      final taskResult = await getTask(id);
      return taskResult.fold(
        (failure) => Left(failure),
        (task) async {
          final completed = task.copyWith(
            status: TaskStatus.done,
            completedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          try {
            await localDataSource.cacheTask(TaskModel.fromEntity(completed));
            return Right(completed);
          } catch (cacheError) {
            return Right(completed);
          }
        },
      );
    }
  }

  @override
  Future<Either<Failure, Task>> archiveTask(String id) async {
    final result = await getTask(id);
    return result.fold(
      (failure) => Left(failure),
      (task) async {
        final archived = task.copyWith(
          status: TaskStatus.archived,
          updatedAt: DateTime.now(),
        );
        return updateTask(archived);
      },
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByStatus(TaskStatus status) async {
    final result = await getTasks();
    return result.fold(
      (failure) => Left(failure),
      (tasks) => Right(tasks.where((t) => t.status == status).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByPriority(
      TaskPriority priority) async {
    final result = await getTasks();
    return result.fold(
      (failure) => Left(failure),
      (tasks) => Right(tasks.where((t) => t.priority == priority).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByDate(DateTime date) async {
    final result = await getTasks();
    return result.fold(
      (failure) => Left(failure),
      (tasks) => Right(tasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.day == date.day &&
            t.dueDate!.month == date.month &&
            t.dueDate!.year == date.year;
      }).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByCategory(
      String category) async {
    final result = await getTasks();
    return result.fold(
      (failure) => Left(failure),
      (tasks) =>
          Right(tasks.where((t) => t.category == category).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> reorderTasks(List<Task> tasks) async {
    try {
      final orderData = tasks.asMap().entries.map((entry) {
        return {
          'id': entry.value.id,
          'sort_order': entry.key,
        };
      }).toList();
      await remoteDataSource.reorderTasks(orderData);
      await localDataSource.cacheTasks(
        tasks.map((t) => TaskModel.fromEntity(t)).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to reorder tasks.',
        error: e,
      ));
    }
  }
}
