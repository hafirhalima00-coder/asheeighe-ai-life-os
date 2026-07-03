import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../app/app_config.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(AppConfig.hiveBoxName);
  }

  String get _tasksKey => 'tasks_all';
  String _taskKey(String id) => 'task_$id';

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final json = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await _box.put(_tasksKey, json);
    for (final task in tasks) {
      await _box.put(_taskKey(task.id), jsonEncode(task.toJson()));
    }
  }

  List<TaskModel>? getCachedTasks() {
    final json = _box.get(_tasksKey);
    if (json == null) return null;
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheTask(TaskModel task) async {
    await _box.put(_taskKey(task.id), jsonEncode(task.toJson()));
  }

  TaskModel? getCachedTask(String id) {
    final json = _box.get(_taskKey(id));
    if (json == null) return null;
    return TaskModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> deleteCachedTask(String id) async {
    await _box.delete(_taskKey(id));
  }

  Future<void> clearCache() async {
    final keys = _box.keys.where((k) => k.startsWith('task_'));
    for (final key in keys) {
      await _box.delete(key);
    }
  }
}
