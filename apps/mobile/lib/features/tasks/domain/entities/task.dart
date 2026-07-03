import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, done, archived }

enum TaskRecurrence { none, daily, weekly, monthly, yearly }

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final TaskPriority priority;
  final TaskStatus status;
  final String? category;
  final List<String> tags;
  final String? parentTaskId;
  final TaskRecurrence recurrence;
  final DateTime? reminderTime;
  final int? estimatedMinutes;
  final int? actualMinutes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.completedAt,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.category,
    this.tags = const [],
    this.parentTaskId,
    this.recurrence = TaskRecurrence.none,
    this.reminderTime,
    this.estimatedMinutes,
    this.actualMinutes,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? completedAt,
    TaskPriority? priority,
    TaskStatus? status,
    String? category,
    bool clearCategory = false,
    List<String>? tags,
    String? parentTaskId,
    bool clearParentTaskId = false,
    TaskRecurrence? recurrence,
    DateTime? reminderTime,
    bool clearReminderTime = false,
    int? estimatedMinutes,
    int? actualMinutes,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: clearCategory ? null : (category ?? this.category),
      tags: tags ?? this.tags,
      parentTaskId: clearParentTaskId ? null : (parentTaskId ?? this.parentTaskId),
      recurrence: recurrence ?? this.recurrence,
      reminderTime: clearReminderTime ? null : (reminderTime ?? this.reminderTime),
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.done) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  bool get isDueSoon {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now().add(const Duration(hours: 24))) &&
        !isOverdue;
  }

  Duration? get timeUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now());
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        completedAt,
        priority,
        status,
        category,
        tags,
        parentTaskId,
        recurrence,
        reminderTime,
        estimatedMinutes,
        actualMinutes,
        sortOrder,
        createdAt,
        updatedAt,
      ];
}
