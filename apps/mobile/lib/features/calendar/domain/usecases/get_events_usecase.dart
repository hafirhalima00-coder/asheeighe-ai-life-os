import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class GetEventsUseCase {
  final CalendarRepository repository;

  GetEventsUseCase(this.repository);

  Future<Either<Failure, List<CalendarEvent>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getEvents(startDate: startDate, endDate: endDate);
  }
}
