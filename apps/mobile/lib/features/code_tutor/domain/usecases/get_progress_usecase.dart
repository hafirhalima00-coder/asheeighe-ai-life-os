import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/tutor_progress.dart';
import '../repositories/code_tutor_repository.dart';

class GetProgressUseCase {
  final CodeTutorRepository repository;

  GetProgressUseCase(this.repository);

  Future<Either<Failure, List<TutorProgress>>> call() {
    return repository.getAllProgress();
  }

  Future<Either<Failure, TutorProgress>> forLanguage(String language) {
    return repository.getProgress(language);
  }
}
