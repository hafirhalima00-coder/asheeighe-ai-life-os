import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

final sharedPreferencesProvider =
    Provider<PreferencesService>((ref) => ref.watch(_prefsProvider));

final _prefsProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('PreferencesService must be overridden');
});

final themeModePreferenceProvider = Provider<ThemeModePreference>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getThemeMode();
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getNotificationsEnabled();
});

final onboardingCompleteProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.isOnboardingComplete();
});
