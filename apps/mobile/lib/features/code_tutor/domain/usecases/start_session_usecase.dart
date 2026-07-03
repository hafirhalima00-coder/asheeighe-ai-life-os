import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/tutor_session.dart';
import '../repositories/code_tutor_repository.dart';

class StartSessionUseCase {
  final CodeTutorRepository repository;

  StartSessionUseCase(this.repository);

  Future<Either<Failure, TutorSession>> call(String language, {String? lessonId}) {
    return repository.startSession(language, lessonId);
  }
}
