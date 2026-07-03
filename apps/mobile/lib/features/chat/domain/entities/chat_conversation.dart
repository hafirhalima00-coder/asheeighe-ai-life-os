import 'package:equatable/equatable.dart';

class ChatConversation extends Equatable {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final bool isArchived;

  const ChatConversation({
    required this.id,
    required this.title,
    this.lastMessage = '',
    required this.createdAt,
    required this.updatedAt,
    this.messageCount = 0,
    this.isArchived = false,
  });

  ChatConversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
    bool? isArchived,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        lastMessage,
        createdAt,
        updatedAt,
        messageCount,
        isArchived,
      ];
}
