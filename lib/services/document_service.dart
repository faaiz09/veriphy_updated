// lib/services/document_service.dart
import 'package:dio/dio.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class DocumentService {
  final Dio _dio;

  DocumentService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<Map<String, dynamic>> tagDocument({
    required String userId,
    required String documentId,
    required String documentType,
    String? rejectReason,
    String? rejectionMessage,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.tagDocument}/$userId/$documentId',
        queryParameters: {
          'documentType': documentType,
          if (rejectReason != null) 'rejectReason': rejectReason,
          if (rejectionMessage != null) 'rejectionMessage': rejectionMessage,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to tag document');
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to tag document: ${e.toString()}');
    }
  }

  Future<void> initiateProcess(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.initiateProcess}/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            response.data['message'] ?? 'Failed to initiate process');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to initiate process: ${e.toString()}');
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
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            response.data['message'] ?? 'Failed to reinitiate process');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to reinitiate process: ${e.toString()}');
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
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            response.data['message'] ?? 'Failed to complete process');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to complete process: ${e.toString()}');
    }
  }

  Future<bool> addDocument(String userId, String documentName) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/v1/documentservice/adddocument/$userId',
        queryParameters: {
          'newdocumentname': documentName,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['status'] == 'success';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please try again.');
    }

    if (error.type == DioExceptionType.badResponse) {
      final response = error.response;
      if (response?.statusCode == 401) {
        return Exception('Session expired. Please login again.');
      }
      return Exception(response?.data?['message'] ?? 'Server error');
    }

    if (error.type == DioExceptionType.cancel) {
      return Exception('Request was cancelled');
    }

    return Exception('An unexpected error occurred');
  }
}
