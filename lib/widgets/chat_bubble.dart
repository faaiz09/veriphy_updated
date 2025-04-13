// lib/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:rm_veriphy/models/chat_message.dart';
import 'package:rm_veriphy/providers/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ThemeProvider themeProvider;

  const ChatBubble({
    super.key,
    required this.message,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              backgroundColor:
                  themeProvider.theme.colorScheme.secondary.withOpacity(0.2),
              child: Text(
                message.sender[0],
                style:
                    TextStyle(color: themeProvider.theme.colorScheme.secondary),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: message.isMe
                  ? themeProvider.theme.colorScheme.secondary.withOpacity(0.2)
                  : themeProvider.theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: themeProvider.theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
