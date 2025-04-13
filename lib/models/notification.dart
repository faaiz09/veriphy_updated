// lib/models/notification.dart
import 'package:flutter/material.dart';

enum NotificationType {
  document,
  task,
  message,
  alert,
  update,
  reminder;

  IconData get icon {
    switch (this) {
      case NotificationType.document:
        return Icons.description;
      case NotificationType.task:
        return Icons.task;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.alert:
        return Icons.warning_amber;
      case NotificationType.update:
        return Icons.update;
      case NotificationType.reminder:
        return Icons.notifications_active;
    }
  }

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (this) {
      case NotificationType.document:
        return Colors.blue;
      case NotificationType.task:
        return Colors.green;
      case NotificationType.message:
        return theme.primaryColor;
      case NotificationType.alert:
        return Colors.orange;
      case NotificationType.update:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.red;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  NotificationItem copyWith({
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.alert,
      ),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      'data': data,
    };
  }
}
