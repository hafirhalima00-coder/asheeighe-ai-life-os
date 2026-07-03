class PrayerTime {
  final String name;
  final String nameArabic;
  final DateTime time;
  final bool isNext;
  final bool isPassed;
  final DateTime? jamaahTime;
  final String icon;

  const PrayerTime({
    required this.name,
    required this.nameArabic,
    required this.time,
    required this.isNext,
    required this.isPassed,
    this.jamaahTime,
    required this.icon,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      name: json['name'] as String,
      nameArabic: json['nameArabic'] as String,
      time: DateTime.parse(json['time'] as String),
      isNext: json['isNext'] as bool,
      isPassed: json['isPassed'] as bool,
      jamaahTime: json['jamaahTime'] != null
          ? DateTime.parse(json['jamaahTime'] as String)
          : null,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameArabic': nameArabic,
      'time': time.toIso8601String(),
      'isNext': isNext,
      'isPassed': isPassed,
      'jamaahTime': jamaahTime?.toIso8601String(),
      'icon': icon,
    };
  }

  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  Duration get timeUntil {
    final now = DateTime.now();
    return time.difference(now);
  }

  bool get isFajr => name == 'Fajr';
  bool get isDhuhr => name == 'Dhuhr';
  bool get isAsr => name == 'Asr';
  bool get isMaghrib => name == 'Maghrib';
  bool get isIsha => name == 'Isha';
  bool get isSunrise => name == 'Sunrise';
}
