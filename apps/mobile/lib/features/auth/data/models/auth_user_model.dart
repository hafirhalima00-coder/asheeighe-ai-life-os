import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final String? authProvider;

  const AuthUserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.authProvider,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        isEmailVerified: isEmailVerified,
        authProvider: authProvider,
      );

  factory AuthUserModel.fromEntity(AuthUser entity) => AuthUserModel(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        avatarUrl: entity.avatarUrl,
        isEmailVerified: entity.isEmailVerified,
        authProvider: entity.authProvider,
      );
}
