import 'package:flutter/material.dart';

enum AsheeigheChipVariant { filter, choice, input }

class AsheeigheChip extends StatelessWidget {
  final AsheeigheChipVariant variant;
  final String label;
  final IconData? icon;
  final bool selected;
  final bool enabled;
  final VoidCallback? onSelected;
  final VoidCallback? onDeleted;
  final Color? selectedColor;
  final Color? color;

  const AsheeigheChip({
    super.key,
    this.variant = AsheeigheChipVariant.filter,
    required this.label,
    this.icon,
    this.selected = false,
    this.enabled = true,
    this.onSelected,
    this.onDeleted,
    this.selectedColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chipColor = color ??
        (isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerHighest);
    final selectedChipColor =
        selectedColor ?? theme.colorScheme.primaryContainer;

    switch (variant) {
      case AsheeigheChipVariant.filter:
        return _filterChip(theme, chipColor, selectedChipColor);
      case AsheeigheChipVariant.choice:
        return _choiceChip(theme, chipColor, selectedChipColor);
      case AsheeigheChipVariant.input:
        return _inputChip(theme, chipColor);
    }
  }

  Widget _filterChip(ThemeData theme, Color chipColor, Color selectedChipColor) {
    return FilterChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      selected: selected,
      onSelected: enabled ? onSelected : null,
      selectedColor: selectedChipColor,
      backgroundColor: chipColor,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _choiceChip(ThemeData theme, Color chipColor, Color selectedChipColor) {
    return ChoiceChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      selected: selected,
      onSelected: enabled ? onSelected : null,
      selectedColor: selectedChipColor,
      backgroundColor: chipColor,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _inputChip(ThemeData theme, Color chipColor) {
    return InputChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      selected: selected,
      onSelected: enabled ? onSelected : null,
      onDeleted: enabled ? onDeleted : null,
      backgroundColor: chipColor,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: theme.textTheme.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
