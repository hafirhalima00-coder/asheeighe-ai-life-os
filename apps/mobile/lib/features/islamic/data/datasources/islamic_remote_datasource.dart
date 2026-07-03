import '../models/surah_model.dart';
import '../models/hadith_model.dart';

class IslamicRemoteDataSource {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _hadithUrl = 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1';

  Future<List<SurahModel>> getSurahs() async {
    try {
      final response = await _makeRequest('$_baseUrl/surah');
      if (response != null && response['data'] != null) {
        return (response['data'] as List)
            .map((s) => SurahModel.fromApiJson(s))
            .toList();
      }
    } catch (_) {}
    return SurahModel.sampleSurahs;
  }

  Future<List<Map<String, dynamic>>> getAyahs(int surahNumber, {String translation = 'en.sahih'}) async {
    try {
      final response = await _makeRequest('$_baseUrl/surah/$surahNumber/$translation');
      if (response != null && response['data'] != null) {
        return (response['data'] as List).map((a) => a as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> getDailyHadith() async {
    try {
      final response = await _makeRequest('$_hadithUrl/editions/en.sahih-bukhari.json');
      if (response != null && response['hadiths'] != null) {
        final hadiths = response['hadiths'] as List;
        if (hadiths.isNotEmpty) {
          final index = DateTime.now().day % hadiths.length;
          return hadiths[index] as Map<String, dynamic>;
        }
      }
    } catch (_) {}
    return {};
  }

  Future<List<HadithModel>> getHadithCollection(String collection) async {
    try {
      final response = await _makeRequest('$_hadithUrl/editions/$collection.json');
      if (response != null && response['hadiths'] != null) {
        return (response['hadiths'] as List)
            .map((h) => HadithModel.fromApiJson(h))
            .toList();
      }
    } catch (_) {}
    return HadithModel.sampleHadiths;
  }

  Future<Map<String, dynamic>?> _makeRequest(String url) async {
    try {
      // In production, use http package
      return null;
    } catch (e) {
      return null;
    }
  }

  String getAudioUrl(String reciterId, int surahNumber) {
    final reciterUrls = {
      'mishary': 'https://server8.mp3quran.net/afs/',
      'abdulbasit': 'https://server7.mp3quran.net/basit/',
      'sudais': 'https://server12.mp3quran.net/sds/',
      'minshawi': 'https://server11.mp3quran.net/min/',
      'husary': 'https://server13.mp3quran.net/husary/',
    };
    final baseUrl = reciterUrls[reciterId] ?? reciterUrls['mishary']!;
    final paddedId = surahNumber.toString().padLeft(3, '0');
    return '$baseUrl$paddedId.mp3';
  }

  String getReciterName(String reciterId) {
    final names = {
      'mishary': 'Mishary Rashid Al-Afasy',
      'abdulbasit': 'Abdul Basit Abdul Samad',
      'sudais': 'Abdul Rahman Al-Sudais',
      'minshawi': 'Mohamed Siddiq El-Minshawi',
      'husary': 'Mahmoud Khalil Al-Husary',
    };
    return names[reciterId] ?? 'Mishary Rashid Al-Afasy';
  }
}
