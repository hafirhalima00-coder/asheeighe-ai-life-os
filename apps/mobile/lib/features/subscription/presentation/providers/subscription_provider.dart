import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/user_subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/usecases/get_plans_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';
import '../../domain/usecases/check_feature_access_usecase.dart';
import '../../domain/usecases/get_usage_usecase.dart';

final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>((ref) {
  throw UnimplementedError('Override in main provider');
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final GetPlansUseCase _getPlans;
  final SubscribeUseCase _subscribe;
  final CheckFeatureAccessUseCase _checkAccess;
  final GetUsageUseCase _getUsage;
  final SubscriptionRepository _repository;

  SubscriptionNotifier({
    required GetPlansUseCase getPlans,
    required SubscribeUseCase subscribe,
    required CheckFeatureAccessUseCase checkAccess,
    required GetUsageUseCase getUsage,
    required SubscriptionRepository repository,
  })  : _getPlans = getPlans,
        _subscribe = subscribe,
        _checkAccess = checkAccess,
        _getUsage = getUsage,
        _repository = repository,
        super(const SubscriptionState());

  Future<void> loadPlans() async {
    state = state.copyWith(isLoadingPlans: true);
    try {
      final plans = await _getPlans();
      state = state.copyWith(plans: plans, isLoadingPlans: false);
    } catch (e) {
      state = state.copyWith(
          isLoadingPlans: false, error: 'Failed to load plans');
    }
  }

  Future<void> loadSubscription() async {
    state = state.copyWith(isLoadingSubscription: true);
    try {
      final sub = await _repository.getCurrentSubscription();
      state = state.copyWith(
          currentSubscription: sub, isLoadingSubscription: false);
    } catch (e) {
      state = state.copyWith(
          isLoadingSubscription: false, error: 'Failed to load subscription');
    }
  }

  Future<void> loadUsage() async {
    state = state.copyWith(isLoadingUsage: true);
    try {
      final usage = await _getUsage();
      state = state.copyWith(usage: usage, isLoadingUsage: false);
    } catch (e) {
      state =
          state.copyWith(isLoadingUsage: false, error: 'Failed to load usage');
    }
  }

  Future<bool> subscribeTo(String planId, {String? paymentMethodId}) async {
    state = state.copyWith(isSubscribing: true);
    try {
      await _subscribe(planId, paymentMethodId: paymentMethodId);
      await loadSubscription();
      await loadUsage();
      state = state.copyWith(isSubscribing: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isSubscribing: false, error: 'Subscription failed');
      return false;
    }
  }

  Future<void> cancelSubscription({String? reason}) async {
    state = state.copyWith(isCanceling: true);
    try {
      await _repository.cancelSubscription(reason: reason);
      await loadSubscription();
      state = state.copyWith(isCanceling: false);
    } catch (e) {
      state =
          state.copyWith(isCanceling: false, error: 'Failed to cancel');
    }
  }

  Future<bool> checkFeatureAccess(String feature) async {
    return await _checkAccess(feature);
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(isRestoring: true);
    try {
      await _repository.restorePurchases();
      await loadSubscription();
      state = state.copyWith(isRestoring: false);
    } catch (e) {
      state = state.copyWith(
          isRestoring: false, error: 'Failed to restore purchases');
    }
  }

  bool get isProUser => state.currentSubscription?.isPro ?? false;
  bool get isPremiumUser => state.currentSubscription?.isPremium ?? false;
  bool get isPaidUser => state.currentSubscription?.isPaidUser ?? false;
}

class SubscriptionState {
  final List<SubscriptionPlan> plans;
  final UserSubscription? currentSubscription;
  final Map<String, dynamic> usage;
  final bool isLoadingPlans;
  final bool isLoadingSubscription;
  final bool isLoadingUsage;
  final bool isSubscribing;
  final bool isCanceling;
  final bool isRestoring;
  final String? error;

  const SubscriptionState({
    this.plans = const [],
    this.currentSubscription,
    this.usage = const {},
    this.isLoadingPlans = false,
    this.isLoadingSubscription = false,
    this.isLoadingUsage = false,
    this.isSubscribing = false,
    this.isCanceling = false,
    this.isRestoring = false,
    this.error,
  });

  SubscriptionState copyWith({
    List<SubscriptionPlan>? plans,
    UserSubscription? currentSubscription,
    Map<String, dynamic>? usage,
    bool? isLoadingPlans,
    bool? isLoadingSubscription,
    bool? isLoadingUsage,
    bool? isSubscribing,
    bool? isCanceling,
    bool? isRestoring,
    String? error,
  }) {
    return SubscriptionState(
      plans: plans ?? this.plans,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      usage: usage ?? this.usage,
      isLoadingPlans: isLoadingPlans ?? this.isLoadingPlans,
      isLoadingSubscription:
          isLoadingSubscription ?? this.isLoadingSubscription,
      isLoadingUsage: isLoadingUsage ?? this.isLoadingUsage,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      isCanceling: isCanceling ?? this.isCanceling,
      isRestoring: isRestoring ?? this.isRestoring,
      error: error,
    );
  }

  bool get isLoading =>
      isLoadingPlans || isLoadingSubscription || isLoadingUsage;
}
