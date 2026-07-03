import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();

  Future<Either<Failure, Task>> getTask(String id);

  Future<Either<Failure, Task>> createTask(Task task);

  Future<Either<Failure, Task>> updateTask(Task task);

  Future<Either<Failure, void>> deleteTask(String id);

  Future<Either<Failure, Task>> completeTask(String id);

  Future<Either<Failure, Task>> archiveTask(String id);

  Future<Either<Failure, List<Task>>> getTasksByStatus(TaskStatus status);

  Future<Either<Failure, List<Task>>> getTasksByPriority(TaskPriority priority);

  Future<Either<Failure, List<Task>>> getTasksByDate(DateTime date);

  Future<Either<Failure, List<Task>>> getTasksByCategory(String category);

  Future<Either<Failure, void>> reorderTasks(List<Task> tasks);
}
