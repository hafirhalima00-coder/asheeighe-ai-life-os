import 'package:flutter/material.dart';
import '../domain/entities/badge.dart';

class BadgeCard extends StatelessWidget {
  final Badge badge;
  final double size;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    this.size = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLegendary = badge.rarity == BadgeRarity.legendary;
    final isUnlocked = badge.isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUnlocked
              ? badge.rarityColor.withOpacity(0.08)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? badge.rarityColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            width: isLegendary ? 2 : 1,
          ),
          boxShadow: isUnlocked && isLegendary
              ? [
                  BoxShadow(
                    color: badge.rarityColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              badge.icon,
              style: TextStyle(
                fontSize: size * 0.35,
                color: isUnlocked ? null : Colors.grey.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isUnlocked ? Colors.grey[800] : Colors.grey[400],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badge.rarityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge.rarityLabel,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: badge.rarityColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
