import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<Either<Failure, List<Reminder>>> getReminders();
  Future<Either<Failure, Reminder>> getReminder(String id);
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder);
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);
  Future<Either<Failure, void>> deleteReminder(String id);
  Future<Either<Failure, List<Reminder>>> getActiveReminders();
  Future<Either<Failure, List<Reminder>>> getCompletedReminders();
  Future<Either<Failure, Reminder>> snooze(
      String id, DateTime until);
  Future<Either<Failure, void>> dismiss(String id);
  Future<Either<Failure, Reminder>> complete(String id);
}
