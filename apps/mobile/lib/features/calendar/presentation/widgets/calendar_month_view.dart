import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/calendar_event.dart';
import '../providers/calendar_provider.dart';

class CalendarMonthView extends ConsumerWidget {
  const CalendarMonthView({super.key});

  static const _dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final days = state.monthDays;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
          child: Row(
            children: _dayNames.map((name) {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: AppConstants.textXs,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.85,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return _DayCell(day: day);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends ConsumerWidget {
  final dynamic day;

  const _DayCell({required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calendarProvider.notifier);
    final state = ref.watch(calendarProvider);
    final isSelected = day.date.day == state.currentDate.day &&
        day.date.month == state.currentDate.month &&
        day.date.year == state.currentDate.year;

    return GestureDetector(
      onTap: () {
        notifier.goToDate(day.date);
        notifier.setViewMode(CalendarViewMode.day);
      },
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : day.isToday
                  ? AppTheme.primaryLight.withOpacity(0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.date.day}',
              style: TextStyle(
                fontSize: AppConstants.textMd,
                fontWeight: isSelected || day.isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : day.isCurrentMonth
                        ? AppTheme.textPrimary
                        : AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 4),
            if (day.events.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildEventDots(day.events),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEventDots(List<CalendarEvent> events) {
    final maxDots = 3;
    final displayEvents = events.take(maxDots).toList();
    return displayEvents.map((event) {
      final eventColor = event.color != null
          ? Color(int.parse(event.color!.replaceFirst('#', '0xFF')))
          : AppTheme.primary;
      return Container(
        width: 5,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: eventColor,
          shape: BoxShape.circle,
        ),
      );
    }).toList();
  }
}
