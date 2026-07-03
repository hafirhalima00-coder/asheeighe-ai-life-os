import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../screens/paywall_screen.dart';
import 'pro_badge.dart';

class FeatureGateWidget extends ConsumerWidget {
  final String feature;
  final Widget child;
  final Widget? lockedChild;
  final String? featureName;

  const FeatureGateWidget({
    super.key,
    required this.feature,
    required this.child,
    this.lockedChild,
    this.featureName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final isPaid = state.currentSubscription?.isPaidUser ?? false;

    if (isPaid) return child;

    return lockedChild ?? _buildLockedView(context);
  }

  Widget _buildLockedView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaywallScreen(
              featureName: featureName ?? feature,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          AbsorbPointer(child: child),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProBadge(type: ProBadgeType.pro),
                  const SizedBox(height: 8),
                  const Text(
                    'PRO Feature',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to upgrade',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureGateButton extends ConsumerWidget {
  final String feature;
  final VoidCallback onPressed;
  final String label;
  final String? featureName;
  final ProBadgeType badgeType;

  const FeatureGateButton({
    super.key,
    required this.feature,
    required this.onPressed,
    required this.label,
    this.featureName,
    this.badgeType = ProBadgeType.pro,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final isPaid = state.currentSubscription?.isPaidUser ?? false;

    if (isPaid) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF69B4),
          foregroundColor: Colors.white,
        ),
        child: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaywallScreen(
              featureName: featureName ?? feature,
            ),
          ),
        );
      },
      icon: const ProBadge(type: ProBadgeType.pro, compact: true),
      label: Text('Unlock $label'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFF69B4),
        side: const BorderSide(color: Color(0xFFFF69B4)),
      ),
    );
  }
}
