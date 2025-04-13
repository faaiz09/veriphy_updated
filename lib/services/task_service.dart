// lib/services/task_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/models/task/task_type.dart';
import 'package:rm_veriphy/models/task/tat.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class TaskService {
  final Dio _dio;

  TaskService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  // Get Tasks for a user
  Future<List<dynamic>> getUserTasks(String userId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.viewTasks}/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // Return empty list if no tasks
        return response.data['tasks'] ?? [];
      }

      throw Exception(response.data['message'] ?? 'Failed to get tasks');
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  // Get Task Types
  Future<List<TaskType>> getTaskTypes() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.viewTaskTypes,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> taskTypesList = response.data['taskTypes'] ?? [];
        return taskTypesList.map((json) => TaskType.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to get task types');
    } catch (e) {
      throw Exception('Failed to get task types: $e');
    }
  }

  // Get TAT List
  Future<List<TAT>> getTATList() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.viewTAT,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> tatList = response.data['taskTypes'] ?? [];
        return tatList.map((json) => TAT.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to get TAT list');
    } catch (e) {
      throw Exception('Failed to get TAT list: $e');
    }
  }

  // Create Task
  Future<void> createTask({
    required String userId,
    required String taskTypeId,
    required String tatId,
    required DateTime creationDate,
    required String description,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.createTask}/$userId',
        queryParameters: {
          'task_type_id': taskTypeId,
          'tat_id': tatId,
          'creation_date': creationDate.toIso8601String(),
          'description': description,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to create task');
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Update Task
  Future<void> updateTask({
    required String userId,
    required String taskId,
    String? tatId,
    DateTime? creationDate,
    String? description,
    String? status,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        '${ApiConstants.updateTask}/$userId',
        queryParameters: {
          'task_id': taskId,
          if (tatId != null) 'tat_id': tatId,
          if (creationDate != null)
            'creation_date': creationDate.toIso8601String(),
          if (description != null) 'description': description,
          if (status != null) 'status': status,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to update task');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }
}
