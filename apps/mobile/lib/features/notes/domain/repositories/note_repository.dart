import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../entities/notebook.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> getNote(String id);
  Future<Either<Failure, Note>> createNote(Note note);
  Future<Either<Failure, Note>> updateNote(Note note);
  Future<Either<Failure, void>> deleteNote(String id);
  Future<Either<Failure, List<Note>>> getNotesByNotebook(
      String notebookId);
  Future<Either<Failure, List<Note>>> getPinnedNotes();
  Future<Either<Failure, List<Note>>> getArchivedNotes();
  Future<Either<Failure, List<Note>>> search(String query);
  Future<Either<Failure, Note>> pin(String id, bool pinned);
  Future<Either<Failure, Note>> archive(String id, bool archived);

  Future<Either<Failure, List<Notebook>>> getNotebooks();
  Future<Either<Failure, Notebook>> createNotebook(
      Notebook notebook);
  Future<Either<Failure, Notebook>> updateNotebook(
      Notebook notebook);
  Future<Either<Failure, void>> deleteNotebook(String id);
}
