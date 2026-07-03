import 'dart:convert';

class IslamicLocalDataSource {
  final Map<String, dynamic> _storage = {};

  Future<void> saveBookmark(Map<String, dynamic> bookmark) async {
    final bookmarks = getBookmarks();
    bookmarks.add(bookmark);
    _storage['bookmarks'] = bookmarks;
    await _persist();
  }

  Future<void> removeBookmark(String id) async {
    final bookmarks = getBookmarks();
    bookmarks.removeWhere((b) => b['id'] == id);
    _storage['bookmarks'] = bookmarks;
    await _persist();
  }

  List<Map<String, dynamic>> getBookmarks() {
    final data = _storage['bookmarks'];
    if (data is List) return List<Map<String, dynamic>>.from(data);
    return [];
  }

  Future<void> saveLastRead(int surahId, int ayahNumber) async {
    final lastRead = getLastRead();
    lastRead[surahId] = ayahNumber;
    _storage['lastRead'] = lastRead;
    await _persist();
  }

  Map<int, int> getLastRead() {
    final data = _storage['lastRead'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(int.parse(key.toString()), value as int));
    }
    return {};
  }

  Future<void> saveReadingProgress(int surahId, double percentage) async {
    final progress = getReadingProgress();
    progress[surahId.toString()] = percentage;
    _storage['readingProgress'] = progress;
    await _persist();
  }

  Map<String, double> getReadingProgress() {
    final data = _storage['readingProgress'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), (value as num).toDouble()));
    }
    return {};
  }

  Future<void> saveDhikrProgress(String dhikrId, int count) async {
    final progress = getDhikrProgress();
    progress[dhikrId] = count;
    _storage['dhikrProgress'] = progress;
    await _persist();
  }

  Map<String, int> getDhikrProgress() {
    final data = _storage['dhikrProgress'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value as int));
    }
    return {};
  }

  Future<void> savePrayerSettings(Map<String, dynamic> settings) async {
    _storage['prayerSettings'] = settings;
    await _persist();
  }

  Map<String, dynamic> getPrayerSettings() {
    final data = _storage['prayerSettings'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return {
      'method': 'MWL',
      'juristic': "Shafi'i",
      'latitude': 21.4225,
      'longitude': 39.8262,
    };
  }

  Future<void> saveReciterPreference(String reciterId) async {
    _storage['reciterId'] = reciterId;
    await _persist();
  }

  String getReciterPreference() {
    return _storage['reciterId'] as String? ?? 'mishary';
  }

  Future<void> saveNightMode(bool enabled) async {
    _storage['nightMode'] = enabled;
    await _persist();
  }

  bool getNightMode() {
    return _storage['nightMode'] as bool? ?? false;
  }

  Future<void> saveTranslationPreference(String translation) async {
    _storage['translation'] = translation;
    await _persist();
  }

  String getTranslationPreference() {
    return _storage['translation'] as String? ?? 'english';
  }

  Future<void> _persist() async {
    // In production, use shared_preferences or hive
    // await SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString('islamic_data', jsonEncode(_storage));
    // });
  }

  Future<void> load() async {
    // In production, load from persistent storage
    // final prefs = await SharedPreferences.getInstance();
    // final data = prefs.getString('islamic_data');
    // if (data != null) {
    //   _storage.addAll(jsonDecode(data));
    // }
  }

  Future<void> clearAll() async {
    _storage.clear();
    await _persist();
  }
}
