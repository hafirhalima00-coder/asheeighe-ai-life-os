import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String? dueDate;
  final String? completedAt;
  final String priority;
  final String status;
  final String? category;
  final List<String> tags;
  final String? parentTaskId;
  final String recurrence;
  final String? reminderTime;
  final int? estimatedMinutes;
  final int? actualMinutes;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.completedAt,
    this.priority = 'medium',
    this.status = 'todo',
    this.category,
    this.tags = const [],
    this.parentTaskId,
    this.recurrence = 'none',
    this.reminderTime,
    this.estimatedMinutes,
    this.actualMinutes,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate?.toIso8601String(),
      completedAt: task.completedAt?.toIso8601String(),
      priority: task.priority.name,
      status: task.status.name,
      category: task.category,
      tags: task.tags,
      parentTaskId: task.parentTaskId,
      recurrence: task.recurrence.name,
      reminderTime: task.reminderTime?.toIso8601String(),
      estimatedMinutes: task.estimatedMinutes,
      actualMinutes: task.actualMinutes,
      sortOrder: task.sortOrder,
      createdAt: task.createdAt.toIso8601String(),
      updatedAt: task.updatedAt.toIso8601String(),
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate != null ? DateTime.parse(dueDate!) : null,
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == priority,
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => TaskStatus.todo,
      ),
      category: category,
      tags: tags,
      parentTaskId: parentTaskId,
      recurrence: TaskRecurrence.values.firstWhere(
        (e) => e.name == recurrence,
        orElse: () => TaskRecurrence.none,
      ),
      reminderTime: reminderTime != null ? DateTime.parse(reminderTime!) : null,
      estimatedMinutes: estimatedMinutes,
      actualMinutes: actualMinutes,
      sortOrder: sortOrder,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'completed_at': completedAt,
      'priority': priority,
      'status': status,
      'category': category,
      'tags': tags,
      'parent_task_id': parentTaskId,
      'recurrence': recurrence,
      'reminder_time': reminderTime,
      'estimated_minutes': estimatedMinutes,
      'actual_minutes': actualMinutes,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] as String?,
      completedAt: json['completed_at'] as String?,
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'todo',
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      parentTaskId: json['parent_task_id'] as String?,
      recurrence: json['recurrence'] as String? ?? 'none',
      reminderTime: json['reminder_time'] as String?,
      estimatedMinutes: json['estimated_minutes'] as int?,
      actualMinutes: json['actual_minutes'] as int?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
