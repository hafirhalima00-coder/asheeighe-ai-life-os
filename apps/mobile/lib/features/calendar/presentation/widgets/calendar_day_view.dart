import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/calendar_event.dart';
import '../providers/calendar_provider.dart';
import 'event_tile.dart';

class CalendarDayView extends ConsumerWidget {
  const CalendarDayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final events = state.dayEvents;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_rounded,
                size: 48,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No events for this day',
              style: TextStyle(
                fontSize: AppConstants.textLg,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add a new event',
              style: TextStyle(
                fontSize: AppConstants.textSm,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final allDayEvents = events.where((e) => e.allDay).toList();
    final timedEvents = events.where((e) => !e.allDay).toList();
    timedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
      children: [
        if (allDayEvents.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'All Day',
              style: TextStyle(
                fontSize: AppConstants.textXs,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...allDayEvents.map((event) => _AllDayChip(event: event)),
          const SizedBox(height: 12),
        ],
        if (timedEvents.isNotEmpty) ...[
          ...timedEvents.map((event) => EventTile(
                event: event,
                onTap: () {
                  _showEventDetail(context, event);
                },
              )),
        ],
      ],
    );
  }

  void _showEventDetail(BuildContext context, CalendarEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }
}

class _AllDayChip extends StatelessWidget {
  final CalendarEvent event;

  const _AllDayChip({required this.event});

  @override
  Widget build(BuildContext context) {
    final eventColor = event.color != null
        ? Color(int.parse(event.color!.replaceFirst('#', '0xFF')))
        : AppTheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: eventColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: eventColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 16, color: eventColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              event.title,
              style: TextStyle(
                fontSize: AppConstants.textSm,
                fontWeight: FontWeight.w600,
                color: eventColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final CalendarEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: AppConstants.text2xl,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.schedule_rounded,
              text: event.allDay
                  ? 'All Day'
                  : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
            ),
            if (event.location != null)
              _InfoRow(
                icon: Icons.location_on_rounded,
                text: event.location!,
              ),
            if (event.description != null)
              _InfoRow(
                icon: Icons.description_rounded,
                text: event.description!,
              ),
            if (event.notes != null)
              _InfoRow(
                icon: Icons.notes_rounded,
                text: event.notes!,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: AppConstants.textMd,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
