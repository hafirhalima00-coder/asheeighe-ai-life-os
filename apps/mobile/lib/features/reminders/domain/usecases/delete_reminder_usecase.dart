import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/reminder_repository.dart';

class DeleteReminderUseCase {
  final ReminderRepository _repository;

  DeleteReminderUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteReminder(id);
  }
}
