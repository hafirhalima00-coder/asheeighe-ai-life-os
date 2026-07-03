import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class UpdateEventUseCase {
  final CalendarRepository repository;

  UpdateEventUseCase(this.repository);

  Future<Either<Failure, CalendarEvent>> call(CalendarEvent event) {
    return repository.updateEvent(event);
  }
}
