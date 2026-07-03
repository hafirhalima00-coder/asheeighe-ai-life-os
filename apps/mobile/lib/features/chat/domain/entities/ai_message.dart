import 'package:equatable/equatable.dart';

import 'skill_result.dart';

enum MessageRole { user, assistant, system }

class AIMessage extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final List<SkillResult> skills;
  final bool isLoading;

  const AIMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.skills = const [],
    this.isLoading = false,
  });

  AIMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    List<SkillResult>? skills,
    bool? isLoading,
  }) {
    return AIMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      skills: skills ?? this.skills,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, skills, isLoading];
}
