import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/skill_result.dart';

class SkillResultCard extends StatefulWidget {
  final SkillResult result;

  const SkillResultCard({super.key, required this.result});

  @override
  State<SkillResultCard> createState() => _SkillResultCardState();
}

class _SkillResultCardState extends State<SkillResultCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 2),
      decoration: BoxDecoration(
        color: result.success
            ? AppTheme.success.withOpacity(0.08)
            : AppTheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: result.success
              ? AppTheme.success.withOpacity(0.2)
              : AppTheme.error.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      result.success
                          ? Icons.check_circle
                          : Icons.error_outline,
                      size: AppConstants.iconSm,
                      color: result.success
                          ? AppTheme.success
                          : AppTheme.error,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${_capitalize(result.skillName)}: ${result.action}',
                        style: TextStyle(
                          fontSize: AppConstants.textXs,
                          fontWeight: FontWeight.w500,
                          color: result.success
                              ? AppTheme.success
                              : AppTheme.error,
                        ),
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: AppConstants.iconSm,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
                if (_isExpanded && result.data.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ...result.data.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(left: 22, top: 2),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(
                          fontSize: AppConstants.textXs,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
                if (result.error != null && _isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 22, top: 4),
                    child: Text(
                      result.error!,
                      style: const TextStyle(
                        fontSize: AppConstants.textXs,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
