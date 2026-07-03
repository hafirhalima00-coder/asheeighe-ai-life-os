import 'task_model.dart';

class TaskListModel {
  final String id;
  final String name;
  final String? icon;
  final String? color;
  final List<String> taskIds;
  final bool isDefault;

  const TaskListModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.taskIds = const [],
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'task_ids': taskIds,
      'is_default': isDefault,
    };
  }

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      taskIds: (json['task_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'task_ids': taskIds.join(','),
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory TaskListModel.fromDatabase(Map<String, dynamic> map) {
    return TaskListModel(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      taskIds: (map['task_ids'] as String?)?.isNotEmpty == true
          ? (map['task_ids'] as String).split(',')
          : [],
      isDefault: (map['is_default'] as int?) == 1,
    );
  }
}
