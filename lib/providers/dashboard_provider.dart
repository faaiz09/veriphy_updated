// lib/providers/dashboard_provider.dart

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rm_veriphy/models/dashboard/dashboard_data.dart';
import 'package:rm_veriphy/services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService;
  DashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;

  DashboardProvider(this._apiService);

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// ✅ New Getter Added
  int get pendingDocuments => _dashboardData?.pendingDocuments ?? 0;

  Future<void> loadDashboard() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Loading dashboard data...');
      _dashboardData = await _apiService.getDashboardData();
      print('Dashboard data loaded: $_dashboardData');
    } catch (e) {
      print('Error loading dashboard: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
