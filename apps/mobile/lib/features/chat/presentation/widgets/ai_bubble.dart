import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ai_message.dart';
import 'chat_loading_indicator.dart';
import 'skill_result_card.dart';
import 'suggested_actions.dart';

class AIBubble extends StatelessWidget {
  final AIMessage message;
  final List<String> suggestedActions;
  final void Function(String action)? onActionTap;

  const AIBubble({
    super.key,
    required this.message,
    this.suggestedActions = const [],
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppConstants.paddingXl,
        bottom: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.secondary,
                  Color(0xFF8B83FF),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: AppConstants.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingSm),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingSm),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusXs),
                  topRight: Radius.circular(AppConstants.radiusMd),
                  bottomLeft: Radius.circular(AppConstants.radiusMd),
                  bottomRight: Radius.circular(AppConstants.radiusMd),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppConstants.paddingSm),
                      child: ChatLoadingIndicator(),
                    )
                  else ...[
                    if (message.content.isNotEmpty)
                      Text(
                        message.content,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: AppConstants.textMd,
                          height: 1.5,
                        ),
                      ),
                    if (message.skills.isNotEmpty)
                      ...message.skills.map(
                        (skill) => SkillResultCard(result: skill),
                      ),
                    if (suggestedActions.isNotEmpty)
                      SuggestedActions(
                        actions: suggestedActions,
                        onActionTap: onActionTap,
                      ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: AppConstants.textXs,
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$h:$minute $period';
  }
}
