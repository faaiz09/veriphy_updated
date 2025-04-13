// lib/models/responses/auth_response.dart
// ignore_for_file: avoid_print

class AuthResponse {
  final String? token;
  final bool success;
  final String message;
  final String status;

  AuthResponse({
    this.token,
    required this.success,
    required this.message,
    required this.status,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing auth response JSON: $json');
    final token = json['token'] as String?;
    print('Extracted token: $token');

    return AuthResponse(
      token: token,
      success: json['status'] == 'success',
      message: json['message'] as String? ?? 'Unknown response',
      status: json['status'] as String? ?? 'error',
    );
  }
}
