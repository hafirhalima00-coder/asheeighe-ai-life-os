import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class SnoozeReminderParams {
  final String id;
  final DateTime until;

  const SnoozeReminderParams({required this.id, required this.until});
}

class SnoozeReminderUseCase {
  final ReminderRepository _repository;

  SnoozeReminderUseCase(this._repository);

  Future<Either<Failure, Reminder>> call(SnoozeReminderParams params) {
    return _repository.snooze(params.id, params.until);
  }
}
