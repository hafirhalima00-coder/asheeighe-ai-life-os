import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminderUseCase {
  final ReminderRepository _repository;

  UpdateReminderUseCase(this._repository);

  Future<Either<Failure, Reminder>> call(Reminder reminder) {
    return _repository.updateReminder(reminder);
  }
}
