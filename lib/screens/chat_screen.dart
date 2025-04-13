// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:rm_veriphy/models/chat_message.dart';
import 'package:rm_veriphy/services/chat_service.dart';
import 'package:rm_veriphy/widgets/chat_bubble.dart';
import 'package:rm_veriphy/providers/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String? conversationId;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Chat state
  List<ChatMessage> _messages = [];
  String? _conversationId;
  StreamSubscription? _messageSubscription;

  // Loading and error states
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeChatConnection();
  }

  // Initialize chat connection and start listening for messages
  Future<void> _initializeChatConnection() async {
    try {
      setState(() => _isLoading = true);

      // Get conversation ID for this user
      _conversationId = widget.conversationId ??
          await context.read<ChatService>().getConversationId(widget.userId);

      // Start listening to message stream
      _startMessageStream();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize chat: $e';
        _isLoading = false;
      });
    }
  }

  // Start listening to message updates
  void _startMessageStream() {
    if (_conversationId == null) return;

    _messageSubscription =
        context.read<ChatService>().getMessageStream(_conversationId!).listen(
      (messages) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _error = 'Error loading messages: $error';
          _isLoading = false;
        });
      },
    );
  }

  // Scroll to bottom of chat
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName),
            Text(
              'ID: ${widget.userId}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: _buildChatBody(theme),
    );
  }

  Widget _buildChatBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeChatConnection,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return ChatBubble(
                message: message,
                themeProvider: context.watch<ThemeProvider>(),
              );
            },
          ),
        ),
        _buildMessageInput(theme),
      ],
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: theme.shadowColor.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Add message locally for immediate feedback
      setState(() {
        _messages.add(ChatMessage(
          sender: 'Me',
          message: message,
          isMe: true,
          time: DateFormat('HH:mm').format(DateTime.now()),
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageSubscription?.cancel();
    super.dispose();
  }
}
