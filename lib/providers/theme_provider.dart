// lib/providers/theme_provider.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
    primaryColor: const Color(0xFFA7D222),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFA7D222),
      secondary: Color(0xFFA7D222),
      error: Colors.red,
    ),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA7D222),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final _darkTheme = ThemeData(
    primaryColor: const Color(0xFFA7D222),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFA7D222),
      secondary: Color(0xFFA7D222),
      error: Colors.redAccent,
      background: Colors.black,
      surface: Color(0xFF121212),
    ),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA7D222),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Color(0xFFA7D222),
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
