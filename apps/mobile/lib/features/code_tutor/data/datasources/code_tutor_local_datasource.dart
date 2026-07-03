import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coding_lesson_model.dart';

class CodeTutorLocalDataSource {
  static const _progressKey = 'code_tutor_progress';
  static const _sessionsKey = 'code_tutor_sessions';
  static const _statsKey = 'code_tutor_stats';

  Future<void> cacheProgress(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(progress));
  }

  Map<String, dynamic>? getCachedProgress() {
    return SharedPreferences.getInstance().then((prefs) {
      final data = prefs.getString(_progressKey);
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    }).sync;
  }

  Future<void> cacheLessonProgress(String lessonId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lesson_$lessonId';
    await prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic>? getCachedLessonProgress(String lessonId) {
    return SharedPreferences.getInstance().then((prefs) {
      final data = prefs.getString('lesson_$lessonId');
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    }).sync;
  }

  Future<void> cacheSession(String sessionId, Map<String, dynamic> session) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'session_$sessionId';
    await prefs.setString(key, jsonEncode(session));
  }

  Map<String, dynamic>? getCachedSession(String sessionId) {
    return SharedPreferences.getInstance().then((prefs) {
      final data = prefs.getString('session_$sessionId');
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    }).sync;
  }

  Future<void> cacheStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  Future<Map<String, dynamic>?> getCachedStats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_statsKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }
}
