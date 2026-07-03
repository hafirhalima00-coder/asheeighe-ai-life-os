import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reminder.dart';

part 'reminder_model.g.dart';

@JsonSerializable()
class ReminderModel {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool recurring;
  final String? recurrenceRule;
  final bool enabled;
  final DateTime? snoozedUntil;
  final DateTime? completedAt;
  final String? linkedEntityType;
  final String? linkedEntityId;
  final String? category;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledAt,
    this.recurring = false,
    this.recurrenceRule,
    this.enabled = true,
    this.snoozedUntil,
    this.completedAt,
    this.linkedEntityType,
    this.linkedEntityId,
    this.category,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);

  Reminder toEntity() => Reminder(
        id: id,
        title: title,
        description: description,
        scheduledAt: scheduledAt,
        recurring: recurring,
        recurrenceRule: recurrenceRule,
        enabled: enabled,
        snoozedUntil: snoozedUntil,
        completedAt: completedAt,
        linkedEntityType: linkedEntityType != null
            ? LinkedEntityType.values.firstWhere(
                (e) => e.name == linkedEntityType,
                orElse: () => LinkedEntityType.general,
              )
            : null,
        linkedEntityId: linkedEntityId,
        category: category,
        priority: priority,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ReminderModel.fromEntity(Reminder entity) => ReminderModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        scheduledAt: entity.scheduledAt,
        recurring: entity.recurring,
        recurrenceRule: entity.recurrenceRule,
        enabled: entity.enabled,
        snoozedUntil: entity.snoozedUntil,
        completedAt: entity.completedAt,
        linkedEntityType: entity.linkedEntityType?.name,
        linkedEntityId: entity.linkedEntityId,
        category: entity.category,
        priority: entity.priority,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
