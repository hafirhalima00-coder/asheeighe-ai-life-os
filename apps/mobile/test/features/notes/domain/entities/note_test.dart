import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/features/notes/domain/entities/note.dart';

void main() {
  group('NoteType', () {
    test('should have correct enum values', () {
      expect(NoteType.values, hasLength(3));
      expect(NoteType.text.index, 0);
      expect(NoteType.checklist.index, 1);
      expect(NoteType.voice.index, 2);
    });
  });

  group('Note', () {
    final createdAt = DateTime(2024, 6, 15, 10, 0);
    final updatedAt = DateTime(2024, 6, 15, 10, 0);

    final baseNote = Note(
      id: 'note1',
      title: 'Meeting Notes',
      content: 'Discuss Q3 roadmap',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    test('should create with required fields and defaults', () {
      expect(baseNote.id, 'note1');
      expect(baseNote.title, 'Meeting Notes');
      expect(baseNote.content, 'Discuss Q3 roadmap');
      expect(baseNote.type, NoteType.text);
      expect(baseNote.tags, isEmpty);
      expect(baseNote.isPinned, false);
      expect(baseNote.isArchived, false);
      expect(baseNote.color, '#FFF5F5');
      expect(baseNote.notebookId, isNull);
    });

    group('copyWith', () {
      test('should update title', () {
        final updated = baseNote.copyWith(title: 'New Title');
        expect(updated.title, 'New Title');
        expect(updated.id, baseNote.id);
      });

      test('should update content', () {
        final updated = baseNote.copyWith(content: 'New content');
        expect(updated.content, 'New content');
      });

      test('should update type', () {
        final updated = baseNote.copyWith(type: NoteType.checklist);
        expect(updated.type, NoteType.checklist);
      });

      test('should update tags', () {
        final updated = baseNote.copyWith(tags: ['important', 'work']);
        expect(updated.tags, ['important', 'work']);
      });

      test('should update isPinned and isArchived', () {
        final updated = baseNote.copyWith(isPinned: true, isArchived: true);
        expect(updated.isPinned, true);
        expect(updated.isArchived, true);
      });

      test('should update notebookId', () {
        final updated = baseNote.copyWith(notebookId: 'nb1');
        expect(updated.notebookId, 'nb1');
      });

      test('should update color', () {
        final updated = baseNote.copyWith(color: '#FFE4E1');
        expect(updated.color, '#FFE4E1');
      });

      test('should update reminderId', () {
        final updated = baseNote.copyWith(reminderId: 'rem1');
        expect(updated.reminderId, 'rem1');
      });

      test('should preserve unset fields', () {
        final updated = baseNote.copyWith(title: 'New');
        expect(updated.content, baseNote.content);
        expect(updated.createdAt, baseNote.createdAt);
      });
    });

    group('value equality', () {
      test('identical notes should be equal', () {
        final n1 = Note(id: '1', title: 'A', content: 'B', createdAt: createdAt, updatedAt: updatedAt);
        final n2 = Note(id: '1', title: 'A', content: 'B', createdAt: createdAt, updatedAt: updatedAt);
        expect(n1 == n2, true);
      });
    });
  });
}
