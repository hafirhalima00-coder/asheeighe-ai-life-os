import '../../../dashboard/domain/entities/dashboard_data.dart';
import 'weather_info_model.dart';

class DashboardDataModel extends DashboardData {
  const DashboardDataModel({
    required super.greeting,
    required super.date,
    super.weather,
    super.upcomingEvents,
    super.pendingTasks,
    super.activeReminders,
    super.recentNotes,
    super.focusScore,
    super.wellnessTip,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      greeting: json['greeting'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      weather: json['weather'] != null
          ? WeatherInfoModel.fromJson(json['weather'] as Map<String, dynamic>)
          : null,
      upcomingEvents: (json['upcoming_events'] as List<dynamic>?)
              ?.map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pendingTasks: (json['pending_tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      activeReminders: (json['active_reminders'] as List<dynamic>?)
              ?.map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentNotes: (json['recent_notes'] as List<dynamic>?)
              ?.map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      focusScore: json['focus_score'] as int? ?? 75,
      wellnessTip: json['wellness_tip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'date': date.toIso8601String(),
      'weather': (weather as WeatherInfoModel?)?.toJson(),
      'upcoming_events': upcomingEvents
          .map((e) => CalendarEventModel(
                id: e.id,
                title: e.title,
                startTime: e.startTime,
                endTime: e.endTime,
                location: e.location,
                description: e.description,
              ).toJson())
          .toList(),
      'pending_tasks': pendingTasks
          .map((e) => TaskModel(
                id: e.id,
                title: e.title,
                isCompleted: e.isCompleted,
                priority: e.priority,
                dueDate: e.dueDate,
                category: e.category,
              ).toJson())
          .toList(),
      'active_reminders': activeReminders
          .map((e) => ReminderModel(
                id: e.id,
                title: e.title,
                scheduledAt: e.scheduledAt,
                isActive: e.isActive,
                note: e.note,
              ).toJson())
          .toList(),
      'recent_notes': recentNotes
          .map((e) => NoteModel(
                id: e.id,
                title: e.title,
                content: e.content,
                createdAt: e.createdAt,
                tags: e.tags,
              ).toJson())
          .toList(),
      'focus_score': focusScore,
      'wellness_tip': wellnessTip,
    };
  }
}

class CalendarEventModel extends CalendarEvent {
  const CalendarEventModel({
    required super.id,
    required super.title,
    required super.startTime,
    required super.endTime,
    super.location,
    super.description,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'description': description,
    };
  }
}

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.isCompleted,
    super.priority,
    super.dueDate,
    super.category,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'medium',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'category': category,
    };
  }
}

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.id,
    required super.title,
    required super.scheduledAt,
    super.isActive,
    super.note,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scheduled_at': scheduledAt.toIso8601String(),
      'is_active': isActive,
      'note': note,
    };
  }
}

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    super.tags,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'tags': tags,
    };
  }
}
