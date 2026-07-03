import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/reminder.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final void Function(Duration)? onSnooze;
  final VoidCallback? onDelete;

  const ReminderTile({
    super.key,
    required this.reminder,
    this.onTap,
    this.onComplete,
    this.onSnooze,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColors = {
      'Health': const Color(0xFF4CAF50),
      'Work': const Color(0xFF2196F3),
      'Study': const Color(0xFF9C27B0),
      'Personal': const Color(0xFFFF9800),
      'Finance': const Color(0xFF795548),
    };
    final catColor = reminder.category != null
        ? categoryColors[reminder.category] ??
            AppTheme.primary
        : AppTheme.primary;

    return Dismissible(
      key: Key(reminder.id),
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.success.withOpacity(0.9),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.9),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onComplete?.call();
          return false;
        } else {
          onDelete?.call();
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat('hh:mm a')
                                  .format(reminder.scheduledAt),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                            if (reminder.recurring) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.repeat,
                                size: 14,
                                color: AppTheme.textHint,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (reminder.description != null &&
                            reminder.description!.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 2),
                            child: Text(
                              reminder.description!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onSnooze != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: AppTheme.textHint, size: 20),
                      onSelected: (value) {
                        final durations = {
                          '15min': Duration(minutes: 15),
                          '1h': Duration(hours: 1),
                          'tomorrow':
                              Duration(days: 1),
                        };
                        onSnooze!(durations[value]!);
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: '15min',
                          child: Text('Snooze 15 min'),
                        ),
                        const PopupMenuItem(
                          value: '1h',
                          child: Text('Snooze 1 hour'),
                        ),
                        const PopupMenuItem(
                          value: 'tomorrow',
                          child: Text('Snooze till tomorrow'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
