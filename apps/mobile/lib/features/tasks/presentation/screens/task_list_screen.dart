import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_create_sheet.dart';
import '../widgets/task_stats_header.dart';
import '../widgets/task_tile.dart';
import 'task_categories_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final notifier = ref.read(taskProvider.notifier);
    final filteredTasks = state.filteredTasks;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          color: AppTheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppConstants.paddingMd, 16, AppConstants.paddingMd, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: AppConstants.text3xl,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.category_rounded,
                                color: AppTheme.textSecondary),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TaskCategoriesScreen(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded,
                                color: AppTheme.textSecondary),
                            onPressed: () => notifier.refresh(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: TaskStatsHeader(tasks: state.tasks),
              ),
              SliverToBoxAdapter(child: _FilterChips()),
              if (state.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                )
              else if (filteredTasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = filteredTasks[index];
                      return TaskTile(
                        task: task,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  TaskDetailScreen(taskId: task.id),
                            ),
                          );
                        },
                        onComplete: () => notifier.toggleComplete(task.id),
                        onDelete: () => notifier.deleteTask(task.id),
                      ).animate().fadeIn(
                        duration: 300.ms,
                        delay: (index * 50).ms,
                      );
                    },
                    childCount: filteredTasks.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const TaskCreateSheet(),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final notifier = ref.read(taskProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMd, vertical: 8),
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.all_inclusive_rounded,
            isSelected: state.filter == TaskFilter.all,
            onTap: () => notifier.setFilter(TaskFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Today',
            icon: Icons.today_rounded,
            isSelected: state.filter == TaskFilter.today,
            onTap: () => notifier.setFilter(TaskFilter.today),
            count: state.tasks
                .where((t) {
                  final now = DateTime.now();
                  if (t.dueDate == null) return false;
                  return t.dueDate!.day == now.day &&
                      t.dueDate!.month == now.month &&
                      t.dueDate!.year == now.year;
                })
                .length,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'This Week',
            icon: Icons.date_range_rounded,
            isSelected: state.filter == TaskFilter.thisWeek,
            onTap: () => notifier.setFilter(TaskFilter.thisWeek),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Priority',
            icon: Icons.flag_rounded,
            isSelected: state.filter == TaskFilter.priority,
            onTap: () => notifier.setFilter(TaskFilter.priority),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completed',
            icon: Icons.check_circle_rounded,
            isSelected: state.filter == TaskFilter.completed,
            onTap: () => notifier.setFilter(TaskFilter.completed),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.textSm,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: AppConstants.textXs,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checklist_rounded,
              size: 56,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: AppConstants.textXl,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to create your first task',
            style: TextStyle(
              fontSize: AppConstants.textSm,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
