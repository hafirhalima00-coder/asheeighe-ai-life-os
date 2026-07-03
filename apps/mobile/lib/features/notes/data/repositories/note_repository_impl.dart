import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/notebook.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_datasource.dart';
import '../datasources/note_remote_datasource.dart';
import '../models/note_model.dart';
import '../models/notebook_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource _remoteDataSource;
  final NoteLocalDataSource _localDataSource;

  NoteRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final models = await _remoteDataSource.getNotes();
      await _localDataSource.cacheNotes(models);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final cached = await _localDataSource.getNotes();
        if (cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> getNote(String id) async {
    try {
      final model = await _remoteDataSource.getNote(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final model = NoteModel.fromEntity(note);
      final created = await _remoteDataSource.createNote(model);
      return Right(created.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final model =
          NoteModel.fromEntity(note.copyWith(updatedAt: DateTime.now()));
      final updated = await _remoteDataSource.updateNote(model);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await _remoteDataSource.deleteNote(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByNotebook(
      String notebookId) async {
    try {
      final models =
          await _remoteDataSource.getNotesByNotebook(notebookId);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getPinnedNotes() async {
    try {
      final models = await _remoteDataSource.getPinnedNotes();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getArchivedNotes() async {
    try {
      final models = await _remoteDataSource.getArchivedNotes();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> search(String query) async {
    try {
      final models = await _remoteDataSource.search(query);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> pin(
      String id, bool pinned) async {
    try {
      final model = await _remoteDataSource.pin(id, pinned);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> archive(
      String id, bool archived) async {
    try {
      final model =
          await _remoteDataSource.archive(id, archived);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Notebook>>>
      getNotebooks() async {
    try {
      final models =
          await _remoteDataSource.getNotebooks();
      await _localDataSource.cacheNotebooks(models);
      return Right(
          models.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final cached =
            await _localDataSource.getNotebooks();
        if (cached.isNotEmpty) {
          return Right(cached
              .map((e) => e.toEntity())
              .toList());
        }
      } catch (_) {}
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Notebook>> createNotebook(
      Notebook notebook) async {
    try {
      final model = NotebookModel.fromEntity(notebook);
      final created =
          await _remoteDataSource.createNotebook(model);
      return Right(created.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Notebook>> updateNotebook(
      Notebook notebook) async {
    try {
      final model = NotebookModel.fromEntity(notebook);
      final updated =
          await _remoteDataSource.updateNotebook(model);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotebook(
      String id) async {
    try {
      await _remoteDataSource.deleteNotebook(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
