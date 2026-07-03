class Hadith {
  final String id;
  final String collection;
  final int bookNumber;
  final int hadithNumber;
  final String narrator;
  final String narratorArabic;
  final String arabicText;
  final String englishTranslation;
  final String grade;
  final String category;
  final String description;

  const Hadith({
    required this.id,
    required this.collection,
    required this.bookNumber,
    required this.hadithNumber,
    required this.narrator,
    required this.narratorArabic,
    required this.arabicText,
    required this.englishTranslation,
    required this.grade,
    required this.category,
    required this.description,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as String,
      collection: json['collection'] as String,
      bookNumber: json['bookNumber'] as int,
      hadithNumber: json['hadithNumber'] as int,
      narrator: json['narrator'] as String,
      narratorArabic: json['narratorArabic'] as String,
      arabicText: json['arabicText'] as String,
      englishTranslation: json['englishTranslation'] as String,
      grade: json['grade'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'bookNumber': bookNumber,
      'hadithNumber': hadithNumber,
      'narrator': narrator,
      'narratorArabic': narratorArabic,
      'arabicText': arabicText,
      'englishTranslation': englishTranslation,
      'grade': grade,
      'category': category,
      'description': description,
    };
  }

  String get collectionDisplayName {
    switch (collection) {
      case 'bukhari': return 'Sahih Bukhari';
      case 'muslim': return 'Sahih Muslim';
      case 'abu-dawud': return 'Sunan Abu Dawud';
      case 'tirmidhi': return 'Jami at-Tirmidhi';
      case 'ibn-majah': return 'Sunan Ibn Majah';
      default: return collection;
    }
  }

  bool get isSahih => grade == 'sahih';
  bool get isHasan => grade == 'hasan';
  bool get isDaif => grade == 'daif';

  String get reference => '$collectionDisplayName $bookNumber:$hadithNumber';
}
