import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_result.freezed.dart';
part 'skill_result.g.dart';

@freezed
class SkillResult with _$SkillResult {
  const factory SkillResult({
    required String skillName,
    required String action,
    @Default(true) bool success,
    @Default({}) Map<String, dynamic> data,
    String? error,
  }) = _SkillResult;

  factory SkillResult.fromJson(Map<String, dynamic> json) =>
      _$SkillResultFromJson(json);
}
