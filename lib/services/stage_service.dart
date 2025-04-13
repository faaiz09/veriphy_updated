// lib/services/stage_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/models/stage/stage_data.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class StageService {
  final Dio _dio;

  StageService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<StageData> getStageData() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.stageData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return StageData.fromJson(response.data['stage']);
      }

      throw Exception(response.data['message'] ?? 'Failed to get stage data');
    } catch (e) {
      throw Exception('Failed to get stage data: $e');
    }
  }
}
