// lib/providers/notifications_provider.dart

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/models/notification/notification_data.dart';
import 'package:rm_veriphy/services/notification_service.dart';

class NotificationsProvider with ChangeNotifier {
  final NotificationService _notificationService;

  List<NotificationData> _notifications = [];
  bool _isLoading = false;
  String? _error;

  NotificationsProvider(this._notificationService);

  List<NotificationData> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => n.isUnread).length;

  Future<void> loadNotifications({
    required DateTime fromDate,
    DateTime? toDate,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _notifications = await _notificationService.getNotifications(
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.updateNotificationStatus(
        notificationId: notificationId,
        status: 'Read',
      );

      // Update local notification status
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = NotificationData.fromJson({
          ..._notifications[index].toJson(),
          'status': 'Read',
        });
        _notifications[index] = updatedNotification;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Update all unread notifications
      for (var notification in _notifications.where((n) => n.isUnread)) {
        await markAsRead(notification.id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
