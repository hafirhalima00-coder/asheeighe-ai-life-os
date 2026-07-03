import 'package:equatable/equatable.dart';

class TutorProgress extends Equatable {
  final String language;
  final int level;
  final int lessonsCompleted;
  final int totalLessons;
  final double score;
  final int streak;
  final DateTime? lastActivity;
  final List<String> completedLessonIds;

  const TutorProgress({
    required this.language,
    this.level = 1,
    this.lessonsCompleted = 0,
    this.totalLessons = 30,
    this.score = 0,
    this.streak = 0,
    this.lastActivity,
    this.completedLessonIds = const [],
  });

  double get progressPercentage =>
      totalLessons > 0 ? lessonsCompleted / totalLessons : 0;

  bool get isCompleted => lessonsCompleted >= totalLessons;

  String get levelTitle {
    if (level <= 10) return 'Beginner';
    if (level <= 20) return 'Intermediate';
    return 'Advanced';
  }

  TutorProgress copyWith({
    String? language,
    int? level,
    int? lessonsCompleted,
    int? totalLessons,
    double? score,
    int? streak,
    DateTime? lastActivity,
    bool clearLastActivity = false,
    List<String>? completedLessonIds,
  }) {
    return TutorProgress(
      language: language ?? this.language,
      level: level ?? this.level,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      totalLessons: totalLessons ?? this.totalLessons,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      lastActivity: clearLastActivity ? null : (lastActivity ?? this.lastActivity),
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    );
  }

  @override
  List<Object?> get props => [
        language,
        level,
        lessonsCompleted,
        totalLessons,
        score,
        streak,
        lastActivity,
        completedLessonIds,
      ];
}
