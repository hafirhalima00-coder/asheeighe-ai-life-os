import '../../domain/entities/subscription_plan.dart';

class SubscriptionPlanModel extends SubscriptionPlan {
  const SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.yearlyPrice,
    required super.features,
    required super.aiMessagesPerDay,
    required super.storageLimit,
    super.isPopular,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: json['price'] as int,
      yearlyPrice: json['yearlyPrice'] as int,
      features: List<String>.from(json['features'] ?? []),
      aiMessagesPerDay: json['aiMessagesPerDay'] as int,
      storageLimit: json['storageLimit'] as String,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'yearlyPrice': yearlyPrice,
      'features': features,
      'aiMessagesPerDay': aiMessagesPerDay,
      'storageLimit': storageLimit,
      'isPopular': isPopular,
    };
  }
}
