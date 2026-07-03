import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final ApiClient _apiClient;

  TaskRemoteDataSource(this._apiClient);

  Future<List<TaskModel>> getTasks() async {
    final response = await _apiClient.get(ApiConstants.tasks);
    final data = response.data as List<dynamic>;
    return data
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> getTask(String id) async {
    final response = await _apiClient.get('${ApiConstants.task}$id');
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _apiClient.post(
      ApiConstants.tasks,
      data: task.toJson(),
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient.put(
      '${ApiConstants.task}${task.id}',
      data: task.toJson(),
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteTask(String id) async {
    await _apiClient.delete('${ApiConstants.task}$id');
  }

  Future<TaskModel> completeTask(String id) async {
    final response = await _apiClient.patch(
      '${ApiConstants.taskComplete}$id/complete',
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<TaskModel>> getTasksByStatus(String status) async {
    final response = await _apiClient.get(
      ApiConstants.tasks,
      queryParameters: {'status': status},
    );
    return (response.data as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    final response = await _apiClient.get(
      ApiConstants.tasks,
      queryParameters: {'priority': priority},
    );
    return (response.data as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final response = await _apiClient.get(
      ApiConstants.tasks,
      queryParameters: {
        'due_date': date.toIso8601String(),
      },
    );
    return (response.data as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final response = await _apiClient.get(
      ApiConstants.tasks,
      queryParameters: {'category': category},
    );
    return (response.data as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> reorderTasks(List<Map<String, dynamic>> orderData) async {
    await _apiClient.put(
      '${ApiConstants.tasks}/reorder',
      data: {'tasks': orderData},
    );
  }
}
