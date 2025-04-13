// lib/providers/profile_provider.dart
// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/models/profile/profile_data.dart';

class ProfileProvider with ChangeNotifier {
  final ApiService _apiService;
  ProfileData? _profileData;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._apiService);

  ProfileData? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfileData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.getProfileBasicInfo();
      if (response['status'] == 'success') {
        _profileData = ProfileData.fromJson(response);
      } else {
        throw Exception(response['message'] ?? 'Failed to load profile data');
      }
    } catch (e) {
      print('Error loading profile data: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile(UserBasicInfo updatedUser) {
    _profileData = ProfileData(
      user: updatedUser,
      activeCustomerCount: _profileData?.activeCustomerCount ?? 0,
      completedCount: _profileData?.completedCount ?? '0',
      totalProductAmount: _profileData?.totalProductAmount ?? '0',
    );
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
