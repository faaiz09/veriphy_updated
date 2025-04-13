// lib/providers/auth_provider.dart
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/models/user.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  User? _user;

  AuthProvider(this._apiService);

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;

  Future<bool> login(String email, String password, bool rememberMe) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.login(email, password);
      print('Login response: ${response.status}');

      if (!response.success) {
        _error = response.message;
        _isAuthenticated = false;
        return false;
      }

      await TokenManager.saveToken(response.token!, rememberMe: rememberMe);

      // Verify token was saved
      if (!await TokenManager.hasToken()) {
        throw Exception('Failed to save authentication token');
      }

      // Get user details
      try {
        _user = await _apiService.authenticate();
        _isAuthenticated = true;
        _error = null;
        return true;
      } catch (authError) {
        print('Authentication failed: $authError');
        _error = 'Failed to get user details';
        _isAuthenticated = false;
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _error = e.toString();
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateProfileData({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _apiService.dio.post(
        '${ApiConstants.getFullUrl(ApiConstants.profileBasicInfo)}?firstname=$firstName&lastname=$lastName&phone=$phone&address=$address&email=$email',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Error updating profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.logout();
    } catch (e) {
      print('Logout error: $e');
      _error = e.toString();
    } finally {
      _isAuthenticated = false;
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      // Check if token exists
      if (!await TokenManager.hasToken()) {
        _isAuthenticated = false;
        _user = null;
        return;
      }

      _isLoading = true;
      notifyListeners();

      _user = await _apiService.authenticate();
      _isAuthenticated = _user != null;
      _error = null;
    } catch (e) {
      print('Auth check failed: $e');
      _error = null;
      _isAuthenticated = false;
      _user = null;
      await TokenManager.deleteToken(); // Clear invalid token
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    return await TokenManager.getToken();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
