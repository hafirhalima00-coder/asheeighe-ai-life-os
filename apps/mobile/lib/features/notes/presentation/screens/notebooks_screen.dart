import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/notebook.dart';

class NotebooksScreen extends ConsumerStatefulWidget {
  const NotebooksScreen({super.key});

  @override
  ConsumerState<NotebooksScreen> createState() =>
      _NotebooksScreenState();
}

class _NotebooksScreenState
    extends ConsumerState<NotebooksScreen> {
  final _notebooks = <Notebook>[
    const Notebook(
        id: '1',
        name: 'Personal',
        icon: 'person',
        color: '#FF6B9D',
        noteCount: 5),
    const Notebook(
        id: '2',
        name: 'Work',
        icon: 'work',
        color: '#6C63FF',
        noteCount: 3),
    const Notebook(
        id: '3',
        name: 'Study',
        icon: 'school',
        color: '#4CAF50',
        noteCount: 8),
    const Notebook(
        id: '4',
        name: 'Ideas',
        icon: 'lightbulb',
        color: '#FFD93D',
        noteCount: 12),
  ];

  final _icons = [
    'folder', 'person', 'work', 'school', 'lightbulb',
    'favorite', 'star', 'home', 'menu_book', 'music_note',
    'shopping_cart', 'flight', 'fitness_center', 'palette',
  ];

  final _colors = [
    '#FF6B9D', '#6C63FF', '#4CAF50', '#FFD93D', '#FF9800',
    '#E040FB', '#00BCD4', '#795548', '#607D8B', '#F44336',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notebooks')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: _notebooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined,
                      size: 64,
                      color: AppTheme.textHint),
                  const SizedBox(height: 16),
                  const Text(
                    'No notebooks yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a notebook to organize your notes',
                    style:
                        TextStyle(color: AppTheme.textHint),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(
                  AppConstants.paddingMd),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _notebooks.length,
              itemBuilder: (ctx, i) =>
                  _buildNotebookCard(_notebooks[i]),
            ),
    );
  }

  Widget _buildNotebookCard(Notebook notebook) {
    final colorHex = Color(
        int.parse(notebook.color.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () {},
      onLongPress: () =>
          _showEditDialog(notebook),
      child: Card(
        elevation: 0,
        color: colorHex.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                _getIconData(notebook.icon),
                color: colorHex,
                size: 28,
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    notebook.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${notebook.noteCount} notes',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'folder':
        return Icons.folder;
      case 'person':
        return Icons.person;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'home':
        return Icons.home;
      case 'menu_book':
        return Icons.menu_book;
      case 'music_note':
        return Icons.music_note;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'flight':
        return Icons.flight;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'palette':
        return Icons.palette;
      default:
        return Icons.folder;
    }
  }

  void _showCreateDialog() {
    _showNotebookDialog();
  }

  void _showEditDialog(Notebook notebook) {
    _showNotebookDialog(notebook: notebook);
  }

  void _showNotebookDialog({Notebook? notebook}) {
    final nameController =
        TextEditingController(text: notebook?.name ?? '');
    String selectedIcon = notebook?.icon ?? 'folder';
    String selectedColor = notebook?.color ?? _colors[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
              notebook != null ? 'Edit Notebook' : 'New Notebook'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Notebook name',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Icon',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,
                    children: _icons.map((icon) {
                      final selected =
                          icon == selectedIcon;
                      return GestureDetector(
                        onTap: () => setDialogState(
                            () => selectedIcon =
                                icon),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets
                              .only(right: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primaryLight
                                : Colors.grey[100],
                            borderRadius:
                                BorderRadius.circular(
                                    8),
                            border: selected
                                ? Border.all(
                                    color: AppTheme
                                        .primary,
                                    width: 2)
                                : null,
                          ),
                          child: Icon(
                            _getIconData(icon),
                            size: 20,
                            color: selected
                                ? AppTheme.primary
                                : AppTheme
                                    .textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Color',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colors.map((c) {
                    final hexColor = Color(
                        int.parse(c.replaceFirst(
                            '#', '0xFF')));
                    final selected =
                        c == selectedColor;
                    return GestureDetector(
                      onTap: () => setDialogState(
                          () => selectedColor = c),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: hexColor,
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(
                                  color:
                                      AppTheme.textPrimary,
                                  width: 2.5)
                              : null,
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(ctx),
              child:
                  const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
