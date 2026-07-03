import '../entities/subscription_plan.dart';
import '../entities/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlan>> getPlans();
  Future<UserSubscription?> getCurrentSubscription();
  Future<void> subscribe(String planId, {String? paymentMethodId});
  Future<void> cancelSubscription({String? reason});
  Future<void> restorePurchases();
  Future<bool> checkFeatureAccess(String feature);
  Future<Map<String, dynamic>> getUsage();
  Future<void> incrementUsage(String feature);
  Future<int> getRemainingAiMessages();
  Future<String> getStorageUsed();
}
