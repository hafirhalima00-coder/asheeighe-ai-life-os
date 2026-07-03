import 'package:dartz/dartz.dart';

import '../entities/ai_message.dart';
import '../entities/chat_conversation.dart';
import '../../../../core/errors/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatConversation>>> getConversations();

  Future<Either<Failure, List<AIMessage>>> getMessages(
    String conversationId,
  );

  Future<Either<Failure, ChatConversation>> createConversation({
    required String title,
  });

  Future<Either<Failure, void>> deleteConversation(String conversationId);

  Future<Either<Failure, AIMessage>> sendMessage({
    required String conversationId,
    required String content,
  });

  Stream<AIMessage> streamMessage({
    required String conversationId,
    required String content,
  });
}
