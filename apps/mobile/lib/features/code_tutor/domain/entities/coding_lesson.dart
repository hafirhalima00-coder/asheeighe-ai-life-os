import 'package:equatable/equatable.dart';

enum LessonType { concept, exercise, quiz, project }

enum LessonStatus { notStarted, inProgress, completed }

class CodingLesson extends Equatable {
  final String id;
  final String language;
  final int level;
  final String title;
  final String description;
  final LessonType type;
  final String content;
  final String? codeExample;
  final String? expectedOutput;
  final List<String> hints;
  final int order;
  final int estimatedMinutes;
  final int xpReward;
  final LessonStatus status;
  final int? score;

  const CodingLesson({
    required this.id,
    required this.language,
    required this.level,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    this.codeExample,
    this.expectedOutput,
    this.hints = const [],
    required this.order,
    this.estimatedMinutes = 10,
    this.xpReward = 15,
    this.status = LessonStatus.notStarted,
    this.score,
  });

  CodingLesson copyWith({
    String? id,
    String? language,
    int? level,
    String? title,
    String? description,
    LessonType? type,
    String? content,
    String? codeExample,
    bool clearCodeExample = false,
    String? expectedOutput,
    bool clearExpectedOutput = false,
    List<String>? hints,
    int? order,
    int? estimatedMinutes,
    int? xpReward,
    LessonStatus? status,
    int? score,
    bool clearScore = false,
  }) {
    return CodingLesson(
      id: id ?? this.id,
      language: language ?? this.language,
      level: level ?? this.level,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      content: content ?? this.content,
      codeExample: clearCodeExample ? null : (codeExample ?? this.codeExample),
      expectedOutput: clearExpectedOutput ? null : (expectedOutput ?? this.expectedOutput),
      hints: hints ?? this.hints,
      order: order ?? this.order,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      xpReward: xpReward ?? this.xpReward,
      status: status ?? this.status,
      score: clearScore ? null : (score ?? this.score),
    );
  }

  bool get isCompleted => status == LessonStatus.completed;
  bool get isLocked => status == LessonStatus.notStarted && order > 1;

  String get typeDisplayName {
    switch (type) {
      case LessonType.concept:
        return 'Concept';
      case LessonType.exercise:
        return 'Exercise';
      case LessonType.quiz:
        return 'Quiz';
      case LessonType.project:
        return 'Project';
    }
  }

  @override
  List<Object?> get props => [
        id,
        language,
        level,
        title,
        description,
        type,
        content,
        codeExample,
        expectedOutput,
        hints,
        order,
        estimatedMinutes,
        xpReward,
        status,
        score,
      ];
}
