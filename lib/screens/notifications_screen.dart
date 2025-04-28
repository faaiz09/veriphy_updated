//lib/screens/notifications_screen.dart

// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:rm_veriphy/models/notification.dart';
// import 'package:rm_veriphy/providers/notifications_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Document Verification Required',
      message: 'New document uploaded by John Doe needs your review.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.document,
    ),
    NotificationItem(
      id: '2',
      title: 'Task Deadline Approaching',
      message: 'The task "Review Application #123" is due in 2 hours.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.task,
    ),
    NotificationItem(
      id: '3',
      title: 'New Message',
      message: 'You have a new message from Sarah Smith regarding case #456.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.message,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'System Update',
      message: 'New features have been added to the document review system.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.update,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Customer Alert',
      message: 'Customer Jane Doe has requested an urgent callback.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      type: NotificationType.alert,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return _notifications
        .where((n) => n.type.name == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.copyWith(isRead: true);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      'All',
      'Unread',
      ...NotificationType.values.map((t) => t.name.capitalize())
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                }
              },
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'All'
                ? 'No notifications'
                : 'No ${_selectedFilter.toLowerCase()} notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return Dismissible(
          key: Key(notification.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            setState(() {
              _notifications.removeWhere((n) => n.id == notification.id);
            });
          },
          child: NotificationCard(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
          ),
        );
      },
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isRead: true);
      }
    });

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.document:
        // Navigate to document screen
        break;
      case NotificationType.task:
        // Navigate to task screen
        break;
      case NotificationType.message:
        // Navigate to chat screen
        break;
      default:
        break;
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: notification.isRead ? 0 : 2,
      color: notification.isRead
          ? theme.cardColor
          : theme.primaryColor.withAlpha(13),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: notification.type.getColor(context).withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        notification.type.icon,
        color: notification.type.getColor(context),
        size: 20,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return timeago.format(timestamp, allowFromNow: true);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(timestamp);
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
