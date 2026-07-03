import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class NoteToolbar extends StatelessWidget {
  final VoidCallback? onBold;
  final VoidCallback? onItalic;
  final VoidCallback? onChecklist;
  final VoidCallback? onImage;
  final VoidCallback? onVoice;
  final bool isChecklistMode;

  const NoteToolbar({
    super.key,
    this.onBold,
    this.onItalic,
    this.onChecklist,
    this.onImage,
    this.onVoice,
    this.isChecklistMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            onPressed: onBold,
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.format_italic,
            onPressed: onItalic,
          ),
          const SizedBox(width: 4),
          Container(
            width: 1,
            height: 24,
            color: AppTheme.divider,
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.checklist,
            onPressed: onChecklist,
            isActive: isChecklistMode,
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.image_outlined,
            onPressed: onImage,
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.mic_outlined,
            onPressed: onVoice,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive
          ? AppTheme.primaryLight
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: isActive
                ? AppTheme.primary
                : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
