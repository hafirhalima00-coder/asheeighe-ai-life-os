import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final PreferencesService _prefs;

  ThemeModeNotifier(this._prefs)
      : super(_initialMode(_prefs));

  static ThemeMode _initialMode(PreferencesService prefs) {
    switch (prefs.getThemeMode()) {
      case ThemeModePreference.light:
        return ThemeMode.light;
      case ThemeModePreference.dark:
        return ThemeMode.dark;
      case ThemeModePreference.system:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final pref = switch (mode) {
      ThemeMode.light => ThemeModePreference.light,
      ThemeMode.dark => ThemeModePreference.dark,
      ThemeMode.system => ThemeModePreference.system,
    };
    await _prefs.setThemeMode(pref);
  }
}

final themeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return ThemeModeNotifier(prefs);
});

final preferencesServiceProvider =
    Provider<PreferencesService>((ref) => ref.watch(_prefsProvider));

final _prefsProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('PreferencesService must be overridden');
});
