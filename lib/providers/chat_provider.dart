// lib/providers/chat_provider.dart
import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/services/chat_service.dart';
import 'package:rm_veriphy/models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _conversationId;

  ChatProvider(this._chatService);

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeChat(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get conversation ID
      _conversationId = await _chatService.getConversationId(userId);
      
      // Load messages
      await loadMessages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages() async {
    if (_conversationId == null) {
      _error = 'No active conversation';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _messages = await _chatService.getChatMessages(_conversationId!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add local message immediately and update UI
  void addMessage(String message) {
    final newMessage = ChatMessage(
      sender: 'admin',
      message: message,
      isMe: true,
      time: DateTime.now().toString(),
    );
    
    _messages.add(newMessage);
    notifyListeners();
  }
}