import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModePreference { light, dark, system }

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // ─── Theme Mode ──────────────────────────────
  ThemeModePreference getThemeMode() {
    final value = _prefs.getString('theme_mode') ?? 'system';
    return ThemeModePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeModePreference.system,
    );
  }

  Future<void> setThemeMode(ThemeModePreference mode) async {
    await _prefs.setString('theme_mode', mode.name);
  }

  // ─── Locale ──────────────────────────────────
  String? getLocale() => _prefs.getString('locale');

  Future<void> setLocale(String locale) async {
    await _prefs.setString('locale', locale);
  }

  // ─── Notifications ──────────────────────────
  bool getNotificationsEnabled() =>
      _prefs.getBool('notifications_enabled') ?? true;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  // ─── Onboarding ─────────────────────────────
  bool isOnboardingComplete() =>
      _prefs.getBool('onboarding_complete') ?? false;

  Future<void> setOnboardingComplete(bool complete) async {
    await _prefs.setBool('onboarding_complete', complete);
  }

  // ─── Generic ────────────────────────────────
  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
