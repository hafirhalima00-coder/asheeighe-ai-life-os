class Surah {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final String revelationType;
  final int totalAyahs;
  final String description;
  final int? juzStart;
  final int? pageStart;

  const Surah({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.revelationType,
    required this.totalAyahs,
    required this.description,
    this.juzStart,
    this.pageStart,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'nameTransliteration': nameTransliteration,
      'revelationType': revelationType,
      'totalAyahs': totalAyahs,
      'description': description,
      'juzStart': juzStart,
      'pageStart': pageStart,
    };
  }

  bool get isMeccan => revelationType == 'Meccan';
  bool get isMedinan => revelationType == 'Medinan';
}
