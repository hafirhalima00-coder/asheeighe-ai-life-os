import 'package:equatable/equatable.dart';

import 'coding_lesson.dart';

class ChatMessage extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.metadata = const {},
  });

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  @override
  List<Object?> get props => [id, role, content, timestamp, metadata];
}

class TutorSession extends Equatable {
  final String id;
  final String language;
  final List<ChatMessage> messages;
  final CodingLesson? currentLesson;
  final int progress;
  final DateTime createdAt;

  const TutorSession({
    required this.id,
    required this.language,
    this.messages = const [],
    this.currentLesson,
    this.progress = 0,
    required this.createdAt,
  });

  TutorSession copyWith({
    String? id,
    String? language,
    List<ChatMessage>? messages,
    CodingLesson? currentLesson,
    bool clearLesson = false,
    int? progress,
    DateTime? createdAt,
  }) {
    return TutorSession(
      id: id ?? this.id,
      language: language ?? this.language,
      messages: messages ?? this.messages,
      currentLesson: clearLesson ? null : (currentLesson ?? this.currentLesson),
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, language, messages, currentLesson, progress, createdAt];
}
