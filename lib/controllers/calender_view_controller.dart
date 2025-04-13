// lib/controllers/calendar_view_controller.dart
import 'package:flutter/material.dart';

enum CalendarViewType {
  daily,
  weekly,
  monthly,
  yearly;

  String get displayName => toString().split('.').last.capitalize();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CalendarViewController extends ChangeNotifier {
  CalendarViewType _viewType = CalendarViewType.monthly;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<TaskModel>> _tasks = {};

  CalendarViewType get viewType => _viewType;
  DateTime get selectedDate => _selectedDate;
  Map<DateTime, List<TaskModel>> get tasks => _tasks;

  void changeViewType(CalendarViewType type) {
    _viewType = type;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addTask(TaskModel task) {
    if (_tasks[task.date] == null) {
      _tasks[task.date] = [];
    }
    _tasks[task.date]!.add(task);
    notifyListeners();
  }

  List<TaskModel> getTasksForDate(DateTime date) {
    return _tasks[DateTime(date.year, date.month, date.day)] ?? [];
  }
}

class TaskModel {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String note;

  TaskModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.note,
  });
}
