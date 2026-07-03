import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_create_sheet.dart';
import '../widgets/reminder_tile.dart';

class ReminderListScreen extends ConsumerStatefulWidget {
  const ReminderListScreen({super.key});

  @override
  ConsumerState<ReminderListScreen> createState() =>
      _ReminderListScreenState();
}

class _ReminderListScreenState
    extends ConsumerState<ReminderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final notifier = ref.read(reminderProvider.notifier);
      if (_tabController.index == 0) {
        notifier.setActiveTab();
      } else {
        notifier.setCompletedTab();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reminderProvider);
    final notifier = ref.read(reminderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Active'),
                  if (state.activeReminders.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${state.activeReminders.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Completed'),
                  if (state.completedReminders.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${state.completedReminders.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.success,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primary))
          : RefreshIndicator(
              onRefresh: () => notifier.loadReminders(),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReminderList(state.activeReminders,
                      isActive: true),
                  _buildReminderList(state.completedReminders,
                      isActive: false),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderList(List<Reminder> reminders,
      {required bool isActive}) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive
                  ? Icons.notifications_outlined
                  : Icons.check_circle_outline,
              size: 64,
              color: AppTheme.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active reminders' : 'No completed reminders',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'Tap + to create a new reminder'
                  : 'Completed reminders will appear here',
              style: const TextStyle(
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupRemindersByDate(reminders);
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMd),
      itemCount: grouped.entries.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 4, top: 16, bottom: 8),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...entry.value.map((reminder) => ReminderTile(
                  reminder: reminder,
                  onTap: () => _navigateToDetail(reminder),
                  onComplete: isActive
                      ? () => ref
                          .read(reminderProvider.notifier)
                          .completeReminder(reminder.id)
                      : null,
                  onSnooze: isActive
                      ? (duration) =>
                          _handleSnooze(reminder, duration)
                      : null,
                  onDelete: () => ref
                      .read(reminderProvider.notifier)
                      .deleteReminder(reminder.id),
                )),
          ],
        );
      },
    );
  }

  Map<String, List<Reminder>> _groupRemindersByDate(
      List<Reminder> reminders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekEnd = today.add(const Duration(days: 7));

    final grouped = <String, List<Reminder>>{};
    for (final r in reminders) {
      final date = DateTime(r.scheduledAt.year,
          r.scheduledAt.month, r.scheduledAt.day);
      String key;
      if (date == today) {
        key = 'Today';
      } else if (date == tomorrow) {
        key = 'Tomorrow';
      } else if (date.isAfter(today) && date.isBefore(weekEnd)) {
        key = DateFormat('EEEE').format(r.scheduledAt);
      } else {
        key = 'Later';
      }
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(r);
    }

    final order = ['Today', 'Tomorrow', ...List.generate(
        5, (i) => DateFormat('EEEE').format(today.add(Duration(days: i + 2)))), 'Later'];
    final sorted = <String, List<Reminder>>{};
    for (final key in order) {
      if (grouped.containsKey(key)) {
        sorted[key] = grouped[key]!;
      }
    }
    return sorted;
  }

  void _handleSnooze(Reminder reminder, Duration duration) {
    final until = DateTime.now().add(duration);
    ref
        .read(reminderProvider.notifier)
        .snoozeReminder(reminder.id, until);
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReminderCreateSheet(),
    );
  }

  void _navigateToDetail(Reminder reminder) {
    // Navigator.push named route handled by parent
  }
}
