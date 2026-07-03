enum SubscriptionStatus { active, canceled, trialing, pastDue, inactive }

class UserSubscription {
  final String id;
  final String userId;
  final String planId;
  final SubscriptionStatus status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? cancelAt;
  final bool isTrial;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.cancelAt,
    this.isTrial = false,
  });

  bool get isActive => status == SubscriptionStatus.active;
  bool get isCanceled => status == SubscriptionStatus.canceled;
  bool get isPastDue => status == SubscriptionStatus.pastDue;
  bool get willCancel => cancelAt != null;

  bool get isPaidUser =>
      planId.startsWith('PRO') || planId.startsWith('PREMIUM');

  bool get isPro =>
      (planId == 'PRO_MONTHLY' || planId == 'PRO_YEARLY') && isActive;

  bool get isPremium =>
      (planId == 'PREMIUM_MONTHLY' || planId == 'PREMIUM_YEARLY') && isActive;

  String get planName {
    if (planId.startsWith('PREMIUM')) return 'Premium';
    if (planId.startsWith('PRO')) return 'Pro';
    return 'Free';
  }

  int get daysUntilRenewal {
    if (currentPeriodEnd == null) return 0;
    return currentPeriodEnd!.difference(DateTime.now()).inDays;
  }

  UserSubscription copyWith({
    String? id,
    String? userId,
    String? planId,
    SubscriptionStatus? status,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
    DateTime? cancelAt,
    bool? isTrial,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      cancelAt: cancelAt ?? this.cancelAt,
      isTrial: isTrial ?? this.isTrial,
    );
  }

  factory UserSubscription.free(String userId) {
    return UserSubscription(
      id: 'free_$userId',
      userId: userId,
      planId: 'FREE',
      status: SubscriptionStatus.active,
    );
  }
}
