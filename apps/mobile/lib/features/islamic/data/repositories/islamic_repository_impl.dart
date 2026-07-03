import '../datasources/islamic_remote_datasource.dart';
import '../datasources/islamic_local_datasource.dart';
import '../models/surah_model.dart';
import '../models/hadith_model.dart';

class IslamicRepositoryImpl {
  final IslamicRemoteDataSource _remote;
  final IslamicLocalDataSource _local;

  IslamicRepositoryImpl({
    IslamicRemoteDataSource? remote,
    IslamicLocalDataSource? local,
  })  : _remote = remote ?? IslamicRemoteDataSource(),
        _local = local ?? IslamicLocalDataSource();

  Future<List<SurahModel>> getSurahs() async {
    final remoteSurahs = await _remote.getSurahs();
    return remoteSurahs.isNotEmpty ? remoteSurahs : SurahModel.sampleSurahs;
  }

  Future<List<Map<String, dynamic>>> getAyahs(int surahNumber) async {
    return await _remote.getAyahs(surahNumber);
  }

  Future<List<HadithModel>> getHadithCollection(String collection) async {
    final remoteHadiths = await _remote.getHadithCollection(collection);
    return remoteHadiths.isNotEmpty ? remoteHadiths : HadithModel.sampleHadiths;
  }

  Future<Map<String, dynamic>> getDailyHadith() async {
    return await _remote.getDailyHadith();
  }

  String getAudioUrl(String reciterId, int surahNumber) {
    return _remote.getAudioUrl(reciterId, surahNumber);
  }

  String getReciterName(String reciterId) {
    return _remote.getReciterName(reciterId);
  }

  Future<void> addBookmark(int surahId, int ayahNumber, {String? note}) async {
    final bookmark = {
      'id': 'bm_${DateTime.now().millisecondsSinceEpoch}_$surahId\_$ayahNumber',
      'surahId': surahId,
      'ayahNumber': ayahNumber,
      'timestamp': DateTime.now().toIso8601String(),
      'note': note,
    };
    await _local.saveBookmark(bookmark);
  }

  Future<void> removeBookmark(String id) async {
    await _local.removeBookmark(id);
  }

  List<Map<String, dynamic>> getBookmarks() {
    return _local.getBookmarks();
  }

  Future<void> setLastRead(int surahId, int ayahNumber) async {
    await _local.saveLastRead(surahId, ayahNumber);
  }

  Map<int, int> getLastReadPositions() {
    return _local.getLastRead();
  }

  Future<void> saveDhikrProgress(String dhikrId, int count) async {
    await _local.saveDhikrProgress(dhikrId, count);
  }

  Map<String, int> getDhikrProgress() {
    return _local.getDhikrProgress();
  }

  Future<void> savePrayerSettings(Map<String, dynamic> settings) async {
    await _local.savePrayerSettings(settings);
  }

  Map<String, dynamic> getPrayerSettings() {
    return _local.getPrayerSettings();
  }

  Future<void> saveReciterPreference(String reciterId) async {
    await _local.saveReciterPreference(reciterId);
  }

  String getReciterPreference() {
    return _local.getReciterPreference();
  }

  List<Map<String, dynamic>> searchQuran(String query) {
    final results = <Map<String, dynamic>>[];
    final surahs = SurahModel.sampleSurahs;
    for (final surah in surahs) {
      if (surah.nameEnglish.toLowerCase().contains(query.toLowerCase()) ||
          surah.nameTransliteration.toLowerCase().contains(query.toLowerCase())) {
        results.add({'type': 'surah', 'data': surah.toJson()});
      }
    }
    return results;
  }

  List<Map<String, dynamic>> searchHadith(String query) {
    return HadithModel.sampleHadiths
        .where((h) =>
            h.englishTranslation.toLowerCase().contains(query.toLowerCase()) ||
            h.narrator.toLowerCase().contains(query.toLowerCase()))
        .map((h) => h.toJson())
        .toList();
  }
}
