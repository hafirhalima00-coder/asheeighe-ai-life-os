import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../providers/code_tutor_provider.dart';
import '../widgets/code_block.dart';

class TutorChatScreen extends ConsumerStatefulWidget {
  const TutorChatScreen({super.key});

  @override
  ConsumerState<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends ConsumerState<TutorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(codeTutorProvider);
    final notifier = ref.read(codeTutorProvider.notifier);
    final messages = state.currentSession?.messages ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('AI Code Tutor', style: TextStyle(fontSize: 16)),
            Text(
              state.currentLesson?.title ?? 'Ask me anything',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'explain':
                  notifier.setMode(TutorMode.explain);
                  if (state.currentLesson != null) {
                    notifier.sendMessage('Explain ${state.currentLesson!.title}');
                  }
                  break;
                case 'fix':
                  notifier.setMode(TutorMode.fix);
                  notifier.sendMessage(
                      'Help me fix my code for ${state.currentLesson?.title ?? "this lesson"}');
                  break;
                case 'project':
                  notifier.setMode(TutorMode.project);
                  notifier.sendMessage('Suggest a project based on what I learned');
                  break;
                case 'hint':
                  notifier.sendMessage('Give me a hint');
                  break;
                case 'example':
                  notifier.sendMessage('Show me an example');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'explain',
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Explain Concept'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'fix',
                child: Row(
                  children: [
                    Icon(Icons.build_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Fix My Code'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'project',
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Build a Project'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'hint',
                child: Row(
                  children: [
                    Icon(Icons.question_answer_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Get Hint'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'example',
                child: Row(
                  children: [
                    Icon(Icons.code_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Show Example'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _MessageBubble(message: msg);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask the tutor...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          notifier.sendMessage(value.trim());
                          _messageController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () {
                        final text = _messageController.text.trim();
                        if (text.isNotEmpty) {
                          notifier.sendMessage(text);
                          _messageController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.code_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI Code Tutor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about coding!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickActionChip(
                label: 'Explain concept',
                onTap: () {
                  ref.read(codeTutorProvider.notifier).sendMessage(
                      'Can you explain the concept?');
                },
              ),
              _QuickActionChip(
                label: 'Give me a hint',
                onTap: () {
                  ref.read(codeTutorProvider.notifier).sendMessage('Give me a hint');
                },
              ),
              _QuickActionChip(
                label: 'Show example',
                onTap: () {
                  ref.read(codeTutorProvider.notifier).sendMessage('Show me an example');
                },
              ),
              _QuickActionChip(
                label: 'Next lesson',
                onTap: () {
                  ref.read(codeTutorProvider.notifier).sendMessage('What should I learn next?');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.code_rounded,
                          size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI Tutor',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
              ),
              child: _buildContent(message.content),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String content) {
    final codeBlockRegex = RegExp(r'```(\w+)?\n(.*?)```', dotAll: true);
    final parts = content.split(codeBlockRegex);

    if (parts.length <= 1) {
      return Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[800],
          height: 1.5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(parts.length, (index) {
        if (index.isEven && parts[index].isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              parts[index].trim(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          );
        } else if (index.isOdd) {
          final language = parts[index].isEmpty ? 'code' : parts[index];
          final code = index + 1 < parts.length ? parts[index + 1] : '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CodeBlock(
              code: code.trim(),
              language: language,
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: const Icon(Icons.bolt_rounded, size: 16),
    );
  }
}
