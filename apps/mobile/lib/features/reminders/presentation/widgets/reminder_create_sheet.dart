import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/create_reminder_usecase.dart';
import '../providers/reminder_provider.dart';

class ReminderCreateSheet extends ConsumerStatefulWidget {
  const ReminderCreateSheet({super.key});

  @override
  ConsumerState<ReminderCreateSheet> createState() =>
      _ReminderCreateSheetState();
}

class _ReminderCreateSheetState
    extends ConsumerState<ReminderCreateSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDateTime =
        DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXl)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'New Reminder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Reminder title',
                hintText: 'What would you like to be reminded about?',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Pick',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickPicks(),
            const SizedBox(height: 8),
            if (_selectedDateTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 16, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy - hh:mm a')
                          .format(_selectedDateTime!),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createReminder,
                child: const Text('Create Reminder'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPicks() {
    final now = DateTime.now();
    final picks = [
      _QuickPick(
        'In 15 min',
        now.add(const Duration(minutes: 15)),
        Icons.timer_outlined,
      ),
      _QuickPick(
        'In 1 hour',
        now.add(const Duration(hours: 1)),
        Icons.schedule,
      ),
      _QuickPick(
        'Tonight 9 PM',
        DateTime(now.year, now.month, now.day, 21),
        Icons.nightlight_outlined,
      ),
      _QuickPick(
        'Tomorrow 9 AM',
        DateTime(now.year, now.month, now.day + 1, 9),
        Icons.wb_sunny_outlined,
      ),
      _QuickPick(
        'Pick date & time',
        null,
        Icons.calendar_today,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: picks.map((pick) {
        final selected = _selectedDateTime == pick.dateTime;
        return ActionChip(
          avatar: Icon(
            pick.icon,
            size: 16,
            color: selected ? AppTheme.primary : AppTheme.textSecondary,
          ),
          label: Text(
            pick.label,
            style: TextStyle(
              fontSize: 12,
              color:
                  selected ? AppTheme.primary : AppTheme.textPrimary,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (pick.dateTime != null) {
              setState(
                  () => _selectedDateTime = pick.dateTime);
            } else {
              _pickDateTime();
            }
          },
          backgroundColor:
              selected ? AppTheme.primaryLight : Colors.grey[100],
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now()),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _createReminder() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    ref.read(reminderProvider.notifier).createReminder(
          CreateReminderParams(
            title: title,
            description:
                _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
            scheduledAt: _selectedDateTime ??
                DateTime.now()
                    .add(const Duration(hours: 1)),
          ),
        );
    Navigator.pop(context);
  }
}

class _QuickPick {
  final String label;
  final DateTime? dateTime;
  final IconData icon;

  const _QuickPick(this.label, this.dateTime, this.icon);
}
