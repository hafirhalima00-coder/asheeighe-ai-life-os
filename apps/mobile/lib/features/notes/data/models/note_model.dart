import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String type;
  final String? notebookId;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final String color;
  final String? reminderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.type = 'text',
    this.notebookId,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.color = '#FFF5F5',
    this.reminderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  Note toEntity() => Note(
        id: id,
        title: title,
        content: content,
        type: NoteType.values.firstWhere(
          (e) => e.name == type,
          orElse: () => NoteType.text,
        ),
        notebookId: notebookId,
        tags: tags,
        isPinned: isPinned,
        isArchived: isArchived,
        color: color,
        reminderId: reminderId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory NoteModel.fromEntity(Note entity) => NoteModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        type: entity.type.name,
        notebookId: entity.notebookId,
        tags: entity.tags,
        isPinned: entity.isPinned,
        isArchived: entity.isArchived,
        color: entity.color,
        reminderId: entity.reminderId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
