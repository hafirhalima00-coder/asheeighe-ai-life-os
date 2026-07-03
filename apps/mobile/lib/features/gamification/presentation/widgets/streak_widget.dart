import 'package:flutter/material.dart';
import '../domain/entities/streak.dart';

class StreakWidget extends StatelessWidget {
  final Streak streak;
  final bool compact;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.streak,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactStreak(streak: streak, onTap: onTap);
    }
    return _FullStreak(streak: streak, onTap: onTap);
  }
}

class _FullStreak extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onTap;

  const _FullStreak({required this.streak, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = streak.isActive && streak.currentCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.orange.withOpacity(0.08)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? Colors.orange.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isActive ? '🔥' : '❄️',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 4),
            Text(
              '${streak.currentCount}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.orange[700] : Colors.grey[500],
              ),
            ),
            Text(
              streak.displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactStreak extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onTap;

  const _CompactStreak({required this.streak, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = streak.isActive && streak.currentCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.orange.withOpacity(0.08)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? '🔥' : '❄️',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              '${streak.currentCount}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.orange[700] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
