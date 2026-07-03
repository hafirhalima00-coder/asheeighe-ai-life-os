import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../chat/domain/entities/ai_message.dart';
import '../../../chat/domain/entities/chat_conversation.dart';
import '../../../chat/domain/repositories/chat_repository.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/chat_remote_datasource.dart';
import '../datasources/chat_local_datasource.dart';
import '../models/ai_message_model.dart';
import '../models/chat_conversation_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async {
    try {
      final remote = await remoteDataSource.getConversations();
      await localDataSource.cacheConversations(remote);
      return Right(remote);
    } catch (e) {
      try {
        final cached = await localDataSource.getCachedConversations();
        if (cached != null) {
          return Right(cached);
        }
      } catch (_) {}
      return Left(ServerFailure(message: 'Failed to load conversations.'));
    }
  }

  @override
  Future<Either<Failure, List<AIMessage>>> getMessages(
    String conversationId,
  ) async {
    try {
      final remote = await remoteDataSource.getMessages(conversationId);
      await localDataSource.cacheMessages(conversationId, remote);
      return Right(remote);
    } catch (e) {
      try {
        final cached =
            await localDataSource.getCachedMessages(conversationId);
        if (cached != null) {
          return Right(cached);
        }
      } catch (_) {}
      return Left(ServerFailure(message: 'Failed to load messages.'));
    }
  }

  @override
  Future<Either<Failure, ChatConversation>> createConversation({
    required String title,
  }) async {
    try {
      final remote = await remoteDataSource.createConversation(title: title);
      return Right(remote);
    } catch (e) {
      final local = ChatConversationModel(
        id: const Uuid().v4(),
        title: title,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return Right(local);
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(
    String conversationId,
  ) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
    } catch (_) {}
    await localDataSource.deleteConversationCache(conversationId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, AIMessage>> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final remote = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
      );
      return Right(remote);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send message.'));
    }
  }

  @override
  Stream<AIMessage> streamMessage({
    required String conversationId,
    required String content,
  }) {
    return remoteDataSource.streamMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
