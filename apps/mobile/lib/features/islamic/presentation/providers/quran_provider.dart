import 'package:flutter/material.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/ayah.dart';
import '../../data/repositories/islamic_repository_impl.dart';

class QuranNotifier extends ChangeNotifier {
  final IslamicRepositoryImpl _repository;
  
  List<Surah> _surahs = [];
  List<Surah> _filteredSurahs = [];
  List<Ayah> _currentAyahs = [];
  Surah? _currentSurah;
  String _searchQuery = '';
  String _selectedReciter = 'mishary';
  bool _isLoading = false;
  String? _error;

  List<Surah> get surahs => _filteredSurahs;
  List<Ayah> get currentAyahs => _currentAyahs;
  Surah? get currentSurah => _currentSurah;
  String get searchQuery => _searchQuery;
  String get selectedReciter => _selectedReciter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  QuranNotifier({IslamicRepositoryImpl? repository})
      : _repository = repository ?? IslamicRepositoryImpl();

  Future<void> loadSurahs() async {
    _isLoading = true;
    notifyListeners();
    try {
      _surahs = await _repository.getSurahs();
      _filteredSurahs = List.from(_surahs);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchSurahs(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredSurahs = List.from(_surahs);
    } else {
      _filteredSurahs = _surahs
          .where((s) =>
              s.nameEnglish.toLowerCase().contains(query.toLowerCase()) ||
              s.nameTransliteration.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> loadAyahs(int surahId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentSurah = _surahs.firstWhere((s) => s.id == surahId);
      final ayahsData = await _repository.getAyahs(surahId);
      _currentAyahs = ayahsData.map((a) => Ayah.fromJson(a)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setReciter(String reciterId) {
    _selectedReciter = reciterId;
    notifyListeners();
  }

  String getAudioUrl(int surahNumber) {
    return _repository.getAudioUrl(_selectedReciter, surahNumber);
  }

  String getReciterName(String reciterId) {
    return _repository.getReciterName(reciterId);
  }

  Future<void> bookmarkAyah(int surahId, int ayahNumber, {String? note}) async {
    await _repository.addBookmark(surahId, ayahNumber, note: note);
    notifyListeners();
  }

  Future<void> removeBookmark(String id) async {
    await _repository.removeBookmark(id);
    notifyListeners();
  }

  List<Map<String, dynamic>> getBookmarks() {
    return _repository.getBookmarks();
  }

  Future<void> setLastRead(int surahId, int ayahNumber) async {
    await _repository.setLastRead(surahId, ayahNumber);
  }

  Map<int, int> getLastReadPositions() {
    return _repository.getLastReadPositions();
  }

  List<Map<String, dynamic>> searchQuran(String query) {
    return _repository.searchQuran(query);
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredSurahs = List.from(_surahs);
    notifyListeners();
  }
}
