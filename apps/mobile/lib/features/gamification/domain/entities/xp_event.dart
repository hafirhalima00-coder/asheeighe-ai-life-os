import 'package:equatable/equatable.dart';

enum XpEventType {
  completeTask,
  finishLesson,
  dhikrComplete,
  prayerOnTime,
  dailyLogin,
  streakBonus,
  quizPass,
  codingChallenge,
  readingQuran,
  sharing,
  mentoring,
}

class XpEvent extends Equatable {
  final String id;
  final XpEventType type;
  final int amount;
  final String? description;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const XpEvent({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    required this.timestamp,
    this.metadata = const {},
  });

  XpEvent copyWith({
    String? id,
    XpEventType? type,
    int? amount,
    String? description,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return XpEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  String get displayName {
    switch (type) {
      case XpEventType.completeTask:
        return 'Task Completed';
      case XpEventType.finishLesson:
        return 'Lesson Finished';
      case XpEventType.dhikrComplete:
        return 'Dhikr Complete';
      case XpEventType.prayerOnTime:
        return 'Prayer On Time';
      case XpEventType.dailyLogin:
        return 'Daily Login';
      case XpEventType.streakBonus:
        return 'Streak Bonus';
      case XpEventType.quizPass:
        return 'Quiz Passed';
      case XpEventType.codingChallenge:
        return 'Coding Challenge';
      case XpEventType.readingQuran:
        return 'Reading Quran';
      case XpEventType.sharing:
        return 'Shared Achievement';
      case XpEventType.mentoring:
        return 'Mentoring';
    }
  }

  static const Map<XpEventType, int> defaultXpAmounts = {
    XpEventType.completeTask: 10,
    XpEventType.finishLesson: 20,
    XpEventType.dhikrComplete: 15,
    XpEventType.prayerOnTime: 10,
    XpEventType.dailyLogin: 5,
    XpEventType.streakBonus: 25,
    XpEventType.quizPass: 30,
    XpEventType.codingChallenge: 50,
    XpEventType.readingQuran: 20,
    XpEventType.sharing: 5,
    XpEventType.mentoring: 15,
  };

  static int defaultXp(XpEventType type) {
    return defaultXpAmounts[type] ?? 10;
  }

  @override
  List<Object?> get props => [id, type, amount, description, timestamp, metadata];
}
