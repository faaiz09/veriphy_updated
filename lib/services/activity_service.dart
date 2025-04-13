// lib/services/activity_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/models/activity/activity_data.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class ActivityService {
  final Dio _dio;

  ActivityService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<List<ActivityData>> getUserActivity(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.activity}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> activities = response.data['userActivity'] ?? [];
        return activities.map((json) => ActivityData.fromJson(json)).toList();
      }

      throw Exception(
          response.data['message'] ?? 'Failed to get user activity');
    } catch (e) {
      throw Exception('Failed to get user activity: $e');
    }
  }
}
