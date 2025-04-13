// lib/services/chat_service.dart
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/models/chat_message.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class ChatService {
  final Dio _dio;

  ChatService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    );
  }

  // Get conversation ID for a user
  Future<String> getConversationId(String userId) async {
    try {
      final response = await _dio.post(
        '/api/v1/whatsappservice/conversationid/$userId',
        options: Options(
          headers: await TokenManager.getAuthHeaders(),
        ),
      );

      // Check if the response is successful and contains a conversation ID
      if (response.data['status'] == 'success' &&
          response.data['conversationId'] != null) {
        return response.data['conversationId'].toString();
      }

      throw Exception(
          response.data['message'] ?? 'Failed to get conversation ID');
    } catch (e) {
      print('Error getting conversation ID: $e');
      throw Exception('Failed to get conversation ID');
    }
  }

  // Fetch chat messages
  Future<List<ChatMessage>> getChatMessages(String conversationId) async {
    try {
      final response = await _dio.get(
        'https://bank.ariticapp.com/chatext/admin.php',
        queryParameters: {
          'conversation': conversationId,
        },
      );

      if (response.data == null) {
        return [];
      }

      final List<dynamic> messages = response.data;
      return messages.map((message) {
        // Convert the timestamp to a formatted time string
        final timestamp = DateTime.parse(message['timestamp']);
        final timeString = DateFormat('HH:mm').format(timestamp);

        return ChatMessage(
          sender:
              message['sender_type'] == 'admin' ? 'Me' : message['sender_name'],
          message: message['message'],
          isMe: message['sender_type'] == 'admin',
          time: timeString,
        );
      }).toList();
    } catch (e) {
      print('Error fetching chat messages: $e');
      throw Exception('Failed to fetch chat messages');
    }
  }

  // Refresh messages periodically
  Stream<List<ChatMessage>> getMessageStream(String conversationId) async* {
    while (true) {
      try {
        // Fetch latest messages
        final messages = await getChatMessages(conversationId);
        yield messages;

        // Wait before next update
        await Future.delayed(const Duration(seconds: 3));
      } catch (e) {
        print('Error in message stream: $e');
        // Wait before retrying after error
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }
}
