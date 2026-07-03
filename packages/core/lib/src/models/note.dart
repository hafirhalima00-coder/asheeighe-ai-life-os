import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

enum NoteType { text, checklist, voice }

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String userId,
    required String title,
    required String content,
    @Default(NoteType.text) NoteType type,
    String? notebookId,
    @Default([]) List<String> tags,
    @Default(false) bool isPinned,
    @Default(false) bool isArchived,
    @Default(0xFFFFF8F0) int color,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
