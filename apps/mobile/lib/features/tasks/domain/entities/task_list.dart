import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final String? color;
  final List<String> taskIds;
  final bool isDefault;

  const TaskList({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.taskIds = const [],
    this.isDefault = false,
  });

  TaskList copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    List<String>? taskIds,
    bool? isDefault,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      taskIds: taskIds ?? this.taskIds,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, color, taskIds, isDefault];
}
