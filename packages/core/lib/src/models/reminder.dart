import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String userId,
    required String title,
    String? description,
    required DateTime scheduledAt,
    @Default(false) bool recurring,
    String? recurrenceRule,
    @Default(true) bool enabled,
    DateTime? snoozedUntil,
    DateTime? completedAt,
    String? linkedEntityType,
    String? linkedEntityId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
