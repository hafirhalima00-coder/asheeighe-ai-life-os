import 'package:flutter/material.dart';
import '../../domain/entities/subscription_plan.dart';
import 'pro_badge.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isYearly;
  final bool isSelected;
  final ValueChanged<String> onSelect;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isYearly,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final price = isYearly ? plan.yearlyPrice : plan.price;
    final displayPrice = price == 0
        ? 'Free'
        : isYearly
            ? '\$${(price / 100).toStringAsFixed(2)}/yr'
            : '\$${(price / 100).toStringAsFixed(2)}/mo';

    return GestureDetector(
      onTap: () => onSelect(plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF69B4).withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: plan.isPopular
                ? const Color(0xFFFF69B4)
                : isSelected
                    ? const Color(0xFFFF69B4)
                    : Colors.white.withOpacity(0.1),
            width: plan.isPopular ? 2 : 1,
          ),
          boxShadow: plan.isPopular
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF69B4).withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (plan.isPremium)
                  const ProBadge(type: ProBadgeType.premium)
                else if (plan.isPopular)
                  const ProBadge(type: ProBadgeType.pro),
                if (plan.isPopular) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (plan.isPremium && !plan.isPopular) const Spacer(),
                if (!plan.isPremium && !plan.isPopular) ...[
                  const Spacer(),
                  const ProBadge(type: ProBadgeType.free),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              plan.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              plan.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayPrice,
                  style: TextStyle(
                    color: plan.price == 0
                        ? Colors.white70
                        : const Color(0xFFFF69B4),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isYearly && plan.price > 0) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Save ${plan.savingsPercentage}%',
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            ...plan.features.take(4).map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CAF50),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (plan.features.length > 4)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${plan.features.length - 4} more features',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => onSelect(plan.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: plan.isPopular
                      ? const Color(0xFFFF69B4)
                      : plan.isPremium
                          ? const Color(0xFFFFD700)
                          : Colors.white.withOpacity(0.1),
                  foregroundColor:
                      plan.isPremium ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  plan.price == 0 ? 'Current Plan' : 'Subscribe',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
