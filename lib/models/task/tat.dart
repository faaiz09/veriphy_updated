// lib/models/task/tat.dart

class TAT {
  final String id;
  final String companyId;
  final String duration;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  TAT({
    required this.id,
    required this.companyId,
    required this.duration,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TAT.fromJson(Map<String, dynamic> json) {
    return TAT(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      duration: json['tat_duration'] ?? '',
      unit: json['tat_unit'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
