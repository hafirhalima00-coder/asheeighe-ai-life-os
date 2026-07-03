import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    required String userId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool allDay,
    String? recurrence,
    @Default(0xFFF4C2C2) int color,
    String? location,
    String? url,
    String? notes,
    @Default([]) List<DateTime> reminders,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
