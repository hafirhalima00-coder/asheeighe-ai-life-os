import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_indicator.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _tagsCtrl;
  late DateTime? _dueDate;
  late TaskPriority _priority;
  late TaskStatus _status;
  late String? _category;
  late bool _hasReminder;
  late int? _estimatedMinutes;
  late bool _isEditing;
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
    _isEditing = false;
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _tagsCtrl = TextEditingController();
    _dueDate = null;
    _priority = TaskPriority.medium;
    _status = TaskStatus.todo;
    _category = null;
    _hasReminder = false;
    _estimatedMinutes = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(taskProvider);
      final task = state.tasks.where((t) => t.id == widget.taskId).firstOrNull;
      if (task != null) {
        setState(() {
          _titleCtrl.text = task.title;
          _descCtrl.text = task.description ?? '';
          _tagsCtrl.text = task.tags.join(', ');
          _dueDate = task.dueDate;
          _priority = task.priority;
          _status = task.status;
          _category = task.category;
          _hasReminder = task.reminderTime != null;
          _estimatedMinutes = task.estimatedMinutes;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskProvider);
    final task = state.tasks.where((t) => t.id == widget.taskId).firstOrNull;

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Not Found')),
        body: const Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getPriorityGradientColor(task.priority).withOpacity(0.6),
                      AppTheme.background,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 80,
                      left: 20,
                      right: 20,
                      child: _isEditing
                          ? TextFormField(
                              controller: _titleCtrl,
                              style: const TextStyle(
                                fontSize: AppConstants.text2xl,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Task title',
                              ),
                            )
                          : Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: AppConstants.text2xl,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded),
                onPressed: () {
                  if (_isEditing) _save(task);
                  setState(() => _isEditing = !_isEditing);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () => _confirmDelete(task),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatusSection(task),
                const SizedBox(height: 16),
                _buildInfoCard('Details', [
                  _buildPickerRow(
                    icon: Icons.flag_rounded,
                    label: 'Priority',
                    child: _isEditing
                        ? _buildPrioritySelector()
                        : Row(
                            children: [
                              PriorityIndicator(priority: task.priority, showLabel: true),
                            ],
                          ),
                  ),
                  const Divider(height: 24),
                  _buildPickerRow(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    child: _isEditing
                        ? _buildCategoryDropdown()
                        : Text(
                            task.category ?? 'None',
                            style: const TextStyle(
                              fontSize: AppConstants.textMd,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                  ),
                  const Divider(height: 24),
                  _buildPickerRow(
                    icon: Icons.event_rounded,
                    label: 'Due Date',
                    child: _isEditing
                        ? GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusSm),
                              ),
                              child: Text(
                                _dueDate != null
                                    ? DateFormat('MMM d, yyyy')
                                        .format(_dueDate!)
                                    : 'Set due date',
                                style: TextStyle(
                                  fontSize: AppConstants.textMd,
                                  color: _dueDate != null
                                      ? AppTheme.textPrimary
                                      : AppTheme.textHint,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            task.dueDate != null
                                ? DateFormat('MMM d, yyyy').format(task.dueDate!)
                                : 'No due date',
                            style: const TextStyle(
                              fontSize: AppConstants.textMd,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                  ),
                  const Divider(height: 24),
                  _buildPickerRow(
                    icon: Icons.timer_rounded,
                    label: 'Est. Time',
                    child: _isEditing
                        ? SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: _estimatedMinutes?.toString() ?? '',
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'min',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (v) => _estimatedMinutes =
                                  int.tryParse(v),
                            ),
                          )
                        : Text(
                            task.estimatedMinutes != null
                                ? '${task.estimatedMinutes} min'
                                : 'Not set',
                            style: const TextStyle(
                              fontSize: AppConstants.textMd,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Description', [
                  _isEditing
                      ? TextFormField(
                          controller: _descCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Add description',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          task.description ?? 'No description',
                          style: TextStyle(
                            fontSize: AppConstants.textMd,
                            color: task.description != null
                                ? AppTheme.textPrimary
                                : AppTheme.textHint,
                          ),
                        ),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Tags', [
                  _isEditing
                      ? TextFormField(
                          controller: _tagsCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Comma separated tags',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : task.tags.isNotEmpty
                          ? Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: task.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusFull),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: AppConstants.textXs,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Text(
                              'No tags',
                              style: TextStyle(
                                fontSize: AppConstants.textSm,
                                color: AppTheme.textHint,
                              ),
                            ),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Subtasks', [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.parentTaskId != null
                              ? 'Part of another task'
                              : 'This task has no subtasks',
                          style: const TextStyle(
                            fontSize: AppConstants.textSm,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Task task) {
    return Container(
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
      child: Row(
        children: TaskStatus.values
            .where((s) => s != TaskStatus.archived)
            .map((status) {
          final isSelected = (_isEditing ? _status : task.status) == status;
          final labels = {
            TaskStatus.todo: 'To Do',
            TaskStatus.inProgress: 'In Progress',
            TaskStatus.done: 'Done',
          };
          return Expanded(
            child: GestureDetector(
              onTap: _isEditing
                  ? () => setState(() => _status = status)
                  : null,
              child: AnimatedContainer(
                duration: AppConstants.durationFast,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getStatusColor(status).withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      size: 20,
                      color: isSelected
                          ? _getStatusColor(status)
                          : AppTheme.textHint,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[status] ?? status.name,
                      style: TextStyle(
                        fontSize: AppConstants.textXs,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? _getStatusColor(status)
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
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
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
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppConstants.textMd,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPickerRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppConstants.textSm,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = _priority == p;
        final colors = PriorityIndicator.priorityColors;
        return GestureDetector(
          onTap: () => setState(() => _priority = p),
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? colors[p]!.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              border: isSelected
                  ? Border.all(color: colors[p]!)
                  : null,
            ),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colors[p],
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _category,
          isExpanded: true,
          icon: const Icon(Icons.expand_more_rounded, size: 18),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('None',
                  style: TextStyle(fontSize: AppConstants.textSm)),
            ),
            ..._categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c,
                      style: const TextStyle(fontSize: AppConstants.textSm)),
                )),
          ],
          onChanged: (v) => setState(() => _category = v),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _save(Task originalTask) async {
    if (_titleCtrl.text.trim().isEmpty) return;

    final updated = originalTask.copyWith(
      title: _titleCtrl.text.trim(),
      description:
          _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      status: _status,
      category: _category,
      tags: _tagsCtrl.text.isNotEmpty
          ? _tagsCtrl.text.split(',').map((t) => t.trim()).toList()
          : [],
      estimatedMinutes: _estimatedMinutes,
      updatedAt: DateTime.now(),
    );

    await ref.read(taskProvider.notifier).updateTask(updated);
  }

  void _confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
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

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppTheme.textSecondary;
      case TaskStatus.inProgress:
        return AppTheme.warning;
      case TaskStatus.done:
        return AppTheme.success;
      case TaskStatus.archived:
        return AppTheme.textHint;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked_rounded;
      case TaskStatus.inProgress:
        return Icons.play_circle_rounded;
      case TaskStatus.done:
        return Icons.check_circle_rounded;
      case TaskStatus.archived:
        return Icons.archive_rounded;
    }
  }

  Color _getPriorityGradientColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF86EFAC);
      case TaskPriority.medium:
        return const Color(0xFF93C5FD);
      case TaskPriority.high:
        return const Color(0xFFFCD34D);
      case TaskPriority.urgent:
        return const Color(0xFFFDA4AF);
    }
  }
}
