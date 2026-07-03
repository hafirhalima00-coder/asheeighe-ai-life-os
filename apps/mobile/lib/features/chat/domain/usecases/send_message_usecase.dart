import 'package:dartz/dartz.dart';

import '../entities/ai_message.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/errors/failures.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase({required this.repository});

  Future<Either<Failure, AIMessage>> call({
    required String conversationId,
    required String content,
  }) {
    return repository.sendMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
