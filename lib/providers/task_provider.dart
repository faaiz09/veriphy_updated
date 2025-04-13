// lib/providers/task_provider.dart

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/models/task/task_type.dart';
import 'package:rm_veriphy/models/task/tat.dart';
import 'package:rm_veriphy/services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService;

  List<dynamic> _userTasks = [];
  List<TaskType> _taskTypes = [];
  List<TAT> _tatList = [];
  bool _isLoading = false;
  String? _error;

  TaskProvider(this._taskService);

  // Getters
  List<dynamic> get userTasks => _userTasks;
  List<TaskType> get taskTypes => _taskTypes;
  List<TAT> get tatList => _tatList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserTasks(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userTasks = await _taskService.getUserTasks(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTaskTypes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _taskTypes = await _taskService.getTaskTypes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTATList() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _tatList = await _taskService.getTATList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask({
    required String userId,
    required String taskTypeId,
    required String tatId,
    required DateTime creationDate,
    required String description,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _taskService.createTask(
        userId: userId,
        taskTypeId: taskTypeId,
        tatId: tatId,
        creationDate: creationDate,
        description: description,
      );

      // Reload tasks after creation
      await loadUserTasks(userId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask({
    required String userId,
    required String taskId,
    String? tatId,
    DateTime? creationDate,
    String? description,
    String? status,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _taskService.updateTask(
        userId: userId,
        taskId: taskId,
        tatId: tatId,
        creationDate: creationDate,
        description: description,
        status: status,
      );

      // Reload tasks after update
      await loadUserTasks(userId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
