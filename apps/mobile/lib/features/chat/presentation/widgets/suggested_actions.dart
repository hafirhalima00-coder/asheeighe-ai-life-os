import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class SuggestedActions extends StatelessWidget {
  final List<String> actions;
  final void Function(String action)? onActionTap;

  const SuggestedActions({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.paddingSm),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return ActionChip(
            label: Text(
              action,
              style: const TextStyle(
                fontSize: AppConstants.textXs,
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppTheme.primary.withOpacity(0.08),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onPressed: () => onActionTap?.call(action),
          ).animate().fadeIn(
                duration: 400.ms,
                delay: (index * 100 + 300).ms,
              ).slideX(begin: 0.1, duration: 400.ms);
        }).toList(),
      ),
    );
  }
}
