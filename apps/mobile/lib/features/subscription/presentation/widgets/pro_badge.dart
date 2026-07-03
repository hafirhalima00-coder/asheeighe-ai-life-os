import 'package:flutter/material.dart';

enum ProBadgeType { free, pro, premium }

class ProBadge extends StatelessWidget {
  final ProBadgeType type;
  final bool compact;

  const ProBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ProBadgeType.free) {
      return compact
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'FREE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: compact ? 9 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
    }

    final isPremium = type == ProBadgeType.premium;
    final colors = isPremium
        ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
        : [const Color(0xFFFF69B4), const Color(0xFFFF1493)];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: compact ? 4 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isPremium ? 'PREMIUM' : 'PRO',
        style: TextStyle(
          color: isPremium ? Colors.black : Colors.white,
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
