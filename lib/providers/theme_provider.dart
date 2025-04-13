// lib/providers/theme_provider.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'dark_mode';
  static const String _languageKey = 'language';
  final SharedPreferences _prefs;
  bool _isDarkMode;

  late Locale _locale;
  Locale get locale => _locale;

  ThemeProvider(this._prefs)
      : _isDarkMode = _prefs.getBool(_themeKey) ?? false {
    _locale = Locale(_prefs.getString(_languageKey) ?? 'en');
  }

    void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  static final _lightTheme = ThemeData(
    primaryColor: const Color(0xFF3B5998),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B5998),
      secondary: Color(0xFF4A90E2),
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.grey[200],
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final _darkTheme = ThemeData(
    primaryColor: const Color(0xFF3B5998),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF3B5998),
      secondary: const Color(0xFF4A90E2),
      error: Colors.red[400]!,
      background: Colors.black,
      surface: const Color(0xFF121212),
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.black,
    dividerColor: const Color(0xFF333333),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF121212),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Color(0xFF3B5998),
      unselectedItemColor: Colors.grey,
    ),
    dialogBackgroundColor: const Color(0xFF121212),
  );

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
