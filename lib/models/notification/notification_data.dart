// lib/models/notification/notification_data.dart

class NotificationData {
  final String id;
  final String message;
  final DateTime time;
  final String user;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationData({
    required this.id,
    required this.message,
    required this.time,
    required this.user,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      time: DateTime.tryParse(json['time_'] ?? '') ?? DateTime.now(),
      user: json['user'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Added toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'time_': time.toIso8601String(),
      'user': user,
      'type': type,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isUnread => status == 'Unread';
}
