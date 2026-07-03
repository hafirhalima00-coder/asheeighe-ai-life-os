import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/calendar_provider.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final now = state.currentDate;

    String headerText;
    String subHeaderText;
    switch (state.viewMode) {
      case CalendarViewMode.day:
        headerText = DateFormat('EEEE').format(now);
        subHeaderText = DateFormat('MMMM d, yyyy').format(now);
      case CalendarViewMode.week:
        final weekStart = state.weekStart;
        final weekEnd = state.weekEnd.subtract(const Duration(days: 1));
        if (weekStart.month == weekEnd.month) {
          headerText = DateFormat('MMMM yyyy').format(now);
          subHeaderText =
              '${weekStart.day} - ${weekEnd.day}';
        } else {
          headerText = DateFormat('yyyy').format(now);
          subHeaderText =
              '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
        }
      case CalendarViewMode.month:
        headerText = DateFormat('MMMM').format(now);
        subHeaderText = DateFormat('yyyy').format(now);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headerText,
                  style: const TextStyle(
                    fontSize: AppConstants.text2xl,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subHeaderText,
                  style: const TextStyle(
                    fontSize: AppConstants.textSm,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _IconButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => notifier.goToPrevious(),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppTheme.divider,
                ),
                GestureDetector(
                  onTap: () => notifier.goToToday(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: AppConstants.textSm,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppTheme.divider,
                ),
                _IconButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => notifier.goToNext(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}
