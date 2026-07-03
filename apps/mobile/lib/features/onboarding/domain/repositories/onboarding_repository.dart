import '../entities/user_persona.dart';

abstract class OnboardingRepository {
  Future<void> saveOnboardingProgress({
    required int step,
    String? selectedPersona,
    List<String>? selectedInterests,
    List<String>? selectedGoals,
  });

  Future<int> getOnboardingProgress();

  Future<String?> getSelectedPersona();

  Future<List<String>> getSelectedInterests();

  Future<List<String>> getSelectedGoals();

  Future<void> completeOnboarding();

  Future<bool> isOnboardingCompleted();

  Future<void> saveNotificationSettings({
    required bool prayerReminders,
    required bool taskReminders,
    required bool studyReminders,
    required bool dailyInspiration,
  });

  Future<Map<String, bool>> getNotificationSettings();

  Future<void> saveConnectedApps(List<String> apps);

  Future<List<String>> getConnectedApps();
}
