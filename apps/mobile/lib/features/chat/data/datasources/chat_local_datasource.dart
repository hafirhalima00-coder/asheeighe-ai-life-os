import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_conversation_model.dart';
import '../models/ai_message_model.dart';

class ChatLocalDataSource {
  static const _conversationsKey = 'chat_conversations';
  static const _messagesPrefix = 'chat_messages_';

  Future<void> cacheConversations(
    List<ChatConversationModel> conversations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = conversations.map((c) => c.toJson()).toList();
    await prefs.setString(
      _conversationsKey,
      jsonEncode(jsonList),
    );
  }

  Future<List<ChatConversationModel>?> getCachedConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_conversationsKey);
    if (data == null) return null;
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => ChatConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheMessages(
    String conversationId,
    List<AIMessageModel> messages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => m.toJson()).toList();
    await prefs.setString(
      '$_messagesPrefix$conversationId',
      jsonEncode(jsonList),
    );
  }

  Future<List<AIMessageModel>?> getCachedMessages(
    String conversationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_messagesPrefix$conversationId');
    if (data == null) return null;
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => AIMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteConversationCache(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_messagesPrefix$conversationId');
    final convos = await getCachedConversations();
    if (convos != null) {
      convos.removeWhere((c) => c.id == conversationId);
      await cacheConversations(convos);
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final chatKeys = keys.where(
      (k) => k.startsWith(_conversationsKey) || k.startsWith(_messagesPrefix),
    );
    for (final key in chatKeys) {
      await prefs.remove(key);
    }
  }
}
