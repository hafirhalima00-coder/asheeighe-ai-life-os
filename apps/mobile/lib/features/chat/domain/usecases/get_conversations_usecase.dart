import 'package:dartz/dartz.dart';

import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/errors/failures.dart';

class GetConversationsUseCase {
  final ChatRepository repository;

  GetConversationsUseCase({required this.repository});

  Future<Either<Failure, List<ChatConversation>>> call() {
    return repository.getConversations();
  }
}
