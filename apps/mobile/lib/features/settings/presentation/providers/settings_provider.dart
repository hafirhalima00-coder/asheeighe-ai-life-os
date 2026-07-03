import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/reset_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;
  final ResetSettingsUseCase _resetSettings;

  SettingsNotifier({
    required GetSettingsUseCase getSettings,
    required UpdateSettingsUseCase updateSettings,
    required ResetSettingsUseCase resetSettings,
  })  : _getSettings = getSettings,
        _updateSettings = updateSettings,
        _resetSettings = resetSettings,
        super(const AppSettings());

  Future<void> loadSettings() async {
    final result = await _getSettings();
    result.fold(
      (failure) => null,
      (settings) => state = settings,
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    final result = await _updateSettings(settings);
    result.fold(
      (failure) => null,
      (updated) => state = updated,
    );
  }

  Future<void> resetSettings() async {
    final result = await _resetSettings();
    result.fold(
      (failure) => null,
      (_) => state = const AppSettings(),
    );
  }

  Future<void> setThemeMode(ThemeModeType mode) async {
    await updateSettings(state.copyWith(themeMode: mode));
  }

  Future<void> toggleNotifications() async {
    await updateSettings(
      state.copyWith(
          notificationsEnabled: !state.notificationsEnabled),
    );
  }

  Future<void> setFontSize(double size) async {
    await updateSettings(state.copyWith(fontSize: size));
  }

  Future<void> setAiProvider(String? provider) async {
    await updateSettings(state.copyWith(aiProvider: provider));
  }

  Future<void> setAiApiKey(String? key) async {
    await updateSettings(state.copyWith(aiApiKey: key));
  }

  Future<void> setComposioApiKey(String? key) async {
    await updateSettings(
        state.copyWith(composioApiKey: key));
  }
}
