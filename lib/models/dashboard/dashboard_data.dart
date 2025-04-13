// lib/models/dashboard/dashboard_data.dart

class DashboardData {
  final double totalProductAmount;
  final int completedCount;
  final int signAndPayCount;
  final int approvedCount;
  final int reviewCount;
  final int inProgressCount;
  final int jumpStartCount;
  final int openCount;

  DashboardData({
    required this.totalProductAmount,
    required this.completedCount,
    required this.signAndPayCount,
    required this.approvedCount,
    required this.reviewCount,
    required this.inProgressCount,
    required this.jumpStartCount,
    required this.openCount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalProductAmount:
          double.tryParse(json['totalProductAmount']?.toString() ?? '0') ?? 0.0,
      completedCount:
          int.tryParse(json['completedCount']?.toString() ?? '0') ?? 0,
      signAndPayCount:
          int.tryParse(json['signAndPayCount']?.toString() ?? '0') ?? 0,
      approvedCount:
          int.tryParse(json['approvedCount']?.toString() ?? '0') ?? 0,
      reviewCount: int.tryParse(json['reviewCount']?.toString() ?? '0') ?? 0,
      inProgressCount:
          int.tryParse(json['inProgressCount']?.toString() ?? '0') ?? 0,
      jumpStartCount:
          int.tryParse(json['jumpStartCount']?.toString() ?? '0') ?? 0,
      openCount: int.tryParse(json['openCount']?.toString() ?? '0') ?? 0,
    );
  }
}
