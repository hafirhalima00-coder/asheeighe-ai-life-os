class SendMessageRequest {
  final String conversationId;
  final String content;

  const SendMessageRequest({
    required this.conversationId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'content': content,
    };
  }
}
