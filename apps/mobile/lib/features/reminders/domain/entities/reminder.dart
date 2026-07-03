enum LinkedEntityType { task, event, note, general }

class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool recurring;
  final String? recurrenceRule;
  final bool enabled;
  final DateTime? snoozedUntil;
  final DateTime? completedAt;
  final LinkedEntityType? linkedEntityType;
  final String? linkedEntityId;
  final String? category;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reminder({
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

  bool get isCompleted => completedAt != null;
  bool get isSnoozed =>
      snoozedUntil != null && snoozedUntil!.isAfter(DateTime.now());

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? recurring,
    String? recurrenceRule,
    bool? enabled,
    DateTime? snoozedUntil,
    DateTime? completedAt,
    LinkedEntityType? linkedEntityType,
    String? linkedEntityId,
    String? category,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      recurring: recurring ?? this.recurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      enabled: enabled ?? this.enabled,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      completedAt: completedAt ?? this.completedAt,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
