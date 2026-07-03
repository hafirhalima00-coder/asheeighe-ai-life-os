import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class CompleteReminderUseCase {
  final ReminderRepository _repository;

  CompleteReminderUseCase(this._repository);

  Future<Either<Failure, Reminder>> call(String id) {
    return _repository.complete(id);
  }
}
