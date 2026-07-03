import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/dashboard_data.dart';

class UpcomingEventsCard extends StatelessWidget {
  final List<CalendarEvent> events;

  const UpcomingEventsCard({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
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
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: AppTheme.secondary,
                    size: AppConstants.iconMd,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSm),
                const Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: AppConstants.textLg,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMd),
            if (events.isEmpty)
              _buildEmptyState()
            else
              ...events.take(3).asMap().entries.map(
                    (entry) => _buildEventItem(entry.value, entry.key),
                  ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(
          begin: 0.05,
          duration: 500.ms,
          delay: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildEventItem(CalendarEvent event, int index) {
    final timeFormat = DateFormat('h:mm a');
    return Container(
      margin: EdgeInsets.only(top: index > 0 ? AppConstants.paddingSm : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (index < min(events.length, 3) - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: AppTheme.divider,
                ),
            ],
          ),
          const SizedBox(width: AppConstants.paddingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: AppConstants.textMd,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                  style: const TextStyle(
                    fontSize: AppConstants.textSm,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (event.location != null)
                  Text(
                    event.location!,
                    style: const TextStyle(
                      fontSize: AppConstants.textXs,
                      color: AppTheme.textHint,
                    ),
                  ),
              ],
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
            Icons.event_busy,
            color: AppTheme.textHint.withOpacity(0.5),
            size: AppConstants.iconMd,
          ),
          const SizedBox(width: AppConstants.paddingSm),
          const Text(
            'No upcoming events',
            style: TextStyle(
              color: AppTheme.textHint,
              fontSize: AppConstants.textMd,
            ),
          ),
        ],
      ),
    );
  }
}

int min(int a, int b) => a < b ? a : b;
