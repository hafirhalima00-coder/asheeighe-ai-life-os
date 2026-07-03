import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/connected_account.dart';

part 'connected_account_model.g.dart';

@JsonSerializable()
class ConnectedAccountModel {
  final String id;
  final String integrationId;
  final String integrationName;
  final String status;
  final DateTime? connectedAt;
  final DateTime? expiresAt;
  final DateTime? lastUsedAt;

  const ConnectedAccountModel({
    required this.id,
    required this.integrationId,
    required this.integrationName,
    this.status = 'active',
    this.connectedAt,
    this.expiresAt,
    this.lastUsedAt,
  });

  factory ConnectedAccountModel.fromJson(
          Map<String, dynamic> json) =>
      _$ConnectedAccountModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConnectedAccountModelToJson(this);

  ConnectedAccount toEntity() => ConnectedAccount(
        id: id,
        integrationId: integrationId,
        integrationName: integrationName,
        status: status,
        connectedAt: connectedAt,
        expiresAt: expiresAt,
        lastUsedAt: lastUsedAt,
      );

  factory ConnectedAccountModel.fromEntity(
          ConnectedAccount entity) =>
      ConnectedAccountModel(
        id: entity.id,
        integrationId: entity.integrationId,
        integrationName: entity.integrationName,
        status: entity.status,
        connectedAt: entity.connectedAt,
        expiresAt: entity.expiresAt,
        lastUsedAt: entity.lastUsedAt,
      );
}
