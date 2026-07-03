import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_local_datasource.dart';
import '../datasources/calendar_remote_datasource.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  final CalendarLocalDataSource localDataSource;

  CalendarRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CalendarEvent>>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final remoteEvents = await remoteDataSource.getEvents(
        startDate: startDate,
        endDate: endDate,
      );
      await localDataSource.cacheEvents(
        startDate: startDate,
        endDate: endDate,
        events: remoteEvents,
      );
      return Right(remoteEvents.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final cachedEvents = localDataSource.getCachedEvents(
          startDate: startDate,
          endDate: endDate,
        );
        if (cachedEvents != null && cachedEvents.isNotEmpty) {
          return Right(cachedEvents.map((e) => e.toEntity()).toList());
        }
        return Left(CacheFailure(message: 'No cached events available.'));
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to fetch events.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> getEvent(String id) async {
    try {
      final remoteEvent = await remoteDataSource.getEvent(id);
      await localDataSource.cacheEvent(remoteEvent);
      return Right(remoteEvent.toEntity());
    } catch (e) {
      try {
        final cachedEvent = localDataSource.getCachedEvent(id);
        if (cachedEvent != null) {
          return Right(cachedEvent.toEntity());
        }
        return Left(NotFoundFailure(message: 'Event not found.'));
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to fetch event.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> createEvent(CalendarEvent event) async {
    try {
      final model = CalendarEventModel.fromEntity(event);
      final created = await remoteDataSource.createEvent(model);
      await localDataSource.cacheEvent(created);
      return Right(created.toEntity());
    } catch (e) {
      try {
        final localEvent = CalendarEventModel.fromEntity(event);
        await localDataSource.cacheEvent(localEvent);
        return Right(event);
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to create event.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> updateEvent(CalendarEvent event) async {
    try {
      final model = CalendarEventModel.fromEntity(event);
      final updated = await remoteDataSource.updateEvent(model);
      await localDataSource.cacheEvent(updated);
      return Right(updated.toEntity());
    } catch (e) {
      try {
        final localEvent = CalendarEventModel.fromEntity(
          event.copyWith(updatedAt: DateTime.now()),
        );
        await localDataSource.cacheEvent(localEvent);
        return Right(localEvent.toEntity());
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to update event.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    try {
      await remoteDataSource.deleteEvent(id);
      await localDataSource.deleteCachedEvent(id);
      return const Right(null);
    } catch (e) {
      try {
        await localDataSource.deleteCachedEvent(id);
        return const Right(null);
      } catch (cacheError) {
        return Left(ServerFailure(
          message: 'Failed to delete event.',
          error: e,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> toggleComplete(String id) async {
    final result = await getEvent(id);
    return result.fold(
      (failure) => Left(failure),
      (event) async {
        final toggled = event.copyWith(
          isCompleted: !event.isCompleted,
          updatedAt: DateTime.now(),
        );
        return updateEvent(toggled);
      },
    );
  }
}
