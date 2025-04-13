// lib/models/responses/dashboard_response.dart
import 'package:rm_veriphy/models/case.dart';
import 'package:rm_veriphy/models/mtd_summary.dart';

class DashboardResponse {
  final List<Case> cases;
  final MTDSummary summary;
  final bool success;
  final String message;

  DashboardResponse({
    required this.cases,
    required this.summary,
    required this.success,
    required this.message,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      cases:
          (json['cases'] as List?)?.map((e) => Case.fromJson(e)).toList() ?? [],
      summary: MTDSummary.fromJson(json['summary'] ?? {}),
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}
