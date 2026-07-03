import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class NotebookSelector extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const NotebookSelector({
    super.key,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.book_outlined,
            size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        const Text(
          'Notebook:',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        ActionChip(
          label: Text(
            selectedId != null ? 'Selected Notebook' : 'None',
            style: const TextStyle(fontSize: 12),
          ),
          onPressed: () => _showNotebookPicker(context),
          backgroundColor: AppTheme.primaryLight.withOpacity(0.3),
          side: BorderSide.none,
          avatar: selectedId != null
              ? const Icon(Icons.check,
                  size: 14, color: AppTheme.primary)
              : const Icon(Icons.add,
                  size: 14, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  void _showNotebookPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16)),
      ),
      builder: (ctx) => SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Notebook',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                  Icons.block,
                  color:
                      AppTheme.textSecondary),
              title: const Text('None'),
              onTap: () {
                onChanged(null);
                Navigator.pop(ctx);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  // Notebook list would come from provider
                  ListTile(
                    leading: const Icon(Icons.folder,
                        color: AppTheme.primary),
                    title: const Text('Personal'),
                    subtitle:
                        const Text('5 notes'),
                    trailing: selectedId == '1'
                        ? const Icon(Icons.check,
                            color: AppTheme.primary)
                        : null,
                    onTap: () {
                      onChanged('1');
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
