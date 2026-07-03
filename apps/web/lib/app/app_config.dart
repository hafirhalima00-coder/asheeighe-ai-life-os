class AppConfig {
  const AppConfig._();

  static const String appName = 'PINKZ';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.pinkz.app';
  static const String apiBaseUrl = 'https://api.pinkz.app/v1';
  static const String prefsKey = 'pinkz_prefs';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const String localeCode = 'en_US';
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
  ];
  static const String defaultUserId = 'default';
  static const String defaultThemeMode = 'system';
  static const bool defaultNotificationsEnabled = true;
}
