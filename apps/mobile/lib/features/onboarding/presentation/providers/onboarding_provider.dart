import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../domain/entities/user_persona.dart';
import '../../domain/repositories/onboarding_repository.dart';

// Repository Provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError('OnboardingRepository must be provided');
});

// Onboarding State
class OnboardingState {
  final int currentStep;
  final UserPersona? selectedPersona;
  final List<String> selectedInterests;
  final List<String> selectedGoals;
  final Map<String, bool> notificationSettings;
  final List<String> connectedApps;
  final bool isCompleted;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentStep = 0,
    this.selectedPersona,
    this.selectedInterests = const [],
    this.selectedGoals = const [],
    this.notificationSettings = const {
      'prayer_reminders': true,
      'task_reminders': true,
      'study_reminders': true,
      'daily_inspiration': true,
    },
    this.connectedApps = const [],
    this.isCompleted = false,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentStep,
    UserPersona? selectedPersona,
    List<String>? selectedInterests,
    List<String>? selectedGoals,
    Map<String, bool>? notificationSettings,
    List<String>? connectedApps,
    bool? isCompleted,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedPersona: selectedPersona ?? this.selectedPersona,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      connectedApps: connectedApps ?? this.connectedApps,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get canProceed {
    final step = onboardingSteps[currentStep];
    switch (step.type) {
      case OnboardingStepType.persona:
        return selectedPersona != null;
      case OnboardingStepType.interests:
        return selectedInterests.length >= 3;
      case OnboardingStepType.goals:
        return selectedGoals.isNotEmpty;
      default:
        return true;
    }
  }

  double get progress => (currentStep + 1) / onboardingSteps.length;
}

// Onboarding Notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository) : super(const OnboardingState()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    state = state.copyWith(isLoading: true);

    try {
      final isCompleted = await _repository.isOnboardingCompleted();
      if (isCompleted) {
        state = state.copyWith(isCompleted: true, isLoading: false);
        return;
      }

      final step = await _repository.getOnboardingProgress();
      final persona = await _repository.getSelectedPersona();
      final interests = await _repository.getSelectedInterests();
      final goals = await _repository.getSelectedGoals();
      final notifications = await _repository.getNotificationSettings();
      final apps = await _repository.getConnectedApps();

      state = state.copyWith(
        currentStep: step,
        selectedPersona: persona != null
            ? userPersonas.firstWhere(
                (p) => p.id == persona,
                orElse: () => userPersonas.first,
              )
            : null,
        selectedInterests: interests,
        selectedGoals: goals,
        notificationSettings: notifications,
        connectedApps: apps,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> nextStep() async {
    if (state.currentStep < onboardingSteps.length - 1) {
      final nextStepValue = state.currentStep + 1;
      state = state.copyWith(currentStep: nextStepValue);

      await _repository.saveOnboardingProgress(
        step: nextStepValue,
        selectedPersona: state.selectedPersona?.id,
        selectedInterests: state.selectedInterests,
        selectedGoals: state.selectedGoals,
      );
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 0) {
      final prevStep = state.currentStep - 1;
      state = state.copyWith(currentStep: prevStep);

      await _repository.saveOnboardingProgress(
        step: prevStep,
        selectedPersona: state.selectedPersona?.id,
        selectedInterests: state.selectedInterests,
        selectedGoals: state.selectedGoals,
      );
    }
  }

  Future<void> goToStep(int step) async {
    if (step >= 0 && step < onboardingSteps.length) {
      state = state.copyWith(currentStep: step);

      await _repository.saveOnboardingProgress(
        step: step,
        selectedPersona: state.selectedPersona?.id,
        selectedInterests: state.selectedInterests,
        selectedGoals: state.selectedGoals,
      );
    }
  }

  void selectPersona(UserPersona persona) {
    state = state.copyWith(selectedPersona: persona);
  }

  void toggleInterest(String interest) {
    final interests = List<String>.from(state.selectedInterests);
    if (interests.contains(interest)) {
      interests.remove(interest);
    } else {
      interests.add(interest);
    }
    state = state.copyWith(selectedInterests: interests);
  }

  void toggleGoal(String goal) {
    final goals = List<String>.from(state.selectedGoals);
    if (goals.contains(goal)) {
      goals.remove(goal);
    } else {
      goals.add(goal);
    }
    state = state.copyWith(selectedGoals: goals);
  }

  void toggleNotification(String key, bool value) {
    final settings = Map<String, bool>.from(state.notificationSettings);
    settings[key] = value;
    state = state.copyWith(notificationSettings: settings);
  }

  void toggleConnectedApp(String app) {
    final apps = List<String>.from(state.connectedApps);
    if (apps.contains(app)) {
      apps.remove(app);
    } else {
      apps.add(app);
    }
    state = state.copyWith(connectedApps: apps);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.saveOnboardingProgress(
        step: state.currentStep,
        selectedPersona: state.selectedPersona?.id,
        selectedInterests: state.selectedInterests,
        selectedGoals: state.selectedGoals,
      );

      await _repository.saveNotificationSettings(
        prayerReminders: state.notificationSettings['prayer_reminders'] ?? true,
        taskReminders: state.notificationSettings['task_reminders'] ?? true,
        studyReminders: state.notificationSettings['study_reminders'] ?? true,
        dailyInspiration: state.notificationSettings['daily_inspiration'] ?? true,
      );

      await _repository.saveConnectedApps(state.connectedApps);

      await _repository.completeOnboarding();

      state = state.copyWith(isCompleted: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> skipOnboarding() async {
    await _repository.completeOnboarding();
    state = state.copyWith(isCompleted: true);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref.watch(onboardingRepositoryProvider));
});

// Available Interests
const List<Map<String, String>> availableInterests = [
  {'id': 'productivity', 'name': 'Productivity', 'icon': '⚡'},
  {'id': 'study', 'name': 'Study', 'icon': '📚'},
  {'id': 'wellness', 'name': 'Wellness', 'icon': '🧘'},
  {'id': 'islamic', 'name': 'Islamic', 'icon': '🕌'},
  {'id': 'business', 'name': 'Business', 'icon': '💼'},
  {'id': 'coding', 'name': 'Coding', 'icon': '💻'},
  {'id': 'finance', 'name': 'Finance', 'icon': '💰'},
  {'id': 'travel', 'name': 'Travel', 'icon': '✈️'},
];

// Available Goals (organized by interest)
const Map<String, List<Map<String, String>>> goalsByInterest = {
  'productivity': [
    {'id': 'organize_tasks', 'name': 'Organize my daily tasks'},
    {'id': 'build_habits', 'name': 'Build better habits'},
    {'id': 'time_management', 'name': 'Improve time management'},
    {'id': 'goal_setting', 'name': 'Set and achieve goals'},
  ],
  'study': [
    {'id': 'study_schedule', 'name': 'Organize my study schedule'},
    {'id': 'exam_prep', 'name': 'Prepare for exams effectively'},
    {'id': 'note_taking', 'name': 'Take better notes'},
    {'id': 'learning_plan', 'name': 'Create a learning plan'},
  ],
  'wellness': [
    {'id': 'self_care', 'name': 'Practice self-care'},
    {'id': 'mental_health', 'name': 'Improve mental health'},
    {'id': 'fitness', 'name': 'Stay fit and active'},
    {'id': 'sleep', 'name': 'Get better sleep'},
  ],
  'islamic': [
    {'id': 'prayer_tracking', 'name': 'Track my prayers'},
    {'id': 'quran_reading', 'name': 'Read Quran regularly'},
    {'id': 'dhikr', 'name': 'Maintain daily dhikr'},
    {'id': 'ramadan_prep', 'name': 'Prepare for Ramadan'},
  ],
  'business': [
    {'id': 'client_management', 'name': 'Manage my clients'},
    {'id': 'invoice_tracking', 'name': 'Track invoices'},
    {'id': 'business_growth', 'name': 'Grow my business'},
    {'id': 'networking', 'name': 'Build my network'},
  ],
  'coding': [
    {'id': 'learn_coding', 'name': 'Learn to code'},
    {'id': 'project_tracking', 'name': 'Track coding projects'},
    {'id': 'skill_development', 'name': 'Develop coding skills'},
    {'id': 'portfolio', 'name': 'Build my portfolio'},
  ],
  'finance': [
    {'id': 'budget_tracking', 'name': 'Track my budget'},
    {'id': 'savings_goals', 'name': 'Set savings goals'},
    {'id': 'expense_management', 'name': 'Manage expenses'},
    {'id': 'investment', 'name': 'Start investing'},
  ],
  'travel': [
    {'id': 'trip_planning', 'name': 'Plan my trips'},
    {'id': 'travel_journal', 'name': 'Keep a travel journal'},
    {'id': 'budget_travel', 'name': 'Travel on a budget'},
    {'id': 'bucket_list', 'name': 'Create a bucket list'},
  ],
};

// Available Connected Apps
const List<Map<String, String>> availableApps = [
  {'id': 'google_calendar', 'name': 'Google Calendar', 'icon': '📅'},
  {'id': 'gmail', 'name': 'Gmail', 'icon': '📧'},
  {'id': 'notion', 'name': 'Notion', 'icon': '📝'},
  {'id': 'todoist', 'name': 'Todoist', 'icon': '✅'},
  {'id': 'spotify', 'name': 'Spotify', 'icon': '🎵'},
  {'id': 'strava', 'name': 'Strava', 'icon': '🏃'},
  {'id': 'apple_health', 'name': 'Apple Health', 'icon': '❤️'},
  {'id': 'google_fit', 'name': 'Google Fit', 'icon': '💪'},
];
