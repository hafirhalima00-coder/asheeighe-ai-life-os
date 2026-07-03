import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/notebook.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/search_notes_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';

class NoteNotifier extends StateNotifier<NoteState> {
  final GetNotesUseCase _getNotes;
  final CreateNoteUseCase _createNote;
  final UpdateNoteUseCase _updateNote;
  final DeleteNoteUseCase _deleteNote;
  final SearchNotesUseCase _searchNotes;

  NoteNotifier({
    required GetNotesUseCase getNotes,
    required CreateNoteUseCase createNote,
    required UpdateNoteUseCase updateNote,
    required DeleteNoteUseCase deleteNote,
    required SearchNotesUseCase searchNotes,
  })  : _getNotes = getNotes,
        _createNote = createNote,
        _updateNote = updateNote,
        _deleteNote = deleteNote,
        _searchNotes = searchNotes,
        super(NoteState());

  Future<void> loadNotes() async {
    state = state.copyWith(isLoading: true);
    final result = await _getNotes();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (notes) {
        state = state.copyWith(
          isLoading: false,
          notes: notes,
          pinnedNotes: notes.where((n) => n.isPinned).toList(),
          archivedNotes:
              notes.where((n) => n.isArchived).toList(),
          recentNotes: notes
              .where((n) => !n.isArchived)
              .toList()
                ..sort(
                    (a, b) => b.updatedAt.compareTo(a.updatedAt)),
        );
      },
    );
  }

  Future<void> createNote(CreateNoteParams params) async {
    final result = await _createNote(params);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadNotes(),
    );
  }

  Future<void> updateNote(Note note) async {
    final result = await _updateNote(note.copyWith(updatedAt: DateTime.now()));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadNotes(),
    );
  }

  Future<void> deleteNote(String id) async {
    final result = await _deleteNote(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadNotes(),
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      loadNotes();
      return;
    }
    state = state.copyWith(isSearching: true, searchQuery: query);
    final result = await _searchNotes(query);
    result.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        error: failure.message,
      ),
      (notes) => state = state.copyWith(
        isSearching: false,
        searchResults: notes,
      ),
    );
  }

  void setGridView(bool isGrid) =>
      state = state.copyWith(isGridView: isGrid);

  void clearError() => state = state.copyWith(error: null);

  void togglePin(Note note) {
    final updated =
        note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
    _updateNote(updated);
  }

  void toggleArchive(Note note) {
    final updated = note.copyWith(
      isArchived: !note.isArchived,
      updatedAt: DateTime.now(),
    );
    _updateNote(updated);
  }
}

class NoteState {
  final bool isLoading;
  final bool isSearching;
  final String? error;
  final String searchQuery;
  final List<Note> notes;
  final List<Note> pinnedNotes;
  final List<Note> archivedNotes;
  final List<Note> recentNotes;
  final List<Note> searchResults;
  final bool isGridView;
  final List<Notebook> notebooks;

  const NoteState({
    this.isLoading = false,
    this.isSearching = false,
    this.error,
    this.searchQuery = '',
    this.notes = const [],
    this.pinnedNotes = const [],
    this.archivedNotes = const [],
    this.recentNotes = const [],
    this.searchResults = const [],
    this.isGridView = true,
    this.notebooks = const [],
  });

  NoteState copyWith({
    bool? isLoading,
    bool? isSearching,
    String? error,
    String? searchQuery,
    List<Note>? notes,
    List<Note>? pinnedNotes,
    List<Note>? archivedNotes,
    List<Note>? recentNotes,
    List<Note>? searchResults,
    bool? isGridView,
    List<Notebook>? notebooks,
  }) {
    return NoteState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      notes: notes ?? this.notes,
      pinnedNotes: pinnedNotes ?? this.pinnedNotes,
      archivedNotes: archivedNotes ?? this.archivedNotes,
      recentNotes: recentNotes ?? this.recentNotes,
      searchResults: searchResults ?? this.searchResults,
      isGridView: isGridView ?? this.isGridView,
      notebooks: notebooks ?? this.notebooks,
    );
  }
}
