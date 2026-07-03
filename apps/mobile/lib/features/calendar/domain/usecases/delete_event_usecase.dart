import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/calendar_repository.dart';

class DeleteEventUseCase {
  final CalendarRepository repository;

  DeleteEventUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteEvent(id);
  }
}
