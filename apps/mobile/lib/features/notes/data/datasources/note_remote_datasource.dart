import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/note_model.dart';
import '../models/notebook_model.dart';

class NoteRemoteDataSource {
  final ApiClient _apiClient;

  NoteRemoteDataSource(this._apiClient);

  Future<List<NoteModel>> getNotes() async {
    final response = await _apiClient.get(ApiConstants.notes);
    return (response.data as List)
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NoteModel> getNote(String id) async {
    final response =
        await _apiClient.get('${ApiConstants.note}$id');
    return NoteModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<NoteModel> createNote(NoteModel note) async {
    final response = await _apiClient.post(
      ApiConstants.notes,
      data: note.toJson(),
    );
    return NoteModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<NoteModel> updateNote(NoteModel note) async {
    final response = await _apiClient.put(
      '${ApiConstants.note}${note.id}',
      data: note.toJson(),
    );
    return NoteModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<void> deleteNote(String id) async {
    await _apiClient.delete('${ApiConstants.note}$id');
  }

  Future<List<NoteModel>> getNotesByNotebook(
      String notebookId) async {
    final response = await _apiClient.get(
      ApiConstants.notes,
      queryParameters: {'notebookId': notebookId},
    );
    return (response.data as List)
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NoteModel>> getPinnedNotes() async {
    final response = await _apiClient.get(
      ApiConstants.notes,
      queryParameters: {'pinned': true},
    );
    return (response.data as List)
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NoteModel>> getArchivedNotes() async {
    final response = await _apiClient.get(
      ApiConstants.notes,
      queryParameters: {'archived': true},
    );
    return (response.data as List)
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NoteModel>> search(String query) async {
    final response = await _apiClient.get(
      ApiConstants.notes,
      queryParameters: {'search': query},
    );
    return (response.data as List)
        .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NoteModel> pin(String id, bool pinned) async {
    final response = await _apiClient.patch(
      '${ApiConstants.note}$id',
      data: {'isPinned': pinned},
    );
    return NoteModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<NoteModel> archive(
      String id, bool archived) async {
    final response = await _apiClient.patch(
      '${ApiConstants.note}$id',
      data: {'isArchived': archived},
    );
    return NoteModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<List<NotebookModel>> getNotebooks() async {
    final response =
        await _apiClient.get('/notebooks');
    return (response.data as List)
        .map((e) =>
            NotebookModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NotebookModel> createNotebook(
      NotebookModel notebook) async {
    final response = await _apiClient.post(
      '/notebooks',
      data: notebook.toJson(),
    );
    return NotebookModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<NotebookModel> updateNotebook(
      NotebookModel notebook) async {
    final response = await _apiClient.put(
      '/notebooks/${notebook.id}',
      data: notebook.toJson(),
    );
    return NotebookModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<void> deleteNotebook(String id) async {
    await _apiClient.delete('/notebooks/$id');
  }
}
