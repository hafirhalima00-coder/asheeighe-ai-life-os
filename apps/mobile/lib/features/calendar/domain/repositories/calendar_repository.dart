import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_event.dart';

abstract class CalendarRepository {
  Future<Either<Failure, List<CalendarEvent>>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, CalendarEvent>> getEvent(String id);

  Future<Either<Failure, CalendarEvent>> createEvent(CalendarEvent event);

  Future<Either<Failure, CalendarEvent>> updateEvent(CalendarEvent event);

  Future<Either<Failure, void>> deleteEvent(String id);

  Future<Either<Failure, CalendarEvent>> toggleComplete(String id);
}
