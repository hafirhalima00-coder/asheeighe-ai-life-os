import 'package:equatable/equatable.dart';

enum ReferralStatus {
  pending,
  completed,
  rewarded;

  String get displayName {
    switch (this) {
      case ReferralStatus.pending:
        return 'Pending';
      case ReferralStatus.completed:
        return 'Completed';
      case ReferralStatus.rewarded:
        return 'Rewarded';
    }
  }
}

enum ReferralRewardType {
  proWeek,
  proMonth,
  lifetimePro,
  credits;

  String get displayName {
    switch (this) {
      case ReferralRewardType.proWeek:
        return 'Pro Week';
      case ReferralRewardType.proMonth:
        return 'Pro Month';
      case ReferralRewardType.lifetimePro:
        return 'Lifetime Pro';
      case ReferralRewardType.credits:
        return 'Credits';
    }
  }

  String get icon {
    switch (this) {
      case ReferralRewardType.proWeek:
        return '📅';
      case ReferralRewardType.proMonth:
        return '📆';
      case ReferralRewardType.lifetimePro:
        return '👑';
      case ReferralRewardType.credits:
        return '💰';
    }
  }
}

class ReferralReward extends Equatable {
  final ReferralRewardType type;
  final int value;
  final String description;

  const ReferralReward({
    required this.type,
    required this.value,
    required this.description,
  });

  factory ReferralReward.fromJson(Map<String, dynamic> json) {
    return ReferralReward(
      type: ReferralRewardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ReferralRewardType.proWeek,
      ),
      value: json['value'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [type, value, description];
}

class ReferralMilestone extends Equatable {
  final int requiredReferrals;
  final ReferralReward reward;
  final String title;
  final String description;

  const ReferralMilestone({
    required this.requiredReferrals,
    required this.reward,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [requiredReferrals, reward, title, description];
}

class ReferralStats extends Equatable {
  final int totalReferrals;
  final int completedReferrals;
  final int pendingReferrals;
  final List<ReferralReward> rewardsEarned;
  final ReferralMilestone? nextMilestone;
  final double progressToNextMilestone;

  const ReferralStats({
    this.totalReferrals = 0,
    this.completedReferrals = 0,
    this.pendingReferrals = 0,
    this.rewardsEarned = const [],
    this.nextMilestone,
    this.progressToNextMilestone = 0.0,
  });

  factory ReferralStats.fromJson(Map<String, dynamic> json) {
    return ReferralStats(
      totalReferrals: json['total_referrals'] as int? ?? 0,
      completedReferrals: json['completed_referrals'] as int? ?? 0,
      pendingReferrals: json['pending_referrals'] as int? ?? 0,
      rewardsEarned: (json['rewards_earned'] as List<dynamic>?)
              ?.map((r) => ReferralReward.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      nextMilestone: json['next_milestone'] != null
          ? ReferralMilestone(
              requiredReferrals: json['next_milestone']['required_referrals'],
              reward: ReferralReward.fromJson(json['next_milestone']['reward']),
              title: json['next_milestone']['title'],
              description: json['next_milestone']['description'],
            )
          : null,
      progressToNextMilestone:
          (json['progress_to_next_milestone'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        totalReferrals,
        completedReferrals,
        pendingReferrals,
        rewardsEarned,
        nextMilestone,
        progressToNextMilestone,
      ];
}

class Referral extends Equatable {
  final String id;
  final String code;
  final int referredCount;
  final List<ReferralReward> rewards;
  final int totalEarned;

  const Referral({
    required this.id,
    required this.code,
    this.referredCount = 0,
    this.rewards = const [],
    this.totalEarned = 0,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] as String,
      code: json['code'] as String,
      referredCount: json['referred_count'] as int? ?? 0,
      rewards: (json['rewards'] as List<dynamic>?)
              ?.map((r) => ReferralReward.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      totalEarned: json['total_earned'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'referred_count': referredCount,
      'rewards': rewards.map((r) => r.toJson()).toList(),
      'total_earned': totalEarned,
    };
  }

  @override
  List<Object?> get props => [id, code, referredCount, rewards, totalEarned];
}
