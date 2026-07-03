import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ai_message.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/ai_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
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
    final state = ref.watch(chatProvider);

    ref.listen<ChatState>(chatProvider, (previous, next) {
      if (next.messages.length != (previous?.messages.length ?? 0) ||
          next.status == ChatStatus.streaming) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: _buildAppBar(state),
      body: Column(
        children: [
          Expanded(
            child: _buildMessages(state),
          ),
          ChatInputBar(
            onSend: (message) {
              ref.read(chatProvider.notifier).sendMessage(message);
            },
            isStreaming: state.status == ChatStatus.streaming,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: state.activeConversation != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.activeConversation!.title,
                  style: const TextStyle(
                    fontSize: AppConstants.textLg,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (state.status == ChatStatus.streaming)
                  Text(
                    'AI is typing...',
                    style: TextStyle(
                      fontSize: AppConstants.textXs,
                      color: AppTheme.primary.withOpacity(0.7),
                    ),
                  ),
              ],
            )
          : const Text(
              'New Chat',
              style: TextStyle(
                fontSize: AppConstants.textLg,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        if (state.activeConversation != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMenu(context, state),
            splashRadius: 20,
          ),
      ],
    );
  }

  void _showMenu(BuildContext context, ChatState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMd),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppTheme.error),
                title: const Text('Delete conversation'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteConversation(state);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteConversation(ChatState state) {
    if (state.activeConversation == null) return;
    ref.read(chatProvider.notifier).deleteChat(state.activeConversation!.id);
    Navigator.of(context).pop();
  }

  Widget _buildMessages(ChatState state) {
    if (state.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSm,
        vertical: AppConstants.paddingMd,
      ),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];

        switch (message.role) {
          case MessageRole.user:
            return ChatBubble(message: message);
          case MessageRole.assistant:
            return AIBubble(
              message: message,
              suggestedActions: _getSuggestedActions(message),
              onActionTap: (action) {
                ref.read(chatProvider.notifier).sendMessage(action);
              },
            );
          case MessageRole.system:
            return _buildSystemMessage(message);
        }
      },
    );
  }

  List<String> _getSuggestedActions(AIMessage message) {
    if (message.skills.isEmpty) return [];

    final actions = <String>[];
    for (final skill in message.skills) {
      if (skill.success) {
        switch (skill.skillName.toLowerCase()) {
          case 'calendar':
            actions.add('View in calendar');
            break;
          case 'tasks':
            actions.add('View task');
            break;
          case 'reminders':
            actions.add('Set reminder');
            break;
          case 'notes':
            actions.add('Open note');
            break;
        }
      }
    }
    return actions;
  }

  Widget _buildSystemMessage(AIMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingSm,
        horizontal: AppConstants.paddingXl,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMd,
            vertical: AppConstants.paddingSm,
          ),
          decoration: BoxDecoration(
            color: AppTheme.textHint.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              fontSize: AppConstants.textXs,
              color: AppTheme.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 36,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            const Text(
              'How can I help you today?',
              style: TextStyle(
                fontSize: AppConstants.textXl,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSm),
            Text(
              'Ask me to manage your tasks,\nset reminders, or answer questions',
              style: TextStyle(
                fontSize: AppConstants.textMd,
                color: AppTheme.textSecondary.withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildQuickActionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChips() {
    final quickActions = [
      'Create a task',
      'Set a reminder',
      'Schedule an event',
      'Take a note',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickActions.map((action) {
        return ActionChip(
          label: Text(
            action,
            style: const TextStyle(
              fontSize: AppConstants.textSm,
              color: AppTheme.primary,
            ),
          ),
          backgroundColor: AppTheme.primary.withOpacity(0.08),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
          onPressed: () {
            ref.read(chatProvider.notifier).sendMessage(action);
          },
        );
      }).toList(),
    );
  }
}
