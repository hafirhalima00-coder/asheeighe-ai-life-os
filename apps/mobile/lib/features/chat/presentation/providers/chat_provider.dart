import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_client.dart';

import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/stream_message_usecase.dart';
import 'conversation_list_provider.dart';

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository: repo);
});

final streamMessageUseCaseProvider = Provider<StreamMessageUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return StreamMessageUseCase(repository: repo);
});

enum ChatStatus { idle, loading, streaming, error }

class ChatState {
  final ChatStatus status;
  final List<ChatConversation> conversations;
  final ChatConversation? activeConversation;
  final List<AIMessage> messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.idle,
    this.conversations = const [],
    this.activeConversation,
    this.messages = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatConversation>? conversations,
    ChatConversation? activeConversation,
    List<AIMessage>? messages,
    String? errorMessage,
    bool? clearError,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      activeConversation: activeConversation ?? this.activeConversation,
      messages: messages ?? this.messages,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessage;
  final StreamMessageUseCase _streamMessage;
  StreamSubscription<AIMessage>? _streamSubscription;

  ChatNotifier({
    required SendMessageUseCase sendMessage,
    required StreamMessageUseCase streamMessage,
  })  : _sendMessage = sendMessage,
        _streamMessage = streamMessage,
        super(const ChatState());

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final conversation = state.activeConversation ??
        ChatConversation(
          id: const Uuid().v4(),
          title: content.length > 40
              ? '${content.substring(0, 40)}...'
              : content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          messageCount: 0,
        );

    final userMessage = AIMessage(
      id: const Uuid().v4(),
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
    );

    final loadingMessage = AIMessage(
      id: 'loading-${const Uuid().v4()}',
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = state.copyWith(
      status: ChatStatus.streaming,
      activeConversation: conversation,
      messages: [...state.messages, userMessage, loadingMessage],
    );

    _streamSubscription?.cancel();
    _streamSubscription = _streamMessage(
      conversationId: conversation.id,
      content: content,
    ).listen(
      (streamedMessage) {
        final messages = [...state.messages];
        final loadingIndex =
            messages.indexWhere((m) => m.id.startsWith('loading-'));

        if (loadingIndex >= 0) {
          messages[loadingIndex] = streamedMessage;
        }

        state = state.copyWith(
          status: streamedMessage.isLoading
              ? ChatStatus.streaming
              : ChatStatus.idle,
          messages: messages,
        );
      },
      onError: (error) {
        final messages = [...state.messages];
        final loadingIndex =
            messages.indexWhere((m) => m.id.startsWith('loading-'));

        if (loadingIndex >= 0) {
          messages[loadingIndex] = AIMessage(
            id: 'error-${const Uuid().v4()}',
            role: MessageRole.assistant,
            content: 'Sorry, I encountered an error. Please try again.',
            timestamp: DateTime.now(),
            isLoading: false,
          );
        }

        state = state.copyWith(
          status: ChatStatus.error,
          messages: messages,
          errorMessage: 'Failed to get response',
        );
      },
      onDone: () {
        if (state.status == ChatStatus.streaming) {
          state = state.copyWith(status: ChatStatus.idle);
        }
      },
    );
  }

  void switchConversation(ChatConversation conversation,
      {List<AIMessage> messages = const []}) {
    _streamSubscription?.cancel();
    state = state.copyWith(
      status: ChatStatus.idle,
      activeConversation: conversation,
      messages: messages,
    );
  }

  void createNewChat() {
    _streamSubscription?.cancel();
    state = state.copyWith(
      status: ChatStatus.idle,
      activeConversation: null,
      messages: [],
    );
  }

  void deleteChat(String conversationId) {
    if (state.activeConversation?.id == conversationId) {
      state = state.copyWith(
        activeConversation: null,
        messages: [],
      );
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final sendMessage = ref.watch(sendMessageUseCaseProvider);
  final streamMessage = ref.watch(streamMessageUseCaseProvider);
  return ChatNotifier(
    sendMessage: sendMessage,
    streamMessage: streamMessage,
  );
});
