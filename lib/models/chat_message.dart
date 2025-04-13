// lib/models/chat_message.dart
class ChatMessage {
  final String sender;
  final String message;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.isMe,
    required this.time,
  });
}
