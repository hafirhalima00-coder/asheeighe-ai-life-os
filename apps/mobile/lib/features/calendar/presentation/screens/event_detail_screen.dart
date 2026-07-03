import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/calendar_event.dart';
import '../providers/calendar_provider.dart';
import '../widgets/event_create_sheet.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final event = state.events.where((e) => e.id == eventId).firstOrNull;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Not Found')),
        body: const Center(child: Text('Event not found')),
      );
    }

    final eventColor = event.color != null
        ? Color(int.parse(event.color!.replaceFirst('#', '0xFF')))
        : AppTheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      eventColor.withOpacity(0.7),
                      eventColor.withOpacity(0.3),
                      AppTheme.background,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 80,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: AppConstants.text3xl,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (!event.allDay) ...[
                                const Icon(Icons.schedule_rounded,
                                    size: 16, color: AppTheme.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                                  style: const TextStyle(
                                    fontSize: AppConstants.textSm,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                              const Icon(Icons.event_rounded,
                                  size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMM d, yyyy').format(event.startTime),
                                style: const TextStyle(
                                  fontSize: AppConstants.textSm,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => EventCreateSheet(existingEvent: event),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () => _confirmDelete(context, ref, event),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _InfoCard(
                  children: [
                    if (event.description != null) ...[
                      _InfoRow(
                        icon: Icons.description_rounded,
                        label: 'Description',
                        value: event.description!,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _InfoRow(
                      icon: Icons.schedule_rounded,
                      label: 'Duration',
                      value: event.allDay
                          ? 'All Day'
                          : '${_formatDuration(event.duration)}',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.repeat_rounded,
                      label: 'Recurrence',
                      value: event.recurrence.name[0].toUpperCase() +
                          event.recurrence.name.substring(1),
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        label: 'Location',
                        value: event.location!,
                      ),
                    ],
                    if (event.url != null) ...[
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.link_rounded,
                        label: 'URL',
                        value: event.url!,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  children: [
                    const Text(
                      'Reminders',
                      style: TextStyle(
                        fontSize: AppConstants.textMd,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (event.reminders.isEmpty)
                      const Text(
                        'No reminders set',
                        style: TextStyle(
                          fontSize: AppConstants.textSm,
                          color: AppTheme.textSecondary,
                        ),
                      )
                    else
                      ...event.reminders.map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  r.isEnabled
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_off_rounded,
                                  size: 18,
                                  color: r.isEnabled
                                      ? AppTheme.primary
                                      : AppTheme.textHint,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${r.minutesBefore} min before',
                                  style: TextStyle(
                                    fontSize: AppConstants.textSm,
                                    color: r.isEnabled
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: eventColor.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            event.calendarType.name[0].toUpperCase() +
                                event.calendarType.name.substring(1),
                            style: TextStyle(
                              fontSize: AppConstants.textSm,
                              fontWeight: FontWeight.w600,
                              color: eventColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: event.isCompleted
                                ? AppTheme.success.withOpacity(0.15)
                                : AppTheme.warning.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            event.isCompleted ? 'Completed' : 'Active',
                            style: TextStyle(
                              fontSize: AppConstants.textSm,
                              fontWeight: FontWeight.w600,
                              color: event.isCompleted
                                  ? AppTheme.success
                                  : AppTheme.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(calendarProvider.notifier).deleteEvent(event.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours >= 1) {
      final hours = d.inHours;
      final minutes = d.inMinutes.remainder(60);
      return '${hours}h ${minutes}min';
    }
    return '${d.inMinutes}min';
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppConstants.textXs,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppConstants.textMd,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
