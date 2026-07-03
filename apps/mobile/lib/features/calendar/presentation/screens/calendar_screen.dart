import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_day_view.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_month_view.dart';
import '../widgets/calendar_week_view.dart';
import '../widgets/event_create_sheet.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CalendarHeader(),
            _ViewModeToggle(),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: AppConstants.durationNormal,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _buildView(state.viewMode),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildView(CalendarViewMode mode) {
    switch (mode) {
      case CalendarViewMode.month:
        return const CalendarMonthView().animate().fadeIn(duration: 300.ms);
      case CalendarViewMode.week:
        return const CalendarWeekView().animate().fadeIn(duration: 300.ms);
      case CalendarViewMode.day:
        return const CalendarDayView().animate().fadeIn(duration: 300.ms);
    }
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EventCreateSheet(),
    );
  }
}

class _ViewModeToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: CalendarViewMode.values.map((mode) {
          final isSelected = state.viewMode == mode;
          final label = mode.name[0].toUpperCase() + mode.name.substring(1);
          return Expanded(
            child: GestureDetector(
              onTap: () => notifier.setViewMode(mode),
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppConstants.textSm,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
