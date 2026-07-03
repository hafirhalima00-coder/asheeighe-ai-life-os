import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/calendar_local_datasource.dart';
import '../../data/datasources/calendar_remote_datasource.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/delete_event_usecase.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/update_event_usecase.dart';

enum CalendarViewMode { day, week, month }

final calendarLocalDataSourceProvider = Provider<CalendarLocalDataSource>((ref) {
  return CalendarLocalDataSource();
});

final calendarRemoteDataSourceProvider = Provider<CalendarRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CalendarRemoteDataSource(apiClient);
});

final calendarRepositoryProvider = Provider<CalendarRepositoryImpl>((ref) {
  return CalendarRepositoryImpl(
    remoteDataSource: ref.watch(calendarRemoteDataSourceProvider),
    localDataSource: ref.watch(calendarLocalDataSourceProvider),
  );
});

final getEventsUseCaseProvider = Provider<GetEventsUseCase>((ref) {
  return GetEventsUseCase(ref.watch(calendarRepositoryProvider));
});

final createEventUseCaseProvider = Provider<CreateEventUseCase>((ref) {
  return CreateEventUseCase(ref.watch(calendarRepositoryProvider));
});

final updateEventUseCaseProvider = Provider<UpdateEventUseCase>((ref) {
  return UpdateEventUseCase(ref.watch(calendarRepositoryProvider));
});

final deleteEventUseCaseProvider = Provider<DeleteEventUseCase>((ref) {
  return DeleteEventUseCase(ref.watch(calendarRepositoryProvider));
});

final calendarProvider = NotifierProvider<CalendarNotifier, CalendarState>(
  CalendarNotifier.new,
);

class CalendarState {
  final CalendarViewMode viewMode;
  final DateTime currentDate;
  final List<CalendarEvent> events;
  final bool isLoading;
  final String? error;

  const CalendarState({
    this.viewMode = CalendarViewMode.month,
    required this.currentDate,
    this.events = const [],
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    CalendarViewMode? viewMode,
    DateTime? currentDate,
    List<CalendarEvent>? events,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      viewMode: viewMode ?? this.viewMode,
      currentDate: currentDate ?? this.currentDate,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  DateTime get monthStart => DateTime(currentDate.year, currentDate.month, 1);
  DateTime get monthEnd {
    if (currentDate.month == 12) {
      return DateTime(currentDate.year + 1, 1, 0, 23, 59, 59, 999);
    }
    return DateTime(currentDate.year, currentDate.month + 1, 0, 23, 59, 59, 999);
  }

  DateTime get weekStart => currentDate.subtract(Duration(days: currentDate.weekday - 1));
  DateTime get weekEnd => weekStart.add(const Duration(days: 7));

  List<CalendarDay> get monthDays {
    final first = monthStart;
    final last = monthEnd;
    final startWeekday = first.weekday % 7;
    final totalDays = last.day;
    final today = DateTime.now();
    final days = <CalendarDay>[];

    for (int i = 0; i < startWeekday; i++) {
      final prevDate = first.subtract(Duration(days: startWeekday - i));
      days.add(CalendarDay(
        date: prevDate,
        events: events.where((e) =>
            e.startTime.day == prevDate.day &&
            e.startTime.month == prevDate.month &&
            e.startTime.year == prevDate.year).toList(),
        isToday: prevDate.day == today.day &&
            prevDate.month == today.month &&
            prevDate.year == today.year,
        isCurrentMonth: false,
      ));
    }

    for (int d = 1; d <= totalDays; d++) {
      final date = DateTime(first.year, first.month, d);
      days.add(CalendarDay(
        date: date,
        events: events.where((e) =>
            e.startTime.day == d &&
            e.startTime.month == first.month &&
            e.startTime.year == first.year).toList(),
        isToday: date.day == today.day &&
            date.month == today.month &&
            date.year == today.year,
        isCurrentMonth: true,
      ));
    }

    final remaining = 42 - days.length;
    for (int i = 1; i <= remaining; i++) {
      final nextDate = last.add(Duration(days: i));
      days.add(CalendarDay(
        date: nextDate,
        events: events.where((e) =>
            e.startTime.day == nextDate.day &&
            e.startTime.month == nextDate.month &&
            e.startTime.year == nextDate.year).toList(),
        isToday: nextDate.day == today.day &&
            nextDate.month == today.month &&
            nextDate.year == today.year,
        isCurrentMonth: false,
      ));
    }

    return days;
  }

  List<CalendarDay> get weekDays {
    final today = DateTime.now();
    return List.generate(7, (i) {
      final date = weekStart.add(Duration(days: i));
      return CalendarDay(
        date: date,
        events: events.where((e) =>
            e.startTime.day == date.day &&
            e.startTime.month == date.month &&
            e.startTime.year == date.year).toList(),
        isToday: date.day == today.day &&
            date.month == today.month &&
            date.year == today.year,
        isCurrentMonth: date.month == currentDate.month,
      );
    });
  }

  List<CalendarEvent> get dayEvents {
    return events.where((e) =>
        e.startTime.day == currentDate.day &&
        e.startTime.month == currentDate.month &&
        e.startTime.year == currentDate.year).toList();
  }
}

class CalendarNotifier extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final now = DateTime.now();
    final state = CalendarState(currentDate: now);
    _loadEvents(state.monthStart, state.monthEnd);
    return state;
  }

  void _loadEvents(DateTime start, DateTime end) {
    final useCase = ref.read(getEventsUseCaseProvider);
    useCase(startDate: start, endDate: end).then((result) {
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message, isLoading: false);
        },
        (events) {
          state = state.copyWith(events: events, isLoading: false, error: null);
        },
      );
    });
  }

  void setViewMode(CalendarViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void goToNext() {
    switch (state.viewMode) {
      case CalendarViewMode.day:
        _goToDate(state.currentDate.add(const Duration(days: 1)));
      case CalendarViewMode.week:
        _goToDate(state.currentDate.add(const Duration(days: 7)));
      case CalendarViewMode.month:
        _goToDate(DateTime(state.currentDate.year, state.currentDate.month + 1, 1));
    }
  }

  void goToPrevious() {
    switch (state.viewMode) {
      case CalendarViewMode.day:
        _goToDate(state.currentDate.subtract(const Duration(days: 1)));
      case CalendarViewMode.week:
        _goToDate(state.currentDate.subtract(const Duration(days: 7)));
      case CalendarViewMode.month:
        _goToDate(DateTime(state.currentDate.year, state.currentDate.month - 1, 1));
    }
  }

  void goToToday() {
    final now = DateTime.now();
    _goToDate(now);
  }

  void goToDate(DateTime date) {
    _goToDate(date);
  }

  void _goToDate(DateTime date) {
    state = state.copyWith(currentDate: date, isLoading: true);
    final start = state.viewMode == CalendarViewMode.month
        ? state.monthStart
        : state.viewMode == CalendarViewMode.week
            ? state.weekStart
            : date.startOfDay;
    final end = state.viewMode == CalendarViewMode.month
        ? state.monthEnd
        : state.viewMode == CalendarViewMode.week
            ? state.weekEnd
            : date.endOfDay;
    _loadEvents(start, end);
  }

  Future<void> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    bool allDay = false,
    Recurrence recurrence = Recurrence.none,
    String? color,
    String? location,
    String? url,
    String? notes,
    List<Reminder> reminders = const [],
    CalendarType calendarType = CalendarType.personal,
  }) async {
    final now = DateTime.now();
    final event = CalendarEvent(
      id: const Uuid().v4(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      allDay: allDay,
      recurrence: recurrence,
      color: color,
      location: location,
      url: url,
      notes: notes,
      reminders: reminders,
      calendarType: calendarType,
      createdAt: now,
      updatedAt: now,
    );
    final useCase = ref.read(createEventUseCaseProvider);
    final result = await useCase(event);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (created) {
        state = state.copyWith(
          events: [...state.events, created],
        );
      },
    );
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final useCase = ref.read(updateEventUseCaseProvider);
    final result = await useCase(event);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (updated) {
        state = state.copyWith(
          events: state.events.map((e) => e.id == updated.id ? updated : e).toList(),
        );
      },
    );
  }

  Future<void> deleteEvent(String id) async {
    final useCase = ref.read(deleteEventUseCaseProvider);
    final result = await useCase(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {
        state = state.copyWith(
          events: state.events.where((e) => e.id != id).toList(),
        );
      },
    );
  }

  Future<void> toggleComplete(String id) async {
    final event = state.events.firstWhere((e) => e.id == id);
    await updateEvent(event.copyWith(
      isCompleted: !event.isCompleted,
      updatedAt: DateTime.now(),
    ));
  }
}

const Map<CalendarType, Color> calendarTypeColors = {
  CalendarType.personal: Color(0xFFA78BFA),
  CalendarType.work: Color(0xFF60A5FA),
  CalendarType.study: Color(0xFF34D399),
  CalendarType.health: Color(0xFFF472B6),
};

const Map<CalendarType, String> calendarTypeLabels = {
  CalendarType.personal: 'Personal',
  CalendarType.work: 'Work',
  CalendarType.study: 'Study',
  CalendarType.health: 'Health',
};
