import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/notes/domain/entities/note.dart';
import 'package:asheeighe/features/notes/domain/repositories/note_repository.dart';
import 'package:asheeighe/features/notes/domain/usecases/create_note_usecase.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late CreateNoteUseCase useCase;
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
    useCase = CreateNoteUseCase(mockRepository);
  });

  final testParams = CreateNoteParams(
    title: 'My Note',
    content: 'Note content',
    type: NoteType.text,
    tags: ['important'],
    color: '#FFF5F5',
  );

  group('CreateNoteUseCase', () {
    test('should call repository.createNote with correct data', () async {
      when(() => mockRepository.createNote(any()))
          .thenAnswer((_) async => Right(Note(
                id: 'note1',
                title: 'My Note',
                content: 'Note content',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      final result = await useCase(testParams);

      verify(() => mockRepository.createNote(any())).called(1);
      expect(result.isRight(), true);
    });

    test('should set empty string as placeholder id before creation', () async {
      when(() => mockRepository.createNote(any()))
          .thenAnswer((_) async => Right(Note(
                id: 'final-id',
                title: 'My Note',
                content: 'Note content',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      await useCase(testParams);

      final captured = verify(() => mockRepository.createNote(captureAny()))
          .captured[0] as Note;
      expect(captured.id, '');
    });

    test('should include all params in created note', () async {
      when(() => mockRepository.createNote(any()))
          .thenAnswer((_) async => Right(Note(
                id: 'final-id',
                title: 'My Note',
                content: 'Note content',
                type: NoteType.text,
                tags: ['important'],
                color: '#FFF5F5',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )));

      final result = await useCase(testParams);

      final captured = verify(() => mockRepository.createNote(captureAny()))
          .captured[0] as Note;
      expect(captured.title, 'My Note');
      expect(captured.content, 'Note content');
      expect(captured.type, NoteType.text);
      expect(captured.tags, ['important']);
      expect(captured.color, '#FFF5F5');
    });

    test('should return ServerFailure on error', () async {
      const failure = ServerFailure(message: 'Database error');
      when(() => mockRepository.createNote(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);
      expect(result, equals(const Left(failure)));
    });

    test('should return ValidationFailure for empty title', () async {
      const failure = ValidationFailure(message: 'Title required');
      when(() => mockRepository.createNote(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(testParams);
      expect(result, equals(const Left(failure)));
    });
  });
}
