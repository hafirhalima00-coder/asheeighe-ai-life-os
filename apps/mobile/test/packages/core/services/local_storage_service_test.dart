import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

/// A wrapper for local storage operations used in the app.
/// This mirrors the patterns used in DashboardLocalDataSource and SettingsLocalDataSource.
class LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  Future<String?> getString(String key) async => prefs.getString(key);

  Future<bool> setString(String key, String value) async =>
      prefs.setString(key, value);

  Future<bool> remove(String key) async => prefs.remove(key);

  Future<bool> containsKey(String key) async =>
      prefs.containsKey(key);

  Future<bool> getBool(String key, {bool defaultValue = false}) async =>
      prefs.getBool(key) ?? defaultValue;

  Future<void> setBool(String key, bool value) async =>
      prefs.setBool(key, value);

  Future<int> getInt(String key, {int defaultValue = 0}) async =>
      prefs.getInt(key) ?? defaultValue;

  Future<void> setInt(String key, int value) async =>
      prefs.setInt(key, value);

  Future<double> getDouble(String key, {double defaultValue = 0.0}) async =>
      prefs.getDouble(key) ?? defaultValue;

  Future<void> setDouble(String key, double value) async =>
      prefs.setDouble(key, value);
}

void main() {
  group('LocalStorageService', () {
    late MockSharedPreferences mockPrefs;
    late LocalStorageService service;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      service = LocalStorageService(mockPrefs);
    });

    group('getString', () {
      test('should return value when key exists', () async {
        when(() => mockPrefs.getString('key')).thenReturn('value');
        final result = await service.getString('key');
        expect(result, 'value');
      });

      test('should return null when key does not exist', () async {
        when(() => mockPrefs.getString('missing')).thenReturn(null);
        final result = await service.getString('missing');
        expect(result, isNull);
      });
    });

    group('setString', () {
      test('should store string value', () async {
        when(() => mockPrefs.setString('key', 'value'))
            .thenAnswer((_) async => true);
        final result = await service.setString('key', 'value');
        expect(result, true);
        verify(() => mockPrefs.setString('key', 'value')).called(1);
      });
    });

    group('remove', () {
      test('should remove key', () async {
        when(() => mockPrefs.remove('key')).thenAnswer((_) async => true);
        final result = await service.remove('key');
        expect(result, true);
      });
    });

    group('containsKey', () {
      test('should return true when key exists', () async {
        when(() => mockPrefs.containsKey('key')).thenReturn(true);
        final result = await service.containsKey('key');
        expect(result, true);
      });
    });

    group('getBool', () {
      test('should return default value when key missing', () async {
        when(() => mockPrefs.getBool('key')).thenReturn(null);
        final result = await service.getBool('key', defaultValue: true);
        expect(result, true);
      });

      test('should return stored value', () async {
        when(() => mockPrefs.getBool('key')).thenReturn(false);
        final result = await service.getBool('key');
        expect(result, false);
      });
    });

    group('setBool', () {
      test('should store bool value', () async {
        when(() => mockPrefs.setBool('key', true))
            .thenAnswer((_) async => true);
        await service.setBool('key', true);
        verify(() => mockPrefs.setBool('key', true)).called(1);
      });
    });

    group('getInt', () {
      test('should return default when key missing', () async {
        when(() => mockPrefs.getInt('key')).thenReturn(null);
        final result = await service.getInt('key', defaultValue: 42);
        expect(result, 42);
      });
    });

    group('setInt', () {
      test('should store int value', () async {
        when(() => mockPrefs.setInt('key', 10))
            .thenAnswer((_) async => true);
        await service.setInt('key', 10);
        verify(() => mockPrefs.setInt('key', 10)).called(1);
      });
    });

    group('getDouble', () {
      test('should return default when key missing', () async {
        when(() => mockPrefs.getDouble('key')).thenReturn(null);
        final result = await service.getDouble('key', defaultValue: 3.14);
        expect(result, 3.14);
      });
    });

    group('setDouble', () {
      test('should store double value', () async {
        when(() => mockPrefs.setDouble('key', 2.5))
            .thenAnswer((_) async => true);
        await service.setDouble('key', 2.5);
        verify(() => mockPrefs.setDouble('key', 2.5)).called(1);
      });
    });
  });
}
