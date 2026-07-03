class Notebook {
  final String id;
  final String name;
  final String icon;
  final String color;
  final int noteCount;

  const Notebook({
    required this.id,
    required this.name,
    this.icon = 'folder',
    this.color = '#FF6B9D',
    this.noteCount = 0,
  });

  Notebook copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    int? noteCount,
  }) {
    return Notebook(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      noteCount: noteCount ?? this.noteCount,
    );
  }
}
