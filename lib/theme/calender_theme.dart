// lib/theme/calendar_theme.dart
// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

class CalendarTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFA7D222),
        secondary: const Color(0xFFA7D222),
        background: Colors.white,
        surface: Colors.grey.shade50,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFA7D222),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFA7D222),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedColor: const Color(0xFFA7D222),
        labelStyle: const TextStyle(fontSize: 14),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFA7D222),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
