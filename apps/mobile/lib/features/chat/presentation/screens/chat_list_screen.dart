import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../providers/conversation_list_provider.dart';
import '../providers/chat_provider.dart';

final conversationListProvider = StateNotifierProvider<
    ConversationListNotifier, ConversationListState>((ref) {
  final useCase = ref.watch(getConversationsUseCaseProvider);
  return ConversationListNotifier(getConversations: useCase);
});

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(conversationListProvider.notifier).loadConversations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(chatProvider.notifier).createNewChat();
          Navigator.of(context).pushNamed(RouteNames.chatDetail);
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMd,
        AppConstants.paddingMd,
        AppConstants.paddingMd,
        AppConstants.paddingSm,
      ),
      child: Row(
        children: [
          const Text(
            'Chats',
            style: TextStyle(
              fontSize: AppConstants.text2xl,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit_square,
                color: AppTheme.primary,
                size: AppConstants.iconMd,
              ),
              onPressed: () {
                ref.read(chatProvider.notifier).createNewChat();
                Navigator.of(context).pushNamed(RouteNames.chatDetail);
              },
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMd,
        vertical: AppConstants.paddingSm,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          ref.read(conversationListProvider.notifier).setSearchQuery(query);
        },
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textHint,
            size: AppConstants.iconMd,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: AppConstants.iconMd),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(conversationListProvider.notifier)
                        .setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMd,
            vertical: AppConstants.paddingSm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            borderSide: const BorderSide(color: AppTheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ConversationListState state) {
    switch (state.status) {
      case ConversationListStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        );
      case ConversationListStatus.error:
        return _buildError(state);
      case ConversationListStatus.loaded:
      case ConversationListStatus.initial:
        final conversations = state.filteredConversations;
        if (conversations.isEmpty) {
          return _buildEmptyState(state.searchQuery.isNotEmpty);
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(conversationListProvider.notifier).loadConversations(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMd,
            ),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _buildConversationItem(conversation);
            },
          ),
        );
    }
  }

  Widget _buildConversationItem(conversation) {
    final timeFormat = DateFormat('MMM d');
    final isToday = DateTime.now().difference(conversation.updatedAt).inDays < 1;

    return Dismissible(
      key: ValueKey(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.paddingMd),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.error),
      ),
      onDismissed: (_) {
        ref
            .read(conversationListProvider.notifier)
            .removeConversation(conversation.id);
        ref.read(chatProvider.notifier).deleteChat(conversation.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppConstants.paddingSm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          onTap: () {
            ref.read(chatProvider.notifier).switchConversation(conversation);
            Navigator.of(context).pushNamed(RouteNames.chatDetail);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.secondary, AppTheme.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: AppConstants.iconMd,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        style: const TextStyle(
                          fontSize: AppConstants.textMd,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation.lastMessage.isEmpty
                            ? 'No messages yet'
                            : conversation.lastMessage,
                        style: const TextStyle(
                          fontSize: AppConstants.textSm,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSm),
                Text(
                  isToday
                      ? DateFormat('h:mm a').format(conversation.updatedAt)
                      : timeFormat.format(conversation.updatedAt),
                  style: const TextStyle(
                    fontSize: AppConstants.textXs,
                    color: AppTheme.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
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
                Icons.chat_bubble_outline,
                size: 36,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Text(
              isSearching ? 'No conversations found' : 'No conversations yet',
              style: const TextStyle(
                fontSize: AppConstants.textLg,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSm),
            Text(
              isSearching
                  ? 'Try a different search term'
                  : 'Start a conversation with your AI assistant',
              style: const TextStyle(
                fontSize: AppConstants.textMd,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isSearching) ...[
              const SizedBox(height: AppConstants.paddingMd),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(chatProvider.notifier).createNewChat();
                  Navigator.of(context).pushNamed(RouteNames.chatDetail);
                },
                icon: const Icon(Icons.add),
                label: const Text('Start a Conversation'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError(ConversationListState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: AppTheme.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppConstants.textMd,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            ElevatedButton.icon(
              onPressed: () => ref
                  .read(conversationListProvider.notifier)
                  .loadConversations(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
