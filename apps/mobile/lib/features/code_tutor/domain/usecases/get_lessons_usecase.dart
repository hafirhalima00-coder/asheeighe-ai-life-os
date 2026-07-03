import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coding_lesson.dart';
import '../repositories/code_tutor_repository.dart';

class GetLessonsUseCase {
  final CodeTutorRepository repository;

  GetLessonsUseCase(this.repository);

  Future<Either<Failure, List<CodingLesson>>> call(String language) {
    return repository.getLessons(language);
  }
}
