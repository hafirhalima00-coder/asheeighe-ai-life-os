import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/note_model.dart';
import '../models/notebook_model.dart';

class NoteLocalDataSource {
  final Box _hiveBox;
  static const _notesKey = 'cached_notes';
  static const _notebooksKey = 'cached_notebooks';

  NoteLocalDataSource(this._hiveBox);

  Future<List<NoteModel>> getNotes() async {
    final json = _hiveBox.get(_notesKey) as String?;
    if (json == null) return [];
    final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheNotes(List<NoteModel> notes) async {
    final json =
        jsonEncode(notes.map((e) => e.toJson()).toList());
    await _hiveBox.put(_notesKey, json);
  }

  Future<List<NotebookModel>> getNotebooks() async {
    final json = _hiveBox.get(_notebooksKey) as String?;
    if (json == null) return [];
    final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((e) =>
            NotebookModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheNotebooks(
      List<NotebookModel> notebooks) async {
    final json =
        jsonEncode(notebooks.map((e) => e.toJson()).toList());
    await _hiveBox.put(_notebooksKey, json);
  }

  Future<void> clearCache() async {
    await _hiveBox.delete(_notesKey);
    await _hiveBox.delete(_notebooksKey);
  }
}
