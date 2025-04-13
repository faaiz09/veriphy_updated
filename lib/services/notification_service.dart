// lib/services/notification_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/models/notification/notification_data.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class NotificationService {
  final Dio _dio;

  NotificationService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<List<NotificationData>> getNotifications({
    required DateTime fromDate,
    DateTime? toDate,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.newNotifications,
        queryParameters: {
          'fromDate': fromDate.toIso8601String(),
          if (toDate != null) 'toDate': toDate.toIso8601String(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> notificationsList =
            response.data['notifications'] ?? [];
        return notificationsList
            .map((json) => NotificationData.fromJson(json))
            .toList();
      }

      throw Exception(
          response.data['message'] ?? 'Failed to get notifications');
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  Future<void> updateNotificationStatus({
    required String notificationId,
    required String status,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.updateNotification,
        queryParameters: {
          'notification_id': notificationId,
          'status': status,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(
            response.data['message'] ?? 'Failed to update notification');
      }
    } catch (e) {
      throw Exception('Failed to update notification: $e');
    }
  }
}
