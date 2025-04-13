// lib/utils/token_manager.dart
// ignore_for_file: avoid_print

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final _storage = LocalStorage('auth.json');
  static const _tokenKey = 'auth_token';
  static const _rememberMeKey = 'remember_me';
  static String? _memoryToken;

  // Save token with remember me preference
  static Future<void> saveToken(String token, {bool rememberMe = false}) async {
    try {
      await _storage.ready;
      _memoryToken = token;
      await _storage.setItem(_tokenKey, token);

      // Save remember me preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, rememberMe);

      print('Token saved successfully: $token with rememberMe: $rememberMe');
    } catch (e) {
      print('Error saving token: $e');
      rethrow;
    }
  }

  // Get stored token
  static Future<String?> getToken() async {
    try {
      // First try memory cache
      if (_memoryToken != null) {
        return _memoryToken;
      }

      // Check if remember me is enabled
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

      if (!rememberMe) {
        return null;
      }

      // Then try storage
      await _storage.ready;
      final token = await _storage.getItem(_tokenKey);
      if (token != null) {
        _memoryToken = token.toString();
        return _memoryToken;
      }
    } catch (e) {
      print('Error getting token: $e');
    }
    return null;
  }

  // Delete token and clear remember me
  static Future<void> deleteToken() async {
    try {
      _memoryToken = null;
      await _storage.ready;
      await _storage.deleteItem(_tokenKey);

      // Clear remember me preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, false);

      print('Token deleted successfully');
    } catch (e) {
      print('Error deleting token: $e');
    }
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get authorization headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  // Check if remember me is enabled
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Check if token is valid
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null && token.isNotEmpty && token.length > 20;
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    try {
      _memoryToken = null;
      await _storage.ready;
      await _storage.clear();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      print('All storage cleared successfully');
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }
}
