import 'coding_lesson.dart';

class CodingLessonModel {
  final String id;
  final String language;
  final int level;
  final String title;
  final String description;
  final String type;
  final String content;
  final String? codeExample;
  final String? expectedOutput;
  final List<String> hints;
  final int order;
  final int estimatedMinutes;
  final int xpReward;
  final String status;
  final int? score;

  const CodingLessonModel({
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
    this.status = 'not_started',
    this.score,
  });

  factory CodingLessonModel.fromJson(Map<String, dynamic> json) {
    return CodingLessonModel(
      id: json['id'] as String,
      language: json['language'] as String,
      level: json['level'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      codeExample: json['codeExample'] as String?,
      expectedOutput: json['expectedOutput'] as String?,
      hints: (json['hints'] as List<dynamic>?)?.cast<String>() ?? [],
      order: json['order'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
      xpReward: json['xpReward'] as int? ?? 15,
      status: json['status'] as String? ?? 'not_started',
      score: json['score'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'level': level,
      'title': title,
      'description': description,
      'type': type,
      'content': content,
      'codeExample': codeExample,
      'expectedOutput': expectedOutput,
      'hints': hints,
      'order': order,
      'estimatedMinutes': estimatedMinutes,
      'xpReward': xpReward,
      'status': status,
      'score': score,
    };
  }

  factory CodingLessonModel.fromEntity(CodingLesson lesson) {
    return CodingLessonModel(
      id: lesson.id,
      language: lesson.language,
      level: lesson.level,
      title: lesson.title,
      description: lesson.description,
      type: lesson.type.name,
      content: lesson.content,
      codeExample: lesson.codeExample,
      expectedOutput: lesson.expectedOutput,
      hints: lesson.hints,
      order: lesson.order,
      estimatedMinutes: lesson.estimatedMinutes,
      xpReward: lesson.xpReward,
      status: lesson.status.name,
      score: lesson.score,
    );
  }

  CodingLesson toEntity() {
    return CodingLesson(
      id: id,
      language: language,
      level: level,
      title: title,
      description: description,
      type: LessonType.values.firstWhere((e) => e.name == type),
      content: content,
      codeExample: codeExample,
      expectedOutput: expectedOutput,
      hints: hints,
      order: order,
      estimatedMinutes: estimatedMinutes,
      xpReward: xpReward,
      status: LessonStatus.values.firstWhere((e) => e.name == status),
      score: score,
    );
  }
}
