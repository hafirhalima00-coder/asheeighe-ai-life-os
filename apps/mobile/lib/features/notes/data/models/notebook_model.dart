import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notebook.dart';

part 'notebook_model.g.dart';

@JsonSerializable()
class NotebookModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final int noteCount;

  const NotebookModel({
    required this.id,
    required this.name,
    this.icon = 'folder',
    this.color = '#FF6B9D',
    this.noteCount = 0,
  });

  factory NotebookModel.fromJson(Map<String, dynamic> json) =>
      _$NotebookModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotebookModelToJson(this);

  Notebook toEntity() => Notebook(
        id: id,
        name: name,
        icon: icon,
        color: color,
        noteCount: noteCount,
      );

  factory NotebookModel.fromEntity(Notebook entity) =>
      NotebookModel(
        id: entity.id,
        name: entity.name,
        icon: entity.icon,
        color: entity.color,
        noteCount: entity.noteCount,
      );
}
