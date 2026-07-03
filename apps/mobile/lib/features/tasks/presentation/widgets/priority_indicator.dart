import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;
  final bool showLabel;
  final double size;

  const PriorityIndicator({
    super.key,
    required this.priority,
    this.showLabel = false,
    this.size = 10,
  });

  static const Map<TaskPriority, Color> priorityColors = {
    TaskPriority.low: Color(0xFF86EFAC),
    TaskPriority.medium: Color(0xFF93C5FD),
    TaskPriority.high: Color(0xFFFCD34D),
    TaskPriority.urgent: Color(0xFFFDA4AF),
  };

  static const Map<TaskPriority, Color> priorityDarkColors = {
    TaskPriority.low: Color(0xFF22C55E),
    TaskPriority.medium: Color(0xFF3B82F6),
    TaskPriority.high: Color(0xFFF59E0B),
    TaskPriority.urgent: Color(0xFFEF4444),
  };

  static const Map<TaskPriority, String> priorityLabels = {
    TaskPriority.low: 'Low',
    TaskPriority.medium: 'Medium',
    TaskPriority.high: 'High',
    TaskPriority.urgent: 'Urgent',
  };

  @override
  Widget build(BuildContext context) {
    final color = priorityColors[priority] ?? AppTheme.textSecondary;
    final darkColor = priorityDarkColors[priority] ?? AppTheme.textSecondary;
    final label = priorityLabels[priority] ?? '';

    if (showLabel) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: darkColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.textXs,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: size + 4,
      height: size + 4,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
