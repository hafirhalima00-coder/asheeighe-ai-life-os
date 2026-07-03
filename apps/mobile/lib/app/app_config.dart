class AppConfig {
  const AppConfig._();

  static const String appName = 'asheeighe';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.asheeighe.app';
  static const String apiBaseUrl = 'https://api.asheeighe.app/v1';
  static const String hiveBoxName = 'asheeighe_box';
  static const String secureStorageKey = 'asheeighe_secure';
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

  // Subscription Plans
  static const String proMonthlyPlanId = 'asheeighe_pro_monthly';
  static const String proYearlyPlanId = 'asheeighe_pro_yearly';
  static const String premiumMonthlyPlanId = 'asheeighe_premium_monthly';
  static const String premiumYearlyPlanId = 'asheeighe_premium_yearly';
  
  // Feature Flags
  static const bool enableCodeTutor = true;
  static const bool enableIslamic = true;
  static const bool enableVoice = true;
  static const bool enableSocial = true;
  static const bool enableGamification = true;
  
  // AI Limits (Free tier)
  static const int freeAiMessagesPerDay = 5;
  static const int proAiMessagesPerDay = -1; // unlimited
  
  // Referral
  static const int referralRewardDays = 7; // days of Pro for each referral
  
  // App Metadata
  static const String appStoreId = ''; // Fill in when published
  static const String playStoreId = ''; // Fill in when published
}
