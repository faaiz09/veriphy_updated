// lib/services/customer_process_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/utils/token_manager.dart';
// import 'package:rm_veriphy/utils/error_utils.dart';

class CustomerProcessService {
  final Dio _dio;

  CustomerProcessService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<void> initiateProcess(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.initiateProcess}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(
            response.data['message'] ?? 'Failed to initiate process');
      }
    } catch (e) {
      throw Exception('Failed to initiate process: $e');
    }
  }

  Future<void> reinitiateProcess(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.reinitiateProcess}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(
            response.data['message'] ?? 'Failed to reinitiate process');
      }
    } catch (e) {
      throw Exception('Failed to reinitiate process: $e');
    }
  }

  Future<void> completeProcess(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.completeProcess}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(
            response.data['message'] ?? 'Failed to complete process');
      }
    } catch (e) {
      throw Exception('Failed to complete process: $e');
    }
  }

  Future<void> resetCustomer(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.resetCustomer}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to reset customer');
      }
    } catch (e) {
      throw Exception('Failed to reset customer: $e');
    }
  }

  Future<void> editCustomer({
    required String userId,
    required String stageName,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.editCustomer}/$userId',
        queryParameters: {'stageName': stageName},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to edit customer');
      }
    } catch (e) {
      throw Exception('Failed to edit customer: $e');
    }
  }
}
