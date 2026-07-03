import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import 'priority_indicator.dart';

class TaskCreateSheet extends ConsumerStatefulWidget {
  final String? preSelectedCategory;

  const TaskCreateSheet({super.key, this.preSelectedCategory});

  @override
  ConsumerState<TaskCreateSheet> createState() => _TaskCreateSheetState();
}

class _TaskCreateSheetState extends ConsumerState<TaskCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _notesCtrl;
  late DateTime? _dueDate;
  late TimeOfDay? _dueTime;
  late TaskPriority _priority;
  late String? _category;
  bool _hasDueDate = false;
  bool _isSaving = false;

  final _categories = [
    'Work',
    'Personal',
    'Health',
    'Study',
    'Finance',
    'Shopping',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    _dueDate = null;
    _dueTime = null;
    _priority = TaskPriority.medium;
    _category = widget.preSelectedCategory;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingMd, 0, AppConstants.paddingMd, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Task',
                        style: TextStyle(
                          fontSize: AppConstants.textXl,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleCtrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                      prefixIcon: Icon(Icons.checklist_rounded,
                          size: 20, color: AppTheme.textHint),
                    ),
                    validator: (v) =>
                        v?.trim().isEmpty == true ? 'Task title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Due Date',
                    style: const TextStyle(
                      fontSize: AppConstants.textSm,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QuickDateButton(
                        label: 'Today',
                        isSelected: _hasDueDate &&
                            _dueDate != null &&
                            _dueDate!.isToday,
                        onTap: () {
                          setState(() {
                            _hasDueDate = true;
                            _dueDate = DateTime.now();
                            _dueTime = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _QuickDateButton(
                        label: 'Tomorrow',
                        isSelected: _hasDueDate &&
                            _dueDate != null &&
                            _dueDate!.isTomorrow,
                        onTap: () {
                          setState(() {
                            _hasDueDate = true;
                            _dueDate =
                                DateTime.now().add(const Duration(days: 1));
                            _dueTime = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _QuickDateButton(
                        label: 'Next Week',
                        isSelected: _hasDueDate &&
                            _dueDate != null &&
                            _dueDate!.isAfter(
                                DateTime.now().add(const Duration(days: 6))),
                        onTap: () {
                          setState(() {
                            _hasDueDate = true;
                            _dueDate = DateTime.now()
                                .add(const Duration(days: 7));
                            _dueTime = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _QuickDateButton(
                        label: 'Pick',
                        isSelected: false,
                        onTap: _pickCustomDate,
                      ),
                    ],
                  ),
                  if (_hasDueDate && _dueDate != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_rounded,
                              size: 16, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM d, yyyy').format(_dueDate!),
                            style: const TextStyle(
                              fontSize: AppConstants.textSm,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _hasDueDate = false),
                            child: const Icon(Icons.close_rounded,
                                size: 16, color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Priority',
                    style: const TextStyle(
                      fontSize: AppConstants.textSm,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: TaskPriority.values.map((p) {
                      final isSelected = _priority == p;
                      final colors = PriorityIndicator.priorityColors;
                      final labels = PriorityIndicator.priorityLabels;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _priority = p),
                          child: AnimatedContainer(
                            duration: AppConstants.durationFast,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors[p]!.withOpacity(0.3)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusSm),
                              border: Border.all(
                                color: isSelected
                                    ? colors[p]!
                                    : AppTheme.divider,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: colors[p],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  labels[p] ?? p.name,
                                  style: TextStyle(
                                    fontSize: AppConstants.textXs,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category',
                    style: const TextStyle(
                      fontSize: AppConstants.textSm,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: 'None',
                          isSelected: _category == null,
                          onTap: () => setState(() => _category = null),
                        ),
                        ..._categories.map((cat) => _CategoryChip(
                              label: cat,
                              isSelected: _category == cat,
                              onTap: () => setState(() => _category = cat),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Notes (optional)',
                      prefixIcon: Icon(Icons.notes_rounded,
                          size: 20, color: AppTheme.textHint),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
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
                              : const Text('Add Task'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (date != null) {
      setState(() {
        _hasDueDate = true;
        _dueDate = date;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    DateTime? dueDate;
    if (_hasDueDate && _dueDate != null) {
      dueDate = _dueDate!;
      if (_dueTime != null) {
        dueDate = DateTime(
          dueDate!.year,
          dueDate!.month,
          dueDate!.day,
          _dueTime!.hour,
          _dueTime!.minute,
        );
      }
    }

    await ref.read(taskProvider.notifier).createTask(
          title: _titleCtrl.text.trim(),
          description: _notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim(),
          dueDate: dueDate,
          priority: _priority,
          category: _category,
        );

    if (mounted) Navigator.pop(context);
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickDateButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.textXs,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryLight.withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.textXs,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
