import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class SearchNotesUseCase {
  final NoteRepository _repository;

  SearchNotesUseCase(this._repository);

  Future<Either<Failure, List<Note>>> call(String query) {
    return _repository.search(query);
  }
}
