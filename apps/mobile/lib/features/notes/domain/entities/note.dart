enum NoteType { text, checklist, voice }

class Note {
  final String id;
  final String title;
  final String content;
  final NoteType type;
  final String? notebookId;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final String color;
  final String? reminderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.type = NoteType.text,
    this.notebookId,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.color = '#FFF5F5',
    this.reminderId,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    NoteType? type,
    String? notebookId,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    String? color,
    String? reminderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      notebookId: notebookId ?? this.notebookId,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      reminderId: reminderId ?? this.reminderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
