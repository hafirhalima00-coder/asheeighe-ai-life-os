import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsModel {
  final String themeMode;
  final String locale;
  final bool notificationsEnabled;
  final double fontSize;
  final bool useDynamicColor;
  final bool is24HourFormat;
  final bool weekStartsOnMonday;
  final String apiEndpoint;
  final String? aiProvider;
  final String? aiApiKey;
  final String? composioApiKey;

  const AppSettingsModel({
    this.themeMode = 'system',
    this.locale = 'en',
    this.notificationsEnabled = true,
    this.fontSize = 16.0,
    this.useDynamicColor = true,
    this.is24HourFormat = false,
    this.weekStartsOnMonday = true,
    this.apiEndpoint = 'https://api.pinkz.app/v1',
    this.aiProvider,
    this.aiApiKey,
    this.composioApiKey,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettings toEntity() => AppSettings(
        themeMode: ThemeModeType.values.firstWhere(
          (e) => e.name == themeMode,
          orElse: () => ThemeModeType.system,
        ),
        locale: locale,
        notificationsEnabled: notificationsEnabled,
        fontSize: fontSize,
        useDynamicColor: useDynamicColor,
        is24HourFormat: is24HourFormat,
        weekStartsOnMonday: weekStartsOnMonday,
        apiEndpoint: apiEndpoint,
        aiProvider: aiProvider,
        aiApiKey: aiApiKey,
        composioApiKey: composioApiKey,
      );

  factory AppSettingsModel.fromEntity(AppSettings entity) =>
      AppSettingsModel(
        themeMode: entity.themeMode.name,
        locale: entity.locale,
        notificationsEnabled: entity.notificationsEnabled,
        fontSize: entity.fontSize,
        useDynamicColor: entity.useDynamicColor,
        is24HourFormat: entity.is24HourFormat,
        weekStartsOnMonday: entity.weekStartsOnMonday,
        apiEndpoint: entity.apiEndpoint,
        aiProvider: entity.aiProvider,
        aiApiKey: entity.aiApiKey,
        composioApiKey: entity.composioApiKey,
      );
}
