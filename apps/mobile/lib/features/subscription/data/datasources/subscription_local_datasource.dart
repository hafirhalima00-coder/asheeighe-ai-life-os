import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_plan_model.dart';
import '../models/user_subscription_model.dart';

class SubscriptionLocalDataSource {
  final SharedPreferences prefs;

  static const _plansKey = 'cached_plans';
  static const _subscriptionKey = 'cached_subscription';
  static const _usageKey = 'cached_usage';

  SubscriptionLocalDataSource(this.prefs);

  Future<void> cachePlans(List<SubscriptionPlanModel> plans) async {
    final data = plans.map((e) => e.toJson()).toList();
    await prefs.setString(_plansKey, json.encode(data));
  }

  Future<List<SubscriptionPlanModel>?> getCachedPlans() async {
    final data = prefs.getString(_plansKey);
    if (data == null) return null;
    final list = json.decode(data) as List;
    return list.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
  }

  Future<void> cacheSubscription(UserSubscriptionModel? sub) async {
    if (sub == null) {
      await prefs.remove(_subscriptionKey);
      return;
    }
    await prefs.setString(_subscriptionKey, json.encode(sub.toJson()));
  }

  Future<UserSubscriptionModel?> getCachedSubscription() async {
    final data = prefs.getString(_subscriptionKey);
    if (data == null) return null;
    return UserSubscriptionModel.fromJson(json.decode(data));
  }

  Future<void> cacheUsage(Map<String, dynamic> usage) async {
    await prefs.setString(_usageKey, json.encode(usage));
  }

  Future<Map<String, dynamic>?> getCachedUsage() async {
    final data = prefs.getString(_usageKey);
    if (data == null) return null;
    return json.decode(data);
  }

  Future<void> clearAll() async {
    await prefs.remove(_plansKey);
    await prefs.remove(_subscriptionKey);
    await prefs.remove(_usageKey);
  }
}
