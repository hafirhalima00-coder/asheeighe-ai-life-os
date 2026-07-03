import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../providers/note_provider.dart';
import '../widgets/notebook_selector.dart';
import '../widgets/note_toolbar.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  ConsumerState<NoteDetailScreen> createState() =>
      _NoteDetailScreenState();
}

class _NoteDetailScreenState
    extends ConsumerState<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _color;
  late String? _notebookId;
  late List<String> _tags;
  late NoteType _type;
  late List<_ChecklistItem> _checklistItems;
  Timer? _debounceTimer;

  final _pastelColors = [
    '#FFF5F5', '#FFF0F6', '#F3E8FF', '#E8F5FF',
    '#E0F7FA', '#E8F5E9', '#FFF8E1', '#FBE9E7',
    '#F5F5F5', '#FCE4EC',
  ];

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _titleController = TextEditingController(text: n?.title ?? '');
    _contentController =
        TextEditingController(text: n?.content ?? '');
    _color = n?.color ?? _pastelColors[0];
    _notebookId = n?.notebookId;
    _tags = n?.tags ?? [];
    _type = n?.type ?? NoteType.text;
    _checklistItems = [];
    if (n?.type == NoteType.checklist && n?.content != null) {
      _checklistItems = n!.content
          .split('\n')
          .where((l) => l.isNotEmpty)
          .map((l) => _ChecklistItem(
              l.startsWith('[x]'),
              l.replaceAll(RegExp(r'^\[[ x]\] '), '')))
          .toList();
    }

    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.removeListener(_onContentChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(seconds: 1),
      _autoSave,
    );
  }

  void _autoSave() {
    if (!isEditing) return;
    if (_titleController.text.trim().isEmpty) return;
    ref.read(noteProvider.notifier).updateNote(
          Note(
            id: widget.note!.id,
            title: _titleController.text.trim(),
            content: _getContent(),
            type: _type,
            notebookId: _notebookId,
            tags: _tags,
            color: _color,
            isPinned: widget.note!.isPinned,
            createdAt: widget.note!.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
  }

  String _getContent() {
    if (_type == NoteType.checklist) {
      return _checklistItems
          .map((i) =>
              '${i.checked ? '[x]' : '[ ]'} ${i.text}')
          .join('\n');
    }
    return _contentController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing) ...[
            IconButton(
              icon: Icon(
                widget.note!.isPinned
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
                color: widget.note!.isPinned
                    ? AppTheme.primary
                    : null,
              ),
              onPressed: () {
                ref
                    .read(noteProvider.notifier)
                    .togglePin(widget.note!);
              },
            ),
            IconButton(
              icon: Icon(
                widget.note!.isArchived
                    ? Icons.unarchive
                    : Icons.archive_outlined,
              ),
              onPressed: () {
                ref
                    .read(noteProvider.notifier)
                    .toggleArchive(widget.note!);
              },
            ),
          ],
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _deleteNote();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColorPicker(),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textHint,
                ),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEditing
                  ? 'Last edited ${_formatDate(widget.note!.updatedAt)}'
                  : 'Just now',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
            const SizedBox(height: 16),
            NoteToolbar(
              onBold: () {},
              onItalic: () {},
              onChecklist: () {
                setState(() {
                  if (_type == NoteType.checklist) {
                    _type = NoteType.text;
                  } else {
                    _type = NoteType.checklist;
                  }
                });
              },
              onImage: () {},
              onVoice: () {},
              isChecklistMode: _type == NoteType.checklist,
            ),
            const SizedBox(height: 16),
            if (_type == NoteType.checklist)
              _buildChecklistEditor()
            else
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: AppTheme.textPrimary,
                ),
              ),
            const SizedBox(height: 24),
            Divider(color: AppTheme.divider),
            const SizedBox(height: 12),
            NotebookSelector(
              selectedId: _notebookId,
              onChanged: (id) =>
                  setState(() => _notebookId = id),
            ),
            const SizedBox(height: 12),
            _buildTagsInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _pastelColors.map((c) {
          final hexColor = Color(
              int.parse(c.replaceFirst('#', '0xFF')));
          final selected = _color == c;
          return GestureDetector(
            onTap: () => setState(() => _color = c),
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: hexColor,
                shape: BoxShape.circle,
                border: selected
                    ? Border.all(
                        color: AppTheme.primary,
                        width: 2.5)
                    : Border.all(
                        color: AppTheme.divider),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color:
                              AppTheme.primary.withOpacity(0.3),
                          blurRadius: 6,
                        )
                      ]
                    : null,
              ),
              child: selected
                  ? const Icon(Icons.check,
                      size: 16, color: AppTheme.primary)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChecklistEditor() {
    return Column(
      children: [
        ..._checklistItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return CheckboxListTile(
            value: item.checked,
            onChanged: (v) {
              setState(() {
                _checklistItems[i] = _ChecklistItem(
                    v ?? false, item.text);
                _onContentChanged();
              });
            },
            title: TextField(
              controller: TextEditingController(
                  text: item.text),
              decoration:
                  const InputDecoration(border: InputBorder.none),
              onChanged: (v) {
                _checklistItems[i] = _ChecklistItem(
                    item.checked, v);
                _onContentChanged();
              },
            ),
            dense: true,
            controlAffinity:
                ListTileControlAffinity.leading,
          );
        }),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _checklistItems.add(
                  _ChecklistItem(false, ''));
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add item'),
        ),
      ],
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ..._tags.map((tag) => Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() =>
                        _tags.remove(tag));
                  },
                  backgroundColor:
                      AppTheme.primaryLight.withOpacity(0.4),
                  side: BorderSide.none,
                )),
            ActionChip(
              label: const Text('+ Add',
                  style: TextStyle(fontSize: 12)),
              onPressed: _addTag,
              backgroundColor: Colors.grey[100],
              side: BorderSide.none,
            ),
          ],
        ),
      ],
    );
  }

  void _addTag() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter tag name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final tag =
                    controller.text.trim();
                if (tag.isNotEmpty &&
                    !_tags.contains(tag)) {
                  setState(
                      () => _tags.add(tag));
                }
                Navigator.pop(ctx);
              },
              child:
                  const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            const Text('Delete Note'),
        content: const Text(
            'Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx),
            child:
                const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(noteProvider
                      .notifier)
                  .deleteNote(widget
                      .note!.id);
              Navigator.pop(ctx);
              Navigator.pop(
                  context);
            },
            child: const Text('Delete',
                style: TextStyle(
                    color:
                        AppTheme.error)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return DateFormat('MMM dd').format(date);
  }
}

class _ChecklistItem {
  final bool checked;
  final String text;

  const _ChecklistItem(this.checked, this.text);
}
