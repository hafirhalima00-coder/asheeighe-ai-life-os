import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class CreateNoteParams {
  final String title;
  final String content;
  final NoteType type;
  final String? notebookId;
  final List<String> tags;
  final String color;

  const CreateNoteParams({
    required this.title,
    this.content = '',
    this.type = NoteType.text,
    this.notebookId,
    this.tags = const [],
    this.color = '#FFF5F5',
  });
}

class CreateNoteUseCase {
  final NoteRepository _repository;

  CreateNoteUseCase(this._repository);

  Future<Either<Failure, Note>> call(CreateNoteParams params) {
    final note = Note(
      id: '',
      title: params.title,
      content: params.content,
      type: params.type,
      notebookId: params.notebookId,
      tags: params.tags,
      color: params.color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _repository.createNote(note);
  }
}
