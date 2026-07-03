import '../entities/ai_message.dart';
import '../repositories/chat_repository.dart';

class StreamMessageUseCase {
  final ChatRepository repository;

  StreamMessageUseCase({required this.repository});

  Stream<AIMessage> call({
    required String conversationId,
    required String content,
  }) {
    return repository.streamMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
