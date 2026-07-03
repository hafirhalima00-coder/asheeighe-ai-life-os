import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/insight_card.dart';
import '../widgets/upcoming_events_card.dart';
import '../widgets/today_tasks_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/wellness_tip_card.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final useCase = ref.watch(getDashboardDataUseCaseProvider);
  return DashboardNotifier(getDashboardData: useCase);
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
          child: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    switch (state.status) {
      case DashboardStatus.loading:
        return _buildShimmerLoading();
      case DashboardStatus.error:
        return _buildError(state);
      case DashboardStatus.loaded:
      case DashboardStatus.refreshing:
      case DashboardStatus.initial:
        return _buildContent(state);
    }
  }

  Widget _buildContent(DashboardState state) {
    final data = state.data;
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');
    final greeting = _getGreeting(state.userName);

    final stats = [
      StatItem(
        icon: Icons.check_circle_outline,
        label: 'Tasks Done',
        value: '${data?.pendingTasks.where((t) => t.isCompleted).length ?? 0}',
        color: AppTheme.success,
      ),
      StatItem(
        icon: Icons.timer_outlined,
        label: 'Focus Min',
        value: '${data?.focusScore ?? 0}',
        color: AppTheme.primary,
      ),
      StatItem(
        icon: Icons.event_note,
        label: 'Events',
        value: '${data?.upcomingEvents.length ?? 0}',
        color: AppTheme.secondary,
      ),
      StatItem(
        icon: Icons.reminder,
        label: 'Reminders',
        value: '${data?.activeReminders.length ?? 0}',
        color: AppTheme.warning,
      ),
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.paddingMd),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: AppConstants.text2xl,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(now),
                  style: const TextStyle(
                    fontSize: AppConstants.textMd,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMd),
          if (data != null) ...[
            InsightCard(
              insight: data.wellnessTip.isNotEmpty
                  ? data.wellnessTip
                  : 'You\'re doing great! Try focusing on your top priority task today.',
              onTap: () {},
            ),
            const SizedBox(height: AppConstants.paddingSm),
            UpcomingEventsCard(events: data.upcomingEvents),
            const SizedBox(height: AppConstants.paddingSm),
            TodayTasksCard(
              tasks: data.pendingTasks,
              onTaskToggle: (taskId, isCompleted) {
                ref
                    .read(dashboardProvider.notifier)
                    .updateTaskStatus(taskId, isCompleted);
              },
            ),
            const SizedBox(height: AppConstants.paddingSm),
            StatsRow(stats: stats),
            const SizedBox(height: AppConstants.paddingSm),
            WellnessTipCard(
              tip: data.wellnessTip.isNotEmpty
                  ? data.wellnessTip
                  : 'Take a moment to breathe deeply and reset your focus.',
            ),
            const SizedBox(height: AppConstants.paddingXl),
          ],
          if (state.status == DashboardStatus.refreshing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppConstants.paddingMd),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(DashboardState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: AppTheme.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppConstants.textMd,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(dashboardProvider.notifier).loadDashboard(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.paddingMd),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMd),
          _buildShimmerCard(MediaQuery.of(context).size.width - 32, 100),
          const SizedBox(height: AppConstants.paddingSm),
          _buildShimmerCard(MediaQuery.of(context).size.width - 32, 160),
          const SizedBox(height: AppConstants.paddingSm),
          _buildShimmerCard(MediaQuery.of(context).size.width - 32, 200),
          const SizedBox(height: AppConstants.paddingSm),
          _buildShimmerRow(),
          const SizedBox(height: AppConstants.paddingSm),
          _buildShimmerCard(MediaQuery.of(context).size.width - 32, 80),
        ],
      ),
    );
  }

  Widget _buildShimmerCard(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: index > 0 ? AppConstants.paddingSm : 0,
                ),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, $name!';
    if (hour < 17) return 'Good afternoon, $name!';
    return 'Good evening, $name!';
  }
}
