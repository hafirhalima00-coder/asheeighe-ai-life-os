import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';
import '../datasources/reminder_remote_datasource.dart';
import '../models/reminder_model.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource _remoteDataSource;
  final ReminderLocalDataSource _localDataSource;

  ReminderRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, List<Reminder>>> getReminders() async {
    try {
      final models = await _remoteDataSource.getReminders();
      await _localDataSource.cacheReminders(models);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final cached =
            await _localDataSource.getReminders();
        if (cached.isNotEmpty) {
          return Right(
              cached.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> getReminder(
      String id) async {
    try {
      final model = await _remoteDataSource.getReminder(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> createReminder(
      Reminder reminder) async {
    try {
      final model = ReminderModel.fromEntity(reminder);
      final created =
          await _remoteDataSource.createReminder(model);
      return Right(created.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> updateReminder(
      Reminder reminder) async {
    try {
      final model = ReminderModel.fromEntity(
          reminder.copyWith(updatedAt: DateTime.now()));
      final updated =
          await _remoteDataSource.updateReminder(model);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReminder(
      String id) async {
    try {
      await _remoteDataSource.deleteReminder(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Reminder>>>
      getActiveReminders() async {
    try {
      final models =
          await _remoteDataSource.getActiveReminders();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Reminder>>>
      getCompletedReminders() async {
    try {
      final models =
          await _remoteDataSource.getCompletedReminders();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> snooze(
      String id, DateTime until) async {
    try {
      final model = await _remoteDataSource.snooze(id, until);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> dismiss(String id) async {
    try {
      await _remoteDataSource.dismiss(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> complete(
      String id) async {
    try {
      final model = await _remoteDataSource.complete(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
