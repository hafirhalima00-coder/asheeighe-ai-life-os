import 'package:uuid/uuid.dart';

import '../../domain/entities/calendar_event.dart';

class CalendarEventModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool allDay;
  final String recurrence;
  final String? color;
  final String? location;
  final String? url;
  final String? notes;
  final List<Map<String, dynamic>> reminders;
  final String calendarType;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.allDay = false,
    this.recurrence = 'none',
    this.color,
    this.location,
    this.url,
    this.notes,
    this.reminders = const [],
    this.calendarType = 'personal',
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalendarEventModel.fromEntity(CalendarEvent event) {
    return CalendarEventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      allDay: event.allDay,
      recurrence: event.recurrence.name,
      color: event.color,
      location: event.location,
      url: event.url,
      notes: event.notes,
      reminders: event.reminders
          .map((r) => {
                'id': r.id,
                'minutesBefore': r.minutesBefore,
                'isEnabled': r.isEnabled,
              })
          .toList(),
      calendarType: event.calendarType.name,
      isCompleted: event.isCompleted,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
    );
  }

  CalendarEvent toEntity() {
    return CalendarEvent(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      allDay: allDay,
      recurrence: Recurrence.values.firstWhere(
        (e) => e.name == recurrence,
        orElse: () => Recurrence.none,
      ),
      color: color,
      location: location,
      url: url,
      notes: notes,
      reminders: reminders
          .map((r) => Reminder(
                id: r['id'] as String? ?? const Uuid().v4(),
                minutesBefore: r['minutesBefore'] as int? ?? 15,
                isEnabled: r['isEnabled'] as bool? ?? true,
              ))
          .toList(),
      calendarType: CalendarType.values.firstWhere(
        (e) => e.name == calendarType,
        orElse: () => CalendarType.personal,
      ),
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'all_day': allDay,
      'recurrence': recurrence,
      'color': color,
      'location': location,
      'url': url,
      'notes': notes,
      'reminders': reminders,
      'calendar_type': calendarType,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      allDay: json['all_day'] as bool? ?? false,
      recurrence: json['recurrence'] as String? ?? 'none',
      color: json['color'] as String?,
      location: json['location'] as String?,
      url: json['url'] as String?,
      notes: json['notes'] as String?,
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      calendarType: json['calendar_type'] as String? ?? 'personal',
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
