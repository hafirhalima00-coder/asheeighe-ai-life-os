import '../../../chat/domain/entities/skill_result.dart';

class SkillResultModel extends SkillResult {
  const SkillResultModel({
    required super.skillName,
    required super.action,
    required super.success,
    super.data,
    super.error,
  });

  factory SkillResultModel.fromJson(Map<String, dynamic> json) {
    return SkillResultModel(
      skillName: json['skill_name'] as String? ?? '',
      action: json['action'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      data: (json['data'] as Map<String, dynamic>?) ?? const {},
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill_name': skillName,
      'action': action,
      'success': success,
      'data': data,
      'error': error,
    };
  }
}
