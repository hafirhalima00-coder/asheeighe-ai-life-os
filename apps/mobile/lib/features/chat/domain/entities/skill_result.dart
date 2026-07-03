import 'package:equatable/equatable.dart';

class SkillResult extends Equatable {
  final String skillName;
  final String action;
  final bool success;
  final Map<String, dynamic> data;
  final String? error;

  const SkillResult({
    required this.skillName,
    required this.action,
    required this.success,
    this.data = const {},
    this.error,
  });

  @override
  List<Object?> get props => [skillName, action, success, data, error];
}
