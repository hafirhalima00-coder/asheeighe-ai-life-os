enum ThemeModeType { light, dark, system }

class AppSettings {
  final ThemeModeType themeMode;
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

  const AppSettings({
    this.themeMode = ThemeModeType.system,
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

  String get maskedAiApiKey {
    if (aiApiKey == null || aiApiKey!.length < 8) return '';
    return '${aiApiKey!.substring(0, 4)}${'*' * (aiApiKey!.length - 8)}${aiApiKey!.substring(aiApiKey!.length - 4)}';
  }

  String get maskedComposioApiKey {
    if (composioApiKey == null || composioApiKey!.length < 8) return '';
    return '${composioApiKey!.substring(0, 4)}${'*' * (composioApiKey!.length - 8)}${composioApiKey!.substring(composioApiKey!.length - 4)}';
  }

  AppSettings copyWith({
    ThemeModeType? themeMode,
    String? locale,
    bool? notificationsEnabled,
    double? fontSize,
    bool? useDynamicColor,
    bool? is24HourFormat,
    bool? weekStartsOnMonday,
    String? apiEndpoint,
    String? aiProvider,
    String? aiApiKey,
    String? composioApiKey,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      fontSize: fontSize ?? this.fontSize,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      weekStartsOnMonday:
          weekStartsOnMonday ?? this.weekStartsOnMonday,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      aiProvider: aiProvider ?? this.aiProvider,
      aiApiKey: aiApiKey ?? this.aiApiKey,
      composioApiKey: composioApiKey ?? this.composioApiKey,
    );
  }
}
