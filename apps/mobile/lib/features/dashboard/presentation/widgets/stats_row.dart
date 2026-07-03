import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class StatsRow extends StatelessWidget {
  final List<StatItem> stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMd,
        vertical: AppConstants.paddingSm,
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: _buildStatItem(stat, index),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms).slideY(
          begin: 0.05,
          duration: 500.ms,
          delay: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildStatItem(StatItem stat, int index) {
    return Container(
      margin: EdgeInsets.only(
        left: index > 0 ? AppConstants.paddingSm : 0,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: stat.color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.paddingMd,
          horizontal: AppConstants.paddingSm,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stat.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(stat.icon, color: stat.color, size: AppConstants.iconMd),
            ),
            const SizedBox(height: AppConstants.paddingSm),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: AppConstants.textXl,
                fontWeight: FontWeight.w700,
                color: stat.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              stat.label,
              style: const TextStyle(
                fontSize: AppConstants.textXs,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
