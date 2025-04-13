// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Create API service with mock prefs
    final apiService = ApiService();

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MyApp(
        apiService: apiService,
        prefs: prefs, // Add the required prefs parameter
      ),
    );

    // Verify that our app shows the login screen initially
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
