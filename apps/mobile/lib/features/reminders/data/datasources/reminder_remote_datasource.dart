import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/reminder_model.dart';

class ReminderRemoteDataSource {
  final ApiClient _apiClient;

  ReminderRemoteDataSource(this._apiClient);

  Future<List<ReminderModel>> getReminders() async {
    final response = await _apiClient.get(ApiConstants.reminders);
    return (response.data as List)
        .map((e) =>
            ReminderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReminderModel> getReminder(String id) async {
    final response =
        await _apiClient.get('${ApiConstants.reminder}$id');
    return ReminderModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<ReminderModel> createReminder(
      ReminderModel reminder) async {
    final response = await _apiClient.post(
      ApiConstants.reminders,
      data: reminder.toJson(),
    );
    return ReminderModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<ReminderModel> updateReminder(
      ReminderModel reminder) async {
    final response = await _apiClient.put(
      '${ApiConstants.reminder}${reminder.id}',
      data: reminder.toJson(),
    );
    return ReminderModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<void> deleteReminder(String id) async {
    await _apiClient.delete('${ApiConstants.reminder}$id');
  }

  Future<List<ReminderModel>> getActiveReminders() async {
    final response = await _apiClient.get(
      ApiConstants.reminders,
      queryParameters: {'status': 'active'},
    );
    return (response.data as List)
        .map((e) =>
            ReminderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ReminderModel>> getCompletedReminders() async {
    final response = await _apiClient.get(
      ApiConstants.reminders,
      queryParameters: {'status': 'completed'},
    );
    return (response.data as List)
        .map((e) =>
            ReminderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReminderModel> snooze(
      String id, DateTime until) async {
    final response = await _apiClient.post(
      '${ApiConstants.reminder}$id/snooze',
      data: {'snoozedUntil': until.toIso8601String()},
    );
    return ReminderModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<void> dismiss(String id) async {
    await _apiClient.post(
        '${ApiConstants.reminder}$id/dismiss');
  }

  Future<ReminderModel> complete(String id) async {
    final response = await _apiClient.post(
      '${ApiConstants.reminder}$id/complete',
    );
    return ReminderModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}
