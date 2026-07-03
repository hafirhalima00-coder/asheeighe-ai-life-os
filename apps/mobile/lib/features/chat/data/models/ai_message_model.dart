import '../../../chat/domain/entities/ai_message.dart';
import 'skill_result_model.dart';

class AIMessageModel extends AIMessage {
  const AIMessageModel({
    required super.id,
    required super.role,
    required super.content,
    required super.timestamp,
    super.skills,
    super.isLoading,
  });

  factory AIMessageModel.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] as String? ?? 'user';
    return AIMessageModel(
      id: json['id'] as String? ?? '',
      role: MessageRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => MessageRole.user,
      ),
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      skills: (json['skills'] as List<dynamic>?)
              ?.map(
                  (e) => SkillResultModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isLoading: json['is_loading'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'skills': skills
          .map((s) => SkillResultModel(
                skillName: s.skillName,
                action: s.action,
                success: s.success,
                data: s.data,
                error: s.error,
              ).toJson())
          .toList(),
      'is_loading': isLoading,
    };
  }
}
