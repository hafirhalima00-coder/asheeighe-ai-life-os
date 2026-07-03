class Dhikr {
  final String id;
  final String name;
  final String nameArabic;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;
  final String category;
  final String? reward;

  const Dhikr({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.targetCount,
    required this.currentCount,
    required this.isCompleted,
    required this.category,
    this.reward,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'] as String,
      name: json['name'] as String,
      nameArabic: json['nameArabic'] as String,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int,
      isCompleted: json['isCompleted'] as bool,
      category: json['category'] as String,
      reward: json['reward'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'isCompleted': isCompleted,
      'category': category,
      'reward': reward,
    };
  }

  double get progress => targetCount > 0 ? currentCount / targetCount : 0.0;
  int get remaining => targetCount - currentCount;
  bool get isFinished => currentCount >= targetCount;
}
