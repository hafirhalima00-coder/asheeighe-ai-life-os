import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/calendar_event.dart';
import '../providers/calendar_provider.dart';

class EventCreateSheet extends ConsumerStatefulWidget {
  final CalendarEvent? existingEvent;

  const EventCreateSheet({super.key, this.existingEvent});

  @override
  ConsumerState<EventCreateSheet> createState() => _EventCreateSheetState();
}

class _EventCreateSheetState extends ConsumerState<EventCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _descriptionCtrl;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _allDay;
  late String _selectedColor;
  late Recurrence _recurrence;
  late CalendarType _calendarType;
  bool _isSaving = false;

  final _pastelColors = [
    '#FF6B9D',
    '#A78BFA',
    '#60A5FA',
    '#34D399',
    '#F472B6',
    '#FBBF24',
    '#FB923C',
    '#E879F9',
  ];

  bool get _isEditing => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    final event = widget.existingEvent;
    _titleCtrl = TextEditingController(text: event?.title ?? '');
    _locationCtrl = TextEditingController(text: event?.location ?? '');
    _notesCtrl = TextEditingController(text: event?.notes ?? '');
    _descriptionCtrl = TextEditingController(text: event?.description ?? '');
    _startDate = event?.startTime ?? DateTime.now();
    _endDate = event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    _startTime = TimeOfDay.fromDateTime(event?.startTime ?? DateTime.now());
    _endTime = TimeOfDay.fromDateTime(
        event?.endTime ?? DateTime.now().add(const Duration(hours: 1)));
    _allDay = event?.allDay ?? false;
    _selectedColor = event?.color ?? _pastelColors[0];
    _recurrence = event?.recurrence ?? Recurrence.none;
    _calendarType = event?.calendarType ?? CalendarType.personal;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusXl)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'Edit Event' : 'New Event',
                      style: const TextStyle(
                        fontSize: AppConstants.textXl,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Event title',
                        prefixIcon: Icon(Icons.event_rounded,
                            size: 20, color: AppTheme.textHint),
                      ),
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Date & Time'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DatePickerField(
                            label: 'Start',
                            date: _startDate,
                            time: _startTime,
                            onTap: () => _pickDateTime(true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePickerField(
                            label: 'End',
                            date: _endDate,
                            time: _endTime,
                            onTap: () => _pickDateTime(false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          height: AppConstants.heightMd,
                          child: Switch(
                            value: _allDay,
                            onChanged: (v) => setState(() => _allDay = v),
                            activeColor: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'All Day',
                          style: TextStyle(
                            fontSize: AppConstants.textSm,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Location'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _locationCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Add location',
                        prefixIcon: Icon(Icons.location_on_rounded,
                            size: 20, color: AppTheme.textHint),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Add description',
                        prefixIcon: Icon(Icons.description_rounded,
                            size: 20, color: AppTheme.textHint),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Color'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _pastelColors.map((colorHex) {
                        final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                        final isSelected = _selectedColor == colorHex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = colorHex),
                          child: AnimatedContainer(
                            duration: AppConstants.durationFast,
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: AppTheme.textPrimary, width: 2.5)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                    size: 18, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Recurrence'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Recurrence>(
                          value: _recurrence,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more_rounded),
                          items: Recurrence.values.map((r) {
                            return DropdownMenuItem(
                              value: r,
                              child: Text(
                                r.name[0].toUpperCase() + r.name.substring(1),
                                style: const TextStyle(
                                  fontSize: AppConstants.textMd,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _recurrence = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Calendar Type'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CalendarType>(
                          value: _calendarType,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more_rounded),
                          items: CalendarType.values.map((ct) {
                            return DropdownMenuItem(
                              value: ct,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: calendarTypeColors[ct],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    calendarTypeLabels[ct] ?? ct.name,
                                    style: const TextStyle(
                                      fontSize: AppConstants.textMd,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _calendarType = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Notes'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Additional notes',
                        prefixIcon: Icon(Icons.notes_rounded,
                            size: 20, color: AppTheme.textHint),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingMd, 8, AppConstants.paddingMd, 24),
            decoration: BoxDecoration(
              color: AppTheme.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.divider),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppConstants.textSm,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final now = DateTime.now();
    final initialDate = isStart ? _startDate : _endDate;
    final initialTime = isStart ? _startTime : _endTime;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    setState(() {
      final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _startDate = dt;
        _startTime = time;
        if (_endDate.isBefore(dt)) {
          _endDate = dt.add(const Duration(hours: 1));
          _endTime = TimeOfDay.fromDateTime(_endDate);
        }
      } else {
        _endDate = dt;
        _endTime = time;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final startDt = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDt = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    final notifier = ref.read(calendarProvider.notifier);

    if (_isEditing) {
      final updated = widget.existingEvent!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        startTime: startDt,
        endTime: endDt,
        allDay: _allDay,
        color: _selectedColor,
        location: _locationCtrl.text.trim().isEmpty
            ? null
            : _locationCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        recurrence: _recurrence,
        calendarType: _calendarType,
        updatedAt: DateTime.now(),
      );
      await notifier.updateEvent(updated);
    } else {
      await notifier.createEvent(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        startTime: startDt,
        endTime: endDt,
        allDay: _allDay,
        color: _selectedColor,
        location:
            _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        recurrence: _recurrence,
        calendarType: _calendarType,
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.textXs,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d').format(date),
              style: const TextStyle(
                fontSize: AppConstants.textMd,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              time.format(context),
              style: const TextStyle(
                fontSize: AppConstants.textXs,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
