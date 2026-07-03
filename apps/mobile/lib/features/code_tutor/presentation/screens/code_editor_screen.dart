import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import '../providers/code_tutor_provider.dart';
import '../widgets/code_block.dart';
import '../widgets/hint_panel.dart';
import '../../domain/entities/coding_lesson.dart';
import 'tutor_chat_screen.dart';

class CodeEditorScreen extends ConsumerStatefulWidget {
  final CodingLesson lesson;
  final String languageName;

  const CodeEditorScreen({
    super.key,
    required this.lesson,
    required this.languageName,
  });

  @override
  ConsumerState<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends ConsumerState<CodeEditorScreen> {
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.lesson.codeExample ?? '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(codeTutorProvider.notifier).updateCodeInput(
            widget.lesson.codeExample ?? '',
          );
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(codeTutorProvider);
    final notifier = ref.read(codeTutorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TutorChatScreen(),
                ),
              );
            },
            tooltip: 'Ask AI Tutor',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(
                  _lessonTypeIcon(widget.lesson.type),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.description,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.lesson.typeDisplayName} · ${widget.lesson.estimatedMinutes} min · +${widget.lesson.xpReward} XP',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.code_rounded,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.languageName,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      onChanged: (value) => notifier.updateCodeInput(value),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.6,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Write your code here...',
                        hintStyle: TextStyle(color: Colors.white30),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (state.lastOutput.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: state.lastOutput.startsWith('✅')
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.lastOutput.startsWith('✅')
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Text(
                state.lastOutput,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: state.lastOutput.startsWith('✅')
                      ? Colors.green[800]
                      : Colors.orange[800],
                ),
              ),
            ),
          if (state.currentHint != null)
            HintPanel(
              hint: state.currentHint!,
              hintIndex: state.hintIndex,
              onShowNext: () => notifier.showNextHint(),
              onDismiss: () => notifier.clearHint(),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.showNextHint(),
                    icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                    label: const Text('Hint'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.runCode(),
                    icon: state.isRunning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Run Code'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => notifier.submitCode(),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _lessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.concept:
        return Icons.lightbulb_outline_rounded;
      case LessonType.exercise:
        return Icons.code_rounded;
      case LessonType.quiz:
        return Icons.quiz_rounded;
      case LessonType.project:
        return Icons.build_rounded;
    }
  }
}
