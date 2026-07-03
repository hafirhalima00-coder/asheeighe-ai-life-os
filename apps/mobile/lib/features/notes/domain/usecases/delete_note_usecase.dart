import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteNote(id);
  }
}
