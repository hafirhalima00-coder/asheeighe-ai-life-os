import 'package:equatable/equatable.dart';

enum Recurrence { none, daily, weekly, monthly, yearly }

enum CalendarType { personal, work, study, health }

class Reminder extends Equatable {
  final String id;
  final int minutesBefore;
  final bool isEnabled;

  const Reminder({
    required this.id,
    this.minutesBefore = 15,
    this.isEnabled = true,
  });

  Reminder copyWith({String? id, int? minutesBefore, bool? isEnabled}) {
    return Reminder(
      id: id ?? this.id,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [id, minutesBefore, isEnabled];
}

class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool allDay;
  final Recurrence recurrence;
  final String? color;
  final String? location;
  final String? url;
  final String? notes;
  final List<Reminder> reminders;
  final CalendarType calendarType;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.allDay = false,
    this.recurrence = Recurrence.none,
    this.color,
    this.location,
    this.url,
    this.notes,
    this.reminders = const [],
    this.calendarType = CalendarType.personal,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? allDay,
    Recurrence? recurrence,
    String? color,
    String? location,
    String? url,
    String? notes,
    List<Reminder>? reminders,
    CalendarType? calendarType,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      allDay: allDay ?? this.allDay,
      recurrence: recurrence ?? this.recurrence,
      color: color ?? this.color,
      location: location ?? this.location,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      reminders: reminders ?? this.reminders,
      calendarType: calendarType ?? this.calendarType,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => endTime.difference(startTime);

  bool get isPast => endTime.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        allDay,
        recurrence,
        color,
        location,
        url,
        notes,
        reminders,
        calendarType,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}
