import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/settings/domain/entities/app_settings.dart';

void main() {
  group('ThemeModeType', () {
    test('should have correct enum values', () {
      expect(ThemeModeType.values, hasLength(3));
      expect(ThemeModeType.light.index, 0);
      expect(ThemeModeType.dark.index, 1);
      expect(ThemeModeType.system.index, 2);
    });
  });

  group('AppSettings', () {
    test('should create with default values', () {
      const settings = AppSettings();
      expect(settings.themeMode, ThemeModeType.system);
      expect(settings.locale, 'en');
      expect(settings.notificationsEnabled, true);
      expect(settings.fontSize, 16.0);
      expect(settings.useDynamicColor, true);
      expect(settings.is24HourFormat, false);
      expect(settings.weekStartsOnMonday, true);
      expect(settings.apiEndpoint, 'https://api.asheeighe.app/v1');
      expect(settings.aiProvider, isNull);
      expect(settings.aiApiKey, isNull);
      expect(settings.composioApiKey, isNull);
    });

    group('maskedAiApiKey', () {
      test('should return masked key when long enough', () {
        final settings = AppSettings(aiApiKey: '1234567890abcdef');
        expect(settings.maskedAiApiKey, '1234******cdef');
      });

      test('should return empty for null key', () {
        const settings = AppSettings();
        expect(settings.maskedAiApiKey, '');
      });

      test('should return empty for short key', () {
        final settings = AppSettings(aiApiKey: '12345');
        expect(settings.maskedAiApiKey, '');
      });
    });

    group('maskedComposioApiKey', () {
      test('should return masked key when long enough', () {
        final settings = AppSettings(composioApiKey: 'abcdefghijklmnop');
        expect(settings.maskedComposioApiKey, 'abcd******mnop');
      });

      test('should return empty for null key', () {
        const settings = AppSettings();
        expect(settings.maskedComposioApiKey, '');
      });
    });

    group('copyWith', () {
      test('should update themeMode', () {
        const settings = AppSettings();
        final updated = settings.copyWith(themeMode: ThemeModeType.dark);
        expect(updated.themeMode, ThemeModeType.dark);
      });

      test('should update locale', () {
        const settings = AppSettings();
        final updated = settings.copyWith(locale: 'fr');
        expect(updated.locale, 'fr');
      });

      test('should toggle notifications', () {
        final settings = AppSettings(notificationsEnabled: true);
        final updated = settings.copyWith(notificationsEnabled: false);
        expect(updated.notificationsEnabled, false);
      });

      test('should update fontSize', () {
        const settings = AppSettings();
        final updated = settings.copyWith(fontSize: 18.0);
        expect(updated.fontSize, 18.0);
      });

      test('should update useDynamicColor', () {
        const settings = AppSettings();
        final updated = settings.copyWith(useDynamicColor: false);
        expect(updated.useDynamicColor, false);
      });

      test('should update format preferences', () {
        const settings = AppSettings();
        final updated = settings.copyWith(
          is24HourFormat: true,
          weekStartsOnMonday: false,
        );
        expect(updated.is24HourFormat, true);
        expect(updated.weekStartsOnMonday, false);
      });

      test('should update apiEndpoint', () {
        const settings = AppSettings();
        final updated = settings.copyWith(apiEndpoint: 'https://custom.api');
        expect(updated.apiEndpoint, 'https://custom.api');
      });

      test('should update AI provider and keys', () {
        const settings = AppSettings();
        final updated = settings.copyWith(
          aiProvider: 'openai',
          aiApiKey: 'sk-123',
          composioApiKey: 'comp-456',
        );
        expect(updated.aiProvider, 'openai');
        expect(updated.aiApiKey, 'sk-123');
        expect(updated.composioApiKey, 'comp-456');
      });

      test('should preserve unset fields', () {
        const settings = AppSettings();
        final updated = settings.copyWith(locale: 'de');
        expect(updated.themeMode, ThemeModeType.system);
        expect(updated.notificationsEnabled, true);
      });
    });
  });
}
