import 'package:flutter/material.dart';

class UsageIndicator extends StatelessWidget {
  final String label;
  final int used;
  final int limit;
  final IconData icon;
  final Color color;
  final String? usedLabel;
  final String? limitLabel;

  const UsageIndicator({
    super.key,
    required this.label,
    required this.used,
    required this.limit,
    required this.icon,
    required this.color,
    this.usedLabel,
    this.limitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlimited = limit == -1;
    final percentage = isUnlimited ? 0.0 : (used / limit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                isUnlimited
                    ? 'Unlimited'
                    : '${usedLabel ?? used.toString()} / ${limitLabel ?? limit.toString()}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (!isUnlimited) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage > 0.8
                      ? const Color(0xFFFF6B6B)
                      : percentage > 0.5
                          ? const Color(0xFFFFD700)
                          : color,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(percentage * 100).round()}% used',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
                if (percentage > 0.8)
                  Text(
                    'Consider upgrading',
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.all_inclusive, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  'No limits',
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class CircularUsageIndicator extends StatelessWidget {
  final double percentage;
  final double size;
  final Color color;
  final Widget? center;

  const CircularUsageIndicator({
    super.key,
    required this.percentage,
    this.size = 80,
    required this.color,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 6,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.8
                    ? const Color(0xFFFF6B6B)
                    : percentage > 0.5
                        ? const Color(0xFFFFD700)
                        : color,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          center ??
              Text(
                '${(percentage * 100).round()}%',
                style: TextStyle(
                  color: color,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ],
      ),
    );
  }
}
