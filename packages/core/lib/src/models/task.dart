import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, done, archived }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String userId,
    required String title,
    String? description,
    DateTime? dueDate,
    DateTime? completedAt,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default([]) List<String> tags,
    String? parentTaskId,
    String? recurrence,
    DateTime? reminderTime,
    String? category,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
