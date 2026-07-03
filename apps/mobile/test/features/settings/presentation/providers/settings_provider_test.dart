import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/settings/domain/entities/app_settings.dart';
import 'package:asheeighe/features/settings/domain/repositories/settings_repository.dart';
import 'package:asheeighe/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:asheeighe/features/settings/domain/usecases/reset_settings_usecase.dart';
import 'package:asheeighe/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:asheeighe/features/settings/presentation/providers/settings_provider.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockUpdateSettingsUseCase extends Mock implements UpdateSettingsUseCase {}

class MockResetSettingsUseCase extends Mock implements ResetSettingsUseCase {}

void main() {
  late SettingsNotifier notifier;
  late MockGetSettingsUseCase mockGetSettings;
  late MockUpdateSettingsUseCase mockUpdateSettings;
  late MockResetSettingsUseCase mockResetSettings;

  setUp(() {
    mockGetSettings = MockGetSettingsUseCase();
    mockUpdateSettings = MockUpdateSettingsUseCase();
    mockResetSettings = MockResetSettingsUseCase();
    notifier = SettingsNotifier(
      getSettings: mockGetSettings,
      updateSettings: mockUpdateSettings,
      resetSettings: mockResetSettings,
    );
  });

  const testSettings = AppSettings(
    themeMode: ThemeModeType.light,
    locale: 'en',
    notificationsEnabled: true,
    fontSize: 16.0,
  );

  group('SettingsNotifier', () {
    group('loadSettings', () {
      test('should load settings from use case', () async {
        when(() => mockGetSettings())
            .thenAnswer((_) async => const Right(testSettings));

        await notifier.loadSettings();

        expect(notifier.state.themeMode, ThemeModeType.light);
        expect(notifier.state.locale, 'en');
      });

      test('should keep defaults on failure', () async {
        const failure = CacheFailure(message: 'No cache');
        when(() => mockGetSettings())
            .thenAnswer((_) async => const Left(failure));

        await notifier.loadSettings();

        expect(notifier.state.themeMode, ThemeModeType.system);
      });
    });

    group('updateSettings', () {
      test('should update state on success', () async {
        const newSettings = AppSettings(themeMode: ThemeModeType.dark);
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async => const Right(newSettings));

        await notifier.updateSettings(newSettings);

        expect(notifier.state.themeMode, ThemeModeType.dark);
      });

      test('should keep old state on failure', () async {
        const failure = ServerFailure(message: 'Save failed');
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async => const Left(failure));

        await notifier.updateSettings(testSettings);

        expect(notifier.state.themeMode, ThemeModeType.system);
      });
    });

    group('resetSettings', () {
      test('should reset to defaults on success', () async {
        when(() => mockResetSettings())
            .thenAnswer((_) async => const Right(null));

        await notifier.loadSettings();

        await notifier.resetSettings();

        expect(notifier.state.themeMode, ThemeModeType.system);
        expect(notifier.state.locale, 'en');
        expect(notifier.state.notificationsEnabled, true);
      });

      test('should keep current state on failure', () async {
        const failure = ServerFailure(message: 'Reset failed');
        when(() => mockResetSettings())
            .thenAnswer((_) async => const Left(failure));

        await notifier.resetSettings();

        expect(notifier.state.themeMode, ThemeModeType.system);
      });
    });

    group('setThemeMode', () {
      test('should update theme mode', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async => const Right(AppSettings(themeMode: ThemeModeType.dark)));

        await notifier.setThemeMode(ThemeModeType.dark);
        verify(() => mockUpdateSettings(any())).called(1);
      });
    });

    group('toggleNotifications', () {
      test('should toggle notifications', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async => const Right(AppSettings()));

        await notifier.toggleNotifications();
        expect(notifier.state.notificationsEnabled, false);
      });
    });

    group('setFontSize', () {
      test('should update font size', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async => const Right(AppSettings(fontSize: 18.0)));

        await notifier.setFontSize(18.0);
        verify(() => mockUpdateSettings(any())).called(1);
      });
    });

    group('setAiProvider', () {
      test('should update AI provider', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async =>
                const Right(AppSettings(aiProvider: 'openai')));

        await notifier.setAiProvider('openai');
        verify(() => mockUpdateSettings(any())).called(1);
      });
    });

    group('setAiApiKey', () {
      test('should update AI API key', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async =>
                const Right(AppSettings(aiApiKey: 'sk-123')));

        await notifier.setAiApiKey('sk-123');
        verify(() => mockUpdateSettings(any())).called(1);
      });
    });

    group('setComposioApiKey', () {
      test('should update Composio API key', () async {
        when(() => mockUpdateSettings(any()))
            .thenAnswer((_) async =>
                const Right(AppSettings(composioApiKey: 'comp-key')));

        await notifier.setComposioApiKey('comp-key');
        verify(() => mockUpdateSettings(any())).called(1);
      });
    });
  });
}
