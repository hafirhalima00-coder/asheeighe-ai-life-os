import 'dart:convert' show utf8;

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/ai_message_model.dart';
import '../models/chat_conversation_model.dart';
import '../models/send_message_request.dart';
import '../models/skill_result_model.dart';
import '../../../chat/domain/entities/ai_message.dart';

class ChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ChatConversationModel>> getConversations() async {
    final response = await _apiClient.get(ApiConstants.chatConversations);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => ChatConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AIMessageModel>> getMessages(String conversationId) async {
    final response = await _apiClient.get(
      '${ApiConstants.chatMessages}$conversationId/messages',
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => AIMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatConversationModel> createConversation({
    required String title,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.chatConversations,
      data: {'title': title},
    );
    return ChatConversationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    await _apiClient.delete(
      '${ApiConstants.chatConversation}$conversationId',
    );
  }

  Future<AIMessageModel> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final request = SendMessageRequest(
      conversationId: conversationId,
      content: content,
    );
    final response = await _apiClient.post(
      '${ApiConstants.chatSend}$conversationId/messages',
      data: request.toJson(),
    );
    return AIMessageModel.fromJson(response.data as Map<String, dynamic>);
  }

  Stream<AIMessage> streamMessage({
    required String conversationId,
    required String content,
  }) async* {
    try {
      final dio = _apiClient.dio;
      final response = await dio.post(
        '${ApiConstants.chatSend}$conversationId/messages/stream',
        data: {'content': content},
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data.stream as ResponseBody;
      String accumulated = '';
      String? messageId;

      await for (final chunk in stream.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') continue;

            try {
              final json = data as Map<String, dynamic>;
              messageId = json['id'] as String?;
              final token = json['token'] as String? ?? '';
              accumulated += token;

              final skills = (json['skills'] as List<dynamic>?)
                      ?.map((e) =>
                          SkillResultModel.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  [];

              yield AIMessage(
                id: messageId ?? '',
                role: MessageRole.assistant,
                content: accumulated,
                timestamp: DateTime.now(),
                skills: skills,
                isLoading: json['is_loading'] as bool? ?? true,
              );
            } catch (_) {}
          }
        }
      }

      if (messageId != null) {
        yield AIMessage(
          id: messageId,
          role: MessageRole.assistant,
          content: accumulated,
          timestamp: DateTime.now(),
          isLoading: false,
        );
      }
    } catch (e) {
      yield AIMessage(
        id: '',
        role: MessageRole.assistant,
        content: 'Sorry, I encountered an error. Please try again.',
        timestamp: DateTime.now(),
        isLoading: false,
      );
    }
  }
}
