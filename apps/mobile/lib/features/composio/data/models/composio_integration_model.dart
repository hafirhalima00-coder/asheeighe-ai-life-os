import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/composio_integration.dart';

part 'composio_integration_model.g.dart';

@JsonSerializable()
class ComposioIntegrationModel {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String category;
  final bool isConnected;
  final DateTime? connectedAt;
  final String authType;

  const ComposioIntegrationModel({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    required this.category,
    this.isConnected = false,
    this.connectedAt,
    this.authType = 'oauth2',
  });

  factory ComposioIntegrationModel.fromJson(
          Map<String, dynamic> json) =>
      _$ComposioIntegrationModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ComposioIntegrationModelToJson(this);

  ComposioIntegration toEntity() => ComposioIntegration(
        id: id,
        name: name,
        description: description,
        logo: logo,
        category: category,
        isConnected: isConnected,
        connectedAt: connectedAt,
        authType: authType,
      );

  factory ComposioIntegrationModel.fromEntity(
          ComposioIntegration entity) =>
      ComposioIntegrationModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        logo: entity.logo,
        category: entity.category,
        isConnected: entity.isConnected,
        connectedAt: entity.connectedAt,
        authType: entity.authType,
      );
}
