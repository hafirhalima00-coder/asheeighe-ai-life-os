import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class CreateEventUseCase {
  final CalendarRepository repository;

  CreateEventUseCase(this.repository);

  Future<Either<Failure, CalendarEvent>> call(CalendarEvent event) {
    return repository.createEvent(event);
  }
}
