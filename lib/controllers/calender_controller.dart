// lib/controllers/calendar_controller.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';

enum CalendarView { daily, weekly, monthly, yearly }

class CalendarController extends ChangeNotifier {
  final List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  CalendarView _currentView = CalendarView.daily;
  final Color _primaryColor = const Color(0xFF6C63FF);
  final Color _secondaryColor = const Color(0xFF8B5CF6);

  // Getters
  List<Task> get tasks => _tasks;
  DateTime get selectedDate => _selectedDate;
  CalendarView get currentView => _currentView;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;

  // Task Management
  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _sortTasks();
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  // View Management
  void changeView(CalendarView view) {
    _currentView = view;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Task Filtering
  List<Task> getTasksForDate(DateTime date) {
    return _tasks
        .where((task) =>
            task.date.year == date.year &&
            task.date.month == date.month &&
            task.date.day == date.day)
        .toList();
  }

  List<Task> getTasksForWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _tasks
        .where((task) =>
            task.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            task.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .toList();
  }

  List<Task> getTasksForMonth(DateTime date) {
    return _tasks
        .where((task) =>
            task.date.year == date.year && task.date.month == date.month)
        .toList();
  }

  List<Task> getTasksForYear(DateTime date) {
    return _tasks.where((task) => task.date.year == date.year).toList();
  }

  // Helper Methods
  void _sortTasks() {
    _tasks.sort((a, b) {
      final timeComparison = _compareTimeOfDay(a.startTime, b.startTime);
      if (timeComparison != 0) return timeComparison;
      return a.title.compareTo(b.title);
    });
  }

  int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    if (a.hour != b.hour) return a.hour.compareTo(b.hour);
    return a.minute.compareTo(b.minute);
  }

  // Calendar Utilities
  List<DateTime> getWeekDays(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  List<DateTime> getMonthDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;

    final daysInMonth = List<DateTime>.generate(
      lastDayOfMonth.day,
      (i) => DateTime(date.year, date.month, i + 1),
    );

    final previousMonthDays = List<DateTime>.generate(
      firstWeekday - 1,
      (i) => firstDayOfMonth.subtract(Duration(days: firstWeekday - i - 1)),
    );

    return [...previousMonthDays, ...daysInMonth];
  }

  List<DateTime> getYearMonths(DateTime date) {
    return List.generate(12, (index) => DateTime(date.year, index + 1));
  }

  // View Helpers
  String getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[date.month - 1];
  }

  String getWeekDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
