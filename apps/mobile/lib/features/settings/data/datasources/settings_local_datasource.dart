import 'dart:convert';
import 'package:hive/hive.dart';

import '../models/app_settings_model.dart';

class SettingsLocalDataSource {
  final Box _hiveBox;
  static const _settingsKey = 'app_settings';

  SettingsLocalDataSource(this._hiveBox);

  Future<AppSettingsModel> getSettings() async {
    final json = _hiveBox.get(_settingsKey) as String?;
    if (json == null) return const AppSettingsModel();
    return AppSettingsModel.fromJson(
        jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettingsModel settings) async {
    await _hiveBox.put(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<void> clearSettings() async {
    await _hiveBox.delete(_settingsKey);
  }
}
