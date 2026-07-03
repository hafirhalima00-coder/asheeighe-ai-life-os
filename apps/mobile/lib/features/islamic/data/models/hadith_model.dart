import '../../domain/entities/hadith.dart';

class HadithModel extends Hadith {
  const HadithModel({
    required super.id,
    required super.collection,
    required super.bookNumber,
    required super.hadithNumber,
    required super.narrator,
    required super.narratorArabic,
    required super.arabicText,
    required super.englishTranslation,
    required super.grade,
    required super.category,
    required super.description,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as String,
      collection: json['collection'] as String,
      bookNumber: json['bookNumber'] as int,
      hadithNumber: json['hadithNumber'] as int,
      narrator: json['narrator'] as String,
      narratorArabic: json['narratorArabic'] as String? ?? '',
      arabicText: json['arabicText'] as String,
      englishTranslation: json['englishTranslation'] as String,
      grade: json['grade'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  factory HadithModel.fromApiJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['hadithNumber']?.toString() ?? '',
      collection: 'bukhari',
      bookNumber: json['bookNumber'] ?? 0,
      hadithNumber: json['hadithNumber'] ?? 0,
      narrator: json['narrator'] ?? 'Unknown',
      narratorArabic: json['narratorArabic'] ?? '',
      arabicText: json['arabicText'] ?? '',
      englishTranslation: json['text'] ?? json['englishTranslation'] ?? '',
      grade: json['grade'] ?? 'sahih',
      category: json['category'] ?? 'faith',
      description: json['description'] ?? '',
    );
  }

  static List<HadithModel> get sampleHadiths => const [
    HadithModel(
      id: 'bukhari_1',
      collection: 'bukhari',
      bookNumber: 1,
      hadithNumber: 1,
      narrator: 'Umar ibn Al-Khattab',
      narratorArabic: 'عمر بن الخطاب',
      arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      englishTranslation: 'Actions are but by intentions.',
      grade: 'sahih',
      category: 'faith',
      description: 'The foundation of Islamic intention',
    ),
  ];
}
