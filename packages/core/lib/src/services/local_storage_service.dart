import 'dart:convert';

import 'package:hive/hive.dart';

class LocalStorageService {
  final Box _box;

  LocalStorageService(this._box);

  Future<void> save<T>(String key, T value) async {
    if (value is String || value is num || value is bool) {
      await _box.put(key, value);
    } else {
      await _box.put(key, jsonEncode(value));
    }
  }

  T? read<T>(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    if (T == String || T == int || T == double || T == bool) {
      return raw as T;
    }
    try {
      return jsonDecode(raw as String) as T;
    } catch (_) {
      return raw as T?;
    }
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }

  bool containsKey(String key) => _box.containsKey(key);

  Iterable<String> get keys => _box.keys.cast<String>();
}
