import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class GetRemindersUseCase {
  final ReminderRepository _repository;

  GetRemindersUseCase(this._repository);

  Future<Either<Failure, List<Reminder>>> call() {
    return _repository.getReminders();
  }
}
