class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final int price; // in cents
  final int yearlyPrice; // in cents
  final List<String> features;
  final int aiMessagesPerDay; // -1 = unlimited
  final String storageLimit;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.yearlyPrice,
    required this.features,
    required this.aiMessagesPerDay,
    required this.storageLimit,
    this.isPopular = false,
  });

  String get priceDisplay {
    if (price == 0) return 'Free';
    return '\$${(price / 100).toStringAsFixed(2)}';
  }

  String get yearlyPriceDisplay {
    if (yearlyPrice == 0) return 'Free';
    return '\$${(yearlyPrice / 100).toStringAsFixed(2)}/yr';
  }

  String get monthlyEquivalent {
    if (yearlyPrice == 0) return 'Free';
    return '\$${(yearlyPrice / 100 / 12).toStringAsFixed(2)}/mo';
  }

  int get savingsPercentage {
    if (price == 0 || yearlyPrice == 0) return 0;
    final yearlyMonthly = yearlyPrice / 12;
    return ((1 - yearlyMonthly / price) * 100).round();
  }

  bool get hasUnlimitedAi => aiMessagesPerDay == -1;

  static const List<SubscriptionPlan> defaultPlans = [
    SubscriptionPlan(
      id: 'FREE',
      name: 'Free',
      description: 'Get started with essential features',
      price: 0,
      yearlyPrice: 0,
      features: [
        '5 AI messages/day',
        'Basic tasks & calendar',
        'Notes',
        'Prayer times',
      ],
      aiMessagesPerDay: 5,
      storageLimit: '50MB',
    ),
    SubscriptionPlan(
      id: 'PRO_MONTHLY',
      name: 'Pro',
      description: 'Unlock the full asheeighe experience',
      price: 999,
      yearlyPrice: 7999,
      features: [
        'Unlimited AI messages',
        'All Islamic features',
        'Voice engine',
        'Advanced analytics',
        'Premium templates',
        'Full gamification',
      ],
      aiMessagesPerDay: -1,
      storageLimit: '10GB',
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'PREMIUM_MONTHLY',
      name: 'Premium',
      description: 'The ultimate productivity suite',
      price: 1999,
      yearlyPrice: 14999,
      features: [
        'Everything in Pro',
        'AI Code Tutor',
        'Priority AI (faster)',
        'Business features',
        'API access',
        'Custom integrations',
        'White-label exports',
        'Family sharing (5)',
      ],
      aiMessagesPerDay: -1,
      storageLimit: '100GB',
    ),
  ];
}
