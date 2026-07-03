import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/calendar_provider.dart';

class CalendarWeekView extends ConsumerWidget {
  const CalendarWeekView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final days = state.weekDays;
    final hours = List.generate(16, (i) => i + 7);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSm),
          child: Row(
            children: days.map((day) {
              final isSelected = day.date.day == state.currentDate.day &&
                  day.date.month == state.currentDate.month &&
                  day.date.year == state.currentDate.year;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(calendarProvider.notifier).goToDate(day.date);
                    ref.read(calendarProvider.notifier).setViewMode(CalendarViewMode.day);
                  },
                  child: AnimatedContainer(
                    duration: AppConstants.durationFast,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(day.date),
                          style: TextStyle(
                            fontSize: AppConstants.textXs,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.date.day}',
                          style: TextStyle(
                            fontSize: AppConstants.textLg,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : day.isToday
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSm),
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final hour = hours[index];
              final time = DateTime(
                state.currentDate.year,
                state.currentDate.month,
                state.currentDate.day,
                hour,
              );
              final hourEvents = state.events.where((e) {
                return e.startTime.hour == hour;
              }).toList();

              return SizedBox(
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        DateFormat('h a').format(time),
                        style: const TextStyle(
                          fontSize: AppConstants.textXs,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      margin: const EdgeInsets.only(right: 8),
                      color: AppTheme.divider,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.divider.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: hourEvents.map((event) {
                            final eventColor = event.color != null
                                ? Color(int.parse(event.color!.replaceFirst('#', '0xFF')))
                                : AppTheme.primary;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: eventColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: eventColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: AppConstants.textXs,
                                    fontWeight: FontWeight.w600,
                                    color: eventColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
