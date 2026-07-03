import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/dashboard_data.dart';

class TodayTasksCard extends StatelessWidget {
  final List<Task> tasks;
  final void Function(String taskId, bool isCompleted)? onTaskToggle;

  const TodayTasksCard({
    super.key,
    required this.tasks,
    this.onTaskToggle,
  });

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.error;
      case 'medium':
        return AppTheme.warning;
      case 'low':
        return AppTheme.success;
      default:
        return AppTheme.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMd,
        vertical: AppConstants.paddingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Icon(
                    Icons.checklist,
                    color: AppTheme.success,
                    size: AppConstants.iconMd,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSm),
                const Text(
                  "Today's Tasks",
                  style: TextStyle(
                    fontSize: AppConstants.textLg,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${tasks.where((t) => t.isCompleted).length}/${tasks.length}',
                  style: const TextStyle(
                    fontSize: AppConstants.textSm,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMd),
            if (tasks.isEmpty)
              _buildEmptyState()
            else
              ...tasks.map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(
          begin: 0.05,
          duration: 500.ms,
          delay: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTaskItem(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onTaskToggle?.call(task.id, !task.isCompleted),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? AppTheme.success
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? AppTheme.success
                      : AppTheme.divider,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSm),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _priorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSm),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: AppConstants.textMd,
                color: task.isCompleted
                    ? AppTheme.textHint
                    : AppTheme.textPrimary,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          if (task.dueDate != null)
            Text(
              _formatTime(task.dueDate!),
              style: const TextStyle(
                fontSize: AppConstants.textXs,
                color: AppTheme.textHint,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            color: AppTheme.textHint.withOpacity(0.5),
            size: AppConstants.iconMd,
          ),
          const SizedBox(width: AppConstants.paddingSm),
          const Text(
            'All tasks completed!',
            style: TextStyle(
              color: AppTheme.textHint,
              fontSize: AppConstants.textMd,
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
