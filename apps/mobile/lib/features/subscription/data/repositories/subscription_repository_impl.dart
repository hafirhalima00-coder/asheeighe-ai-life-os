import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/user_subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';
import '../datasources/subscription_local_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remote;
  final SubscriptionLocalDataSource local;
  final String token;

  SubscriptionRepositoryImpl({
    required this.remote,
    required this.local,
    required this.token,
  });

  @override
  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final plans = await remote.getPlans();
      await local.cachePlans(plans);
      return plans;
    } catch (e) {
      final cached = await local.getCachedPlans();
      if (cached != null) return cached;
      return SubscriptionPlan.defaultPlans;
    }
  }

  @override
  Future<UserSubscription?> getCurrentSubscription() async {
    try {
      final sub = await remote.getCurrentSubscription(token);
      await local.cacheSubscription(sub);
      return sub;
    } catch (e) {
      return await local.getCachedSubscription();
    }
  }

  @override
  Future<void> subscribe(String planId, {String? paymentMethodId}) async {
    await remote.subscribe(token, planId, paymentMethodId);
    await local.clearAll();
  }

  @override
  Future<void> cancelSubscription({String? reason}) async {
    await remote.cancelSubscription(token, reason: reason);
    await local.clearAll();
  }

  @override
  Future<void> restorePurchases() async {
    await remote.restorePurchases(token);
    await local.clearAll();
  }

  @override
  Future<bool> checkFeatureAccess(String feature) async {
    return await remote.checkFeatureAccess(token, feature);
  }

  @override
  Future<Map<String, dynamic>> getUsage() async {
    try {
      final usage = await remote.getUsage(token);
      await local.cacheUsage(usage);
      return usage;
    } catch (e) {
      final cached = await local.getCachedUsage();
      return cached ?? {'aiMessagesUsed': 0, 'aiMessagesLimit': 5, 'storageUsed': 0};
    }
  }

  @override
  Future<void> incrementUsage(String feature) async {
    await remote.checkFeatureAccess(token, feature);
  }

  @override
  Future<int> getRemainingAiMessages() async {
    final usage = await getUsage();
    final used = usage['aiMessagesUsed'] as int? ?? 0;
    final limit = usage['aiMessagesLimit'] as int? ?? 5;
    if (limit == -1) return -1;
    return (limit - used).clamp(0, limit);
  }

  @override
  Future<String> getStorageUsed() async {
    final usage = await getUsage();
    final bytes = usage['storageUsed'] as int? ?? 0;
    if (bytes == 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < sizes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${sizes[i]}';
  }
}
