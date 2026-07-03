import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/dashboard_data_model.dart';

class DashboardLocalDataSource {
  static const _cacheKey = 'dashboard_cache';
  static const _cacheDateKey = 'dashboard_cache_date';

  Future<void> cacheDashboardData(DashboardDataModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(data.toJson()));
    await prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
  }

  Future<DashboardDataModel?> getCachedDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString(_cacheKey);
    final dateString = prefs.getString(_cacheDateKey);

    if (dataString == null || dateString == null) return null;

    final cacheDate = DateTime.parse(dateString);
    final isExpired = DateTime.now().difference(cacheDate).inMinutes > 30;

    if (isExpired) return null;

    return DashboardDataModel.fromJson(
      jsonDecode(dataString) as Map<String, dynamic>,
    );
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheDateKey);
  }
}
