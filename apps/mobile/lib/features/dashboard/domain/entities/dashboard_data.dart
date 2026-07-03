import 'package:equatable/equatable.dart';

import 'weather_info.dart';

class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? description;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, location, description];
}

class Task extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final String priority;
  final DateTime? dueDate;
  final String? category;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = 'medium',
    this.dueDate,
    this.category,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority,
      dueDate: dueDate,
      category: category,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, priority, dueDate, category];
}

class Reminder extends Equatable {
  final String id;
  final String title;
  final DateTime scheduledAt;
  final bool isActive;
  final String? note;

  const Reminder({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.isActive = true,
    this.note,
  });

  @override
  List<Object?> get props => [id, title, scheduledAt, isActive, note];
}

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final List<String> tags;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, tags];
}

class DashboardData extends Equatable {
  final String greeting;
  final DateTime date;
  final WeatherInfo? weather;
  final List<CalendarEvent> upcomingEvents;
  final List<Task> pendingTasks;
  final List<Reminder> activeReminders;
  final List<Note> recentNotes;
  final int focusScore;
  final String wellnessTip;

  const DashboardData({
    required this.greeting,
    required this.date,
    this.weather,
    this.upcomingEvents = const [],
    this.pendingTasks = const [],
    this.activeReminders = const [],
    this.recentNotes = const [],
    this.focusScore = 75,
    this.wellnessTip = '',
  });

  DashboardData copyWith({
    String? greeting,
    DateTime? date,
    WeatherInfo? weather,
    List<CalendarEvent>? upcomingEvents,
    List<Task>? pendingTasks,
    List<Reminder>? activeReminders,
    List<Note>? recentNotes,
    int? focusScore,
    String? wellnessTip,
  }) {
    return DashboardData(
      greeting: greeting ?? this.greeting,
      date: date ?? this.date,
      weather: weather ?? this.weather,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      activeReminders: activeReminders ?? this.activeReminders,
      recentNotes: recentNotes ?? this.recentNotes,
      focusScore: focusScore ?? this.focusScore,
      wellnessTip: wellnessTip ?? this.wellnessTip,
    );
  }

  @override
  List<Object?> get props => [
        greeting,
        date,
        weather,
        upcomingEvents,
        pendingTasks,
        activeReminders,
        recentNotes,
        focusScore,
        wellnessTip,
      ];
}
