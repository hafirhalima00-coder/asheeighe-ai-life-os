import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/calendar_event.dart';

class EventTile extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const EventTile({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final eventColor = event.color != null
        ? Color(int.parse(event.color!.replaceFirst('#', '0xFF')))
        : AppTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: eventColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusMd),
                    bottomLeft: Radius.circular(AppConstants.radiusMd),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (event.isCompleted)
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: AppTheme.success,
                            ),
                          if (event.isCompleted) const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: AppConstants.textMd,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                                decoration: event.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (!event.allDay) ...[
                            Icon(Icons.schedule_rounded,
                                size: 13, color: AppTheme.textHint),
                            const SizedBox(width: 4),
                            Text(
                              '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                              style: const TextStyle(
                                fontSize: AppConstants.textXs,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (event.location != null) ...[
                            Icon(Icons.location_on_rounded,
                                size: 13, color: AppTheme.textHint),
                            const SizedBox(width: 4),
                            Text(
                              event.location!,
                              style: const TextStyle(
                                fontSize: AppConstants.textXs,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!event.allDay)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('h:mm').format(event.startTime),
                    style: const TextStyle(
                      fontSize: AppConstants.textXs,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
