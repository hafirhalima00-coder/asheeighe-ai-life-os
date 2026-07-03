import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/reminder_model.dart';

class ReminderLocalDataSource {
  final Box _hiveBox;
  static const _remindersKey = 'cached_reminders';

  ReminderLocalDataSource(this._hiveBox);

  Future<List<ReminderModel>> getReminders() async {
    final json = _hiveBox.get(_remindersKey) as String?;
    if (json == null) return [];
    final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((e) =>
            ReminderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheReminders(
      List<ReminderModel> reminders) async {
    final json = jsonEncode(
        reminders.map((e) => e.toJson()).toList());
    await _hiveBox.put(_remindersKey, json);
  }

  Future<void> clearCache() async {
    await _hiveBox.delete(_remindersKey);
  }
}
