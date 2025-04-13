// lib/models/task_model.dart
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String subtitle;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String type;
  final Color color;
  final DateTime date;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.color,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'endTimeHour': endTime.hour,
      'endTimeMinute': endTime.minute,
      'type': type,
      'color': color.value,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'] ?? '',
      startTime: TimeOfDay(
        hour: map['startTimeHour'] ?? 0,
        minute: map['startTimeMinute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: map['endTimeHour'] ?? 0,
        minute: map['endTimeMinute'] ?? 0,
      ),
      type: map['type'],
      color: Color(map['color']),
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Task copyWith({
    String? title,
    String? subtitle,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? type,
    Color? color,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      color: color ?? this.color,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
