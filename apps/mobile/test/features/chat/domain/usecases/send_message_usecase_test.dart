import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:asheeighe/core/errors/failures.dart';
import 'package:asheeighe/features/chat/domain/entities/ai_message.dart';
import 'package:asheeighe/features/chat/domain/repositories/chat_repository.dart';
import 'package:asheeighe/features/chat/domain/usecases/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessageUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = SendMessageUseCase(repository: mockRepository);
  });

  const conversationId = 'conv1';
  const messageContent = 'Hello AI!';

  final response = AIMessage(
    id: 'msg2',
    role: MessageRole.assistant,
    content: 'Hi there!',
    timestamp: DateTime(2024, 6, 15, 10, 1),
  );

  group('SendMessageUseCase', () {
    test('should call repository.sendMessage with correct params', () async {
      when(() => mockRepository.sendMessage(
            conversationId: any(named: 'conversationId'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => Right(response));

      final result = await useCase(
        conversationId: conversationId,
        content: messageContent,
      );

      verify(() => mockRepository.sendMessage(
            conversationId: conversationId,
            content: messageContent,
          )).called(1);
      expect(result, equals(Right(response)));
    });

    test('should return AIMessage with assistant role', () async {
      when(() => mockRepository.sendMessage(
            conversationId: any(named: 'conversationId'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => Right(response));

      final result = await useCase(
        conversationId: conversationId,
        content: messageContent,
      );
      expect((result as Right).value.role, MessageRole.assistant);
    });

    test('should return ServerFailure on error', () async {
      const failure = ServerFailure(message: 'AI service unavailable');
      when(() => mockRepository.sendMessage(
            conversationId: any(named: 'conversationId'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        conversationId: conversationId,
        content: messageContent,
      );
      expect(result, equals(const Left(failure)));
    });

    test('should return NetworkFailure on connection error', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.sendMessage(
            conversationId: any(named: 'conversationId'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        conversationId: conversationId,
        content: messageContent,
      );
      expect(result, equals(const Left(failure)));
    });
  });
}
