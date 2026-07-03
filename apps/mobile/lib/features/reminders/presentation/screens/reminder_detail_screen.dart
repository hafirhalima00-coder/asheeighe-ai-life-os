import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/create_reminder_usecase.dart';
import '../providers/reminder_provider.dart';
import '../widgets/recurrence_picker.dart';

class ReminderDetailScreen extends ConsumerStatefulWidget {
  final Reminder? reminder;

  const ReminderDetailScreen({super.key, this.reminder});

  @override
  ConsumerState<ReminderDetailScreen> createState() =>
      _ReminderDetailScreenState();
}

class _ReminderDetailScreenState
    extends ConsumerState<ReminderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _scheduledAt;
  late bool _recurring;
  late String? _recurrenceRule;
  late String? _category;
  late int _priority;
  late String _selectedRecurrence;

  final _categories = [
    'General',
    'Health',
    'Work',
    'Study',
    'Personal',
    'Finance'
  ];
  final _priorities = [0, 1, 2, 3];

  bool get isEditing => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    _titleController = TextEditingController(text: r?.title ?? '');
    _descriptionController =
        TextEditingController(text: r?.description ?? '');
    _scheduledAt = r?.scheduledAt ??
        DateTime.now().add(const Duration(hours: 1));
    _recurring = r?.recurring ?? false;
    _recurrenceRule = r?.recurrenceRule;
    _category = r?.category ?? 'General';
    _priority = r?.priority ?? 0;
    _selectedRecurrence = _recurrenceRule ?? 'none';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Reminder' : 'New Reminder'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteReminder,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveReminder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSectionTitle('Schedule'),
              const SizedBox(height: 12),
              _buildDateTimePicker(),
              const SizedBox(height: 24),
              _buildSectionTitle('Repeat'),
              const SizedBox(height: 12),
              RecurrencePicker(
                selected: _selectedRecurrence,
                onChanged: (value) {
                  setState(() {
                    _selectedRecurrence = value;
                    _recurring = value != 'none';
                    _recurrenceRule =
                        value == 'none' ? null : value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Category'),
              const SizedBox(height: 12),
              _buildCategorySelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('Priority'),
              const SizedBox(height: 12),
              _buildPrioritySelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter reminder title',
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Title is required' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Add a description',
        alignLabelWithHint: true,
      ),
      maxLines: 3,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today,
            color: AppTheme.primary),
        title: Text(
          DateFormat('MMM dd, yyyy').format(_scheduledAt),
        ),
        subtitle: Text(
          DateFormat('hh:mm a').format(_scheduledAt),
        ),
        trailing: const Icon(Icons.edit),
        onTap: _pickDateTime,
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final selected = _category == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: selected,
              onSelected: (_) =>
                  setState(() => _category = cat),
              selectedColor: AppTheme.primaryLight,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: _priorities.map((p) {
        final labels = ['None', 'Low', 'Medium', 'High'];
        final colors = [
          AppTheme.textHint,
          AppTheme.success,
          AppTheme.warning,
          AppTheme.error,
        ];
        final selected = _priority == p;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(labels[p]),
            selected: selected,
            onSelected: (_) =>
                setState(() => _priority = p),
            selectedColor: colors[p].withOpacity(0.2),
            labelStyle: TextStyle(
              color: selected ? colors[p] : null,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    final updated = Reminder(
      id: widget.reminder?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduledAt: _scheduledAt,
      recurring: _recurring,
      recurrenceRule: _recurrenceRule,
      enabled: true,
      category: _category,
      priority: _priority,
      createdAt: widget.reminder?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEditing) {
      ref
          .read(reminderProvider.notifier)
          .updateReminder(updated);
    } else {
      ref.read(reminderProvider.notifier).createReminder(
            CreateReminderParams(
              title: updated.title,
              description: updated.description,
              scheduledAt: updated.scheduledAt,
              recurring: updated.recurring,
              recurrenceRule: updated.recurrenceRule,
              category: updated.category,
              priority: updated.priority,
            ),
          );
    }
    Navigator.pop(context);
  }

  void _deleteReminder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text(
            'Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(reminderProvider.notifier)
                  .deleteReminder(widget.reminder!.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
