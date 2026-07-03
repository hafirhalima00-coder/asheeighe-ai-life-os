import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class RecurrencePicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const RecurrencePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const options = [
    _RecurrenceOption('none', 'None', Icons.not_interested),
    _RecurrenceOption('daily', 'Daily', Icons.daily),
    _RecurrenceOption('weekdays', 'Weekdays', Icons.weekend),
    _RecurrenceOption('weekly', 'Weekly', Icons.date_range),
    _RecurrenceOption('monthly', 'Monthly', Icons.calendar_month),
    _RecurrenceOption('yearly', 'Yearly', Icons.event),
    _RecurrenceOption('custom', 'Custom', Icons.tune),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt.value;
        return ChoiceChip(
          avatar: Icon(
            opt.icon,
            size: 16,
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textSecondary,
          ),
          label: Text(opt.label),
          selected: isSelected,
          onSelected: (_) => onChanged(opt.value),
          selectedColor: AppTheme.primaryLight,
          backgroundColor: Colors.grey[50],
          side: BorderSide.none,
          labelStyle: TextStyle(
            fontSize: 12,
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textPrimary,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}

class _RecurrenceOption {
  final String value;
  final String label;
  final IconData icon;

  const _RecurrenceOption(this.value, this.label, this.icon);
}
