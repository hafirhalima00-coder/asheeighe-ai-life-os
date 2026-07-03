import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/usecases/complete_reminder_usecase.dart';
import '../../domain/usecases/create_reminder_usecase.dart';
import '../../domain/usecases/delete_reminder_usecase.dart';
import '../../domain/usecases/get_reminders_usecase.dart';
import '../../domain/usecases/snooze_reminder_usecase.dart';
import '../../domain/usecases/update_reminder_usecase.dart';

class ReminderNotifier extends StateNotifier<ReminderState> {
  final GetRemindersUseCase _getReminders;
  final CreateReminderUseCase _createReminder;
  final UpdateReminderUseCase _updateReminder;
  final DeleteReminderUseCase _deleteReminder;
  final SnoozeReminderUseCase _snoozeReminder;
  final CompleteReminderUseCase _completeReminder;

  ReminderNotifier({
    required GetRemindersUseCase getReminders,
    required CreateReminderUseCase createReminder,
    required UpdateReminderUseCase updateReminder,
    required DeleteReminderUseCase deleteReminder,
    required SnoozeReminderUseCase snoozeReminder,
    required CompleteReminderUseCase completeReminder,
  })  : _getReminders = getReminders,
        _createReminder = createReminder,
        _updateReminder = updateReminder,
        _deleteReminder = deleteReminder,
        _snoozeReminder = snoozeReminder,
        _completeReminder = completeReminder,
        super(ReminderState());

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true);
    final result = await _getReminders();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (reminders) {
        final now = DateTime.now();
        state = state.copyWith(
          isLoading: false,
          activeReminders: reminders
              .where((r) => !r.isCompleted && r.enabled)
              .toList(),
          completedReminders: reminders
              .where((r) => r.isCompleted)
              .toList(),
          allReminders: reminders,
        );
      },
    );
  }

  Future<void> createReminder(CreateReminderParams params) async {
    final result = await _createReminder(params);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadReminders(),
    );
  }

  Future<void> updateReminder(Reminder reminder) async {
    final result = await _updateReminder(reminder);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadReminders(),
    );
  }

  Future<void> deleteReminder(String id) async {
    final result = await _deleteReminder(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadReminders(),
    );
  }

  Future<void> snoozeReminder(String id, DateTime until) async {
    final result = await _snoozeReminder(SnoozeReminderParams(id: id, until: until));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadReminders(),
    );
  }

  Future<void> completeReminder(String id) async {
    final result = await _completeReminder(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadReminders(),
    );
  }

  void setActiveTab() =>
      state = state.copyWith(selectedTab: 0);
  void setCompletedTab() =>
      state = state.copyWith(selectedTab: 1);

  void clearError() => state = state.copyWith(error: null);
}

class ReminderState {
  final bool isLoading;
  final String? error;
  final int selectedTab;
  final List<Reminder> activeReminders;
  final List<Reminder> completedReminders;
  final List<Reminder> allReminders;

  const ReminderState({
    this.isLoading = false,
    this.error,
    this.selectedTab = 0,
    this.activeReminders = const [],
    this.completedReminders = const [],
    this.allReminders = const [],
  });

  ReminderState copyWith({
    bool? isLoading,
    String? error,
    int? selectedTab,
    List<Reminder>? activeReminders,
    List<Reminder>? completedReminders,
    List<Reminder>? allReminders,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTab: selectedTab ?? this.selectedTab,
      activeReminders: activeReminders ?? this.activeReminders,
      completedReminders:
          completedReminders ?? this.completedReminders,
      allReminders: allReminders ?? this.allReminders,
    );
  }
}
