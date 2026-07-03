import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.id,
    required super.nameArabic,
    required super.nameEnglish,
    required super.nameTransliteration,
    required super.revelationType,
    required super.totalAyahs,
    required super.description,
    super.juzStart,
    super.pageStart,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameTransliteration: json['nameTransliteration'] as String,
      revelationType: json['revelationType'] as String,
      totalAyahs: json['totalAyahs'] as int,
      description: json['description'] as String,
      juzStart: json['juzStart'] as int?,
      pageStart: json['pageStart'] as int?,
    );
  }

  factory SurahModel.fromApiJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['number'] as int,
      nameArabic: json['name'] as String,
      nameEnglish: json['englishName'] as String,
      nameTransliteration: json['englishNameTranslation'] as String ?? '',
      revelationType: json['revelationType'] as String,
      totalAyahs: json['numberOfAyahs'] as int,
      description: json['revelationType'] == 'Meccan'
          ? 'Revealed in Makkah'
          : 'Revealed in Madinah',
    );
  }

  static List<SurahModel> get sampleSurahs => const [
    SurahModel(id: 1, nameArabic: 'الفاتحة', nameEnglish: 'The Opening', nameTransliteration: 'Al-Fatiha', revelationType: 'Meccan', totalAyahs: 7, description: 'The Opening - recited in every unit of prayer', juzStart: 1, pageStart: 1),
    SurahModel(id: 2, nameArabic: 'البقرة', nameEnglish: 'The Cow', nameTransliteration: 'Al-Baqarah', revelationType: 'Medinan', totalAyahs: 286, description: 'The longest Surah', juzStart: 1, pageStart: 1),
    SurahModel(id: 3, nameArabic: 'آل عمران', nameEnglish: 'The Family of Imran', nameTransliteration: 'Ali-Imran', revelationType: 'Medinan', totalAyahs: 200, description: 'Named after the family of Imran', juzStart: 3, pageStart: 50),
  ];
}
