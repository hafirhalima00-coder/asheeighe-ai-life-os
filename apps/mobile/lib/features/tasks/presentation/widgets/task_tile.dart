import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';
import 'priority_indicator.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onDelete,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;

    return Dismissible(
      key: Key(task.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onComplete?.call();
          return false;
        } else {
          onDelete?.call();
          return false;
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.success,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMd, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onComplete,
                child: AnimatedContainer(
                  duration: AppConstants.durationFast,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppTheme.success
                        : Colors.transparent,
                    border: Border.all(
                      color: isDone
                          ? AppTheme.success
                          : AppTheme.textHint,
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PriorityIndicator(
                          priority: task.priority,
                          size: 8,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: AppConstants.durationFast,
                            style: TextStyle(
                              fontSize: AppConstants.textMd,
                              fontWeight: FontWeight.w600,
                              color: isDone
                                  ? AppTheme.textSecondary
                                  : AppTheme.textPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppTheme.textSecondary,
                            ),
                            child: Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (task.dueDate != null) ...[
                          Icon(
                            task.isOverdue
                                ? Icons.error_outline_rounded
                                : Icons.schedule_rounded,
                            size: 13,
                            color: task.isOverdue
                                ? AppTheme.error
                                : AppTheme.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: AppConstants.textXs,
                              fontWeight: FontWeight.w500,
                              color: task.isOverdue
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (task.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull),
                            ),
                            child: Text(
                              task.category!,
                              style: const TextStyle(
                                fontSize: AppConstants.textXs,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              ReorderableDragStartListener(
                index: 0,
                child: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    size: 20,
                    color: AppTheme.textHint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (date.isToday) {
      return 'Today ${DateFormat('h:mm a').format(date)}';
    } else if (date.isTomorrow) {
      return 'Tomorrow ${DateFormat('h:mm a').format(date)}';
    } else if (diff.inDays < 7 && diff.inDays > 0) {
      return '${DateFormat('EEEE').format(date)} ${DateFormat('h:mm a').format(date)}';
    } else if (date.isPast) {
      final daysOverdue = now.difference(date).inDays;
      return 'Overdue ${daysOverdue > 0 ? '${daysOverdue}d' : ''}';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }
}
