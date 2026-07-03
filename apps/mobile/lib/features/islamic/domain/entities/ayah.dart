class Ayah {
  final String id;
  final int surahId;
  final int numberInSurah;
  final String arabicText;
  final String englishTranslation;
  final String frenchTranslation;
  final String transliteration;
  final String tafsir;
  final int juzNumber;
  final int page;

  const Ayah({
    required this.id,
    required this.surahId,
    required this.numberInSurah,
    required this.arabicText,
    required this.englishTranslation,
    required this.frenchTranslation,
    required this.transliteration,
    required this.tafsir,
    required this.juzNumber,
    required this.page,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'] as String,
      surahId: json['surahId'] as int,
      numberInSurah: json['numberInSurah'] as int,
      arabicText: json['arabicText'] as String,
      englishTranslation: json['englishTranslation'] as String,
      frenchTranslation: json['frenchTranslation'] as String,
      transliteration: json['transliteration'] as String,
      tafsir: json['tafsir'] as String,
      juzNumber: json['juzNumber'] as int,
      page: json['page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahId': surahId,
      'numberInSurah': numberInSurah,
      'arabicText': arabicText,
      'englishTranslation': englishTranslation,
      'frenchTranslation': frenchTranslation,
      'transliteration': transliteration,
      'tafsir': tafsir,
      'juzNumber': juzNumber,
      'page': page,
    };
  }

  String get reference => '$surahId:$numberInSurah';
}
