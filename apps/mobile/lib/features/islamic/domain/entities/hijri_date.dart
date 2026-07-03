class HijriDate {
  final int day;
  final int month;
  final String monthName;
  final String monthNameArabic;
  final int year;
  final DateTime gregorianEquivalent;

  const HijriDate({
    required this.day,
    required this.month,
    required this.monthName,
    required this.monthNameArabic,
    required this.year,
    required this.gregorianEquivalent,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      day: json['day'] as int,
      month: json['month'] as int,
      monthName: json['monthName'] as String,
      monthNameArabic: json['monthNameArabic'] as String,
      year: json['year'] as int,
      gregorianEquivalent: DateTime.parse(json['gregorianEquivalent'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'month': month,
      'monthName': monthName,
      'monthNameArabic': monthNameArabic,
      'year': year,
      'gregorianEquivalent': gregorianEquivalent.toIso8601String(),
    };
  }

  String get displayDate => '$day $monthName $year AH';
  String get shortDate => '$day ${monthName.substring(0, 3)} $year';
}
