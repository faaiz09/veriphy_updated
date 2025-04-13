// lib/providers/activity_provider.dart

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/models/activity/activity_data.dart';
import 'package:rm_veriphy/services/activity_service.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityService _activityService;

  List<ActivityData> _activities = [];
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;

  ActivityProvider(this._activityService);

  List<ActivityData> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserActivity(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      _currentUserId = userId;
      notifyListeners();

      _activities = await _activityService.getUserActivity(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshActivity() async {
    if (_currentUserId != null) {
      await loadUserActivity(_currentUserId!);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
