// lib/models/mtd_summary.dart
class MTDSummary {
  final double premiumRevenue;
  final int policiesIssued;
  final double tatPercentage;
  final Map<String, int> statusCounts;

  MTDSummary({
    required this.premiumRevenue,
    required this.policiesIssued,
    required this.tatPercentage,
    required this.statusCounts,
  });

  factory MTDSummary.fromJson(Map<String, dynamic> json) {
    return MTDSummary(
      premiumRevenue:
          double.tryParse(json['premiumRevenue']?.toString() ?? '0') ?? 0.0,
      policiesIssued:
          int.tryParse(json['policiesIssued']?.toString() ?? '0') ?? 0,
      tatPercentage:
          double.tryParse(json['tatPercentage']?.toString() ?? '0') ?? 0.0,
      statusCounts: Map<String, int>.from(json['statusCounts'] ?? {}),
    );
  }

  // Sample data factory (keep this for testing)
  static MTDSummary getSampleSummary() {
    return MTDSummary(
      premiumRevenue: 210000,
      policiesIssued: 11,
      tatPercentage: 70,
      statusCounts: {
        'Jumpstart': 2,
        'In Progress': 3,
        'Review': 5,
        'Approved': 4,
        'Sign & Pay': 3,
      },
    );
  }
}
