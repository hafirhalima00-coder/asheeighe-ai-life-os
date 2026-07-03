import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/tutor_session.dart';
import '../repositories/code_tutor_repository.dart';

class SendMessageUseCase {
  final CodeTutorRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, TutorSession>> call(String sessionId, String message) {
    return repository.sendMessage(sessionId, message);
  }
}
