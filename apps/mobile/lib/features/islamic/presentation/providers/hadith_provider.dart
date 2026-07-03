import 'package:flutter/material.dart';
import '../../domain/entities/hadith.dart';
import '../../data/repositories/islamic_repository_impl.dart';

class HadithNotifier extends ChangeNotifier {
  final IslamicRepositoryImpl _repository;
  
  List<Hadith> _hadiths = [];
  List<Hadith> _filteredHadiths = [];
  Hadith? _dailyHadith;
  String _selectedCollection = 'bukhari';
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<Hadith> get hadiths => _filteredHadiths;
  Hadith? get dailyHadith => _dailyHadith;
  String get selectedCollection => _selectedCollection;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HadithNotifier({IslamicRepositoryImpl? repository})
      : _repository = repository ?? IslamicRepositoryImpl();

  Future<void> loadHadithCollection(String collection) async {
    _isLoading = true;
    _selectedCollection = collection;
    notifyListeners();
    try {
      _hadiths = await _repository.getHadithCollection(collection);
      _filteredHadiths = List.from(_hadiths);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDailyHadith() async {
    try {
      final data = await _repository.getDailyHadith();
      if (data.isNotEmpty) {
        _dailyHadith = Hadith.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'all') {
      _filteredHadiths = List.from(_hadiths);
    } else {
      _filteredHadiths = _hadiths.where((h) => h.category == category).toList();
    }
    notifyListeners();
  }

  void searchHadith(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredHadiths = List.from(_hadiths);
    } else {
      _filteredHadiths = _hadiths
          .where((h) =>
              h.englishTranslation.toLowerCase().contains(query.toLowerCase()) ||
              h.narrator.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> getCollections() {
    return [
      {'id': 'bukhari', 'name': 'Sahih Bukhari', 'arabicName': 'صحيح البخاري', 'count': 50},
      {'id': 'muslim', 'name': 'Sahih Muslim', 'arabicName': 'صحيح مسلم', 'count': 30},
      {'id': 'abu-dawud', 'name': 'Sunan Abu Dawud', 'arabicName': 'سنن أبي داود', 'count': 10},
      {'id': 'tirmidhi', 'name': 'Jami at-Tirmidhi', 'arabicName': 'جامع الترمذي', 'count': 10},
      {'id': 'ibn-majah', 'name': 'Sunan Ibn Majah', 'arabicName': 'سنن ابن ماجه', 'count': 10},
    ];
  }

  List<Map<String, dynamic>> getCategories() {
    return [
      {'id': 'all', 'name': 'All Categories', 'icon': '📚'},
      {'id': 'faith', 'name': 'Faith (Iman)', 'icon': '✨'},
      {'id': 'prayer', 'name': 'Prayer (Salah)', 'icon': '🕌'},
      {'id': 'fasting', 'name': 'Fasting (Siyam)', 'icon': '🌙'},
      {'id': 'charity', 'name': 'Charity (Zakat)', 'icon': '💎'},
      {'id': 'marriage', 'name': 'Marriage (Nikah)', 'icon': '💍'},
      {'id': 'knowledge', 'name': 'Knowledge (Ilm)', 'icon': '📚'},
      {'id': 'character', 'name': 'Character (Akhlaq)', 'icon': '💎'},
    ];
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredHadiths = List.from(_hadiths);
    notifyListeners();
  }
}
