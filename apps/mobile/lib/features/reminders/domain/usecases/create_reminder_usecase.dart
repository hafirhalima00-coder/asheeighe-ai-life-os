import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class CreateReminderParams {
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool recurring;
  final String? recurrenceRule;
  final String? category;
  final int priority;
  final LinkedEntityType? linkedEntityType;
  final String? linkedEntityId;

  const CreateReminderParams({
    required this.title,
    this.description,
    required this.scheduledAt,
    this.recurring = false,
    this.recurrenceRule,
    this.category,
    this.priority = 0,
    this.linkedEntityType,
    this.linkedEntityId,
  });
}

class CreateReminderUseCase {
  final ReminderRepository _repository;

  CreateReminderUseCase(this._repository);

  Future<Either<Failure, Reminder>> call(CreateReminderParams params) {
    final reminder = Reminder(
      id: '',
      title: params.title,
      description: params.description,
      scheduledAt: params.scheduledAt,
      recurring: params.recurring,
      recurrenceRule: params.recurrenceRule,
      category: params.category,
      priority: params.priority,
      linkedEntityType: params.linkedEntityType,
      linkedEntityId: params.linkedEntityId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _repository.createReminder(reminder);
  }
}
