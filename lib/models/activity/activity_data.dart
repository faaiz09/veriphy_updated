// lib/models/activity/activity_data.dart

class ActivityData {
  final String id;
  final String userId;
  final String activity;
  final String description;
  final DateTime timestamp;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityData({
    required this.id,
    required this.userId,
    required this.activity,
    required this.description,
    required this.timestamp,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      activity: json['activity']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
