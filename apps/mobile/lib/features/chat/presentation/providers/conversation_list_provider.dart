import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/chat_local_datasource.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../../../core/network/api_client.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteDataSource(apiClient: apiClient);
});

final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  return ChatLocalDataSource();
});

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  final remote = ref.watch(chatRemoteDataSourceProvider);
  final local = ref.watch(chatLocalDataSourceProvider);
  return ChatRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

final getConversationsUseCaseProvider =
    Provider<GetConversationsUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return GetConversationsUseCase(repository: repo);
});

enum ConversationListStatus { initial, loading, loaded, error }

class ConversationListState {
  final ConversationListStatus status;
  final List<ChatConversation> conversations;
  final String? errorMessage;
  final String searchQuery;

  const ConversationListState({
    this.status = ConversationListStatus.initial,
    this.conversations = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  ConversationListState copyWith({
    ConversationListStatus? status,
    List<ChatConversation>? conversations,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ConversationListState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<ChatConversation> get filteredConversations {
    if (searchQuery.isEmpty) return conversations;
    return conversations
        .where((c) =>
            c.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            c.lastMessage.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}

class ConversationListNotifier extends StateNotifier<ConversationListState> {
  final GetConversationsUseCase _getConversations;

  ConversationListNotifier({
    required GetConversationsUseCase getConversations,
  })  : _getConversations = getConversations,
        super(const ConversationListState());

  Future<void> loadConversations() async {
    state = state.copyWith(status: ConversationListStatus.loading);

    final result = await _getConversations();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ConversationListStatus.error,
          errorMessage: failure.message,
        );
      },
      (conversations) {
        conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        state = state.copyWith(
          status: ConversationListStatus.loaded,
          conversations: conversations,
        );
      },
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void removeConversation(String id) {
    state = state.copyWith(
      conversations: state.conversations.where((c) => c.id != id).toList(),
    );
  }
}
