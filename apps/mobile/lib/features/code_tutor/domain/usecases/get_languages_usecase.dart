import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/code_tutor_repository.dart';

class GetLanguagesUseCase {
  final CodeTutorRepository repository;

  GetLanguagesUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() {
    return repository.getAvailableLanguages();
  }
}
