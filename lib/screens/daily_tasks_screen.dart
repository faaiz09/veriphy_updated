// lib/screens/daily_tasks_screen.dart
// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
import '../models/task_model.dart';
import 'add_task_dialog.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  CalendarView _currentView = CalendarView.daily;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarController(),
      child: Builder(
        builder: (context) {
          final controller = Provider.of<CalendarController>(context);

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildViewSelector(),
                  Expanded(child: _buildTaskList(context)),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddTaskDialog(context),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final tasks = controller.getTasksForDate(controller.selectedDate);

    return tasks.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) =>
                _buildTaskItem(context, tasks[index]),
          );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () => _showEditTaskDialog(context, task),
      child: Dismissible(
        key: Key(task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          Provider.of<CalendarController>(context, listen: false)
              .deleteTask(task.id);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              Icons.drag_indicator,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${task.startTime.format(context)} - ${task.endTime.format(context)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks for today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getMonthName(controller.selectedDate),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.selectedDate.year.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  final newDate = controller.selectedDate.subtract(
                    _currentView == CalendarView.daily
                        ? const Duration(days: 1)
                        : const Duration(days: 7),
                  );
                  controller.selectDate(newDate);
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  final newDate = controller.selectedDate.add(
                    _currentView == CalendarView.daily
                        ? const Duration(days: 1)
                        : const Duration(days: 7),
                  );
                  controller.selectDate(newDate);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var view in CalendarView.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(view.toString().split('.').last),
                selected: _currentView == view,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _currentView = view);
                  }
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: _currentView == view ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) async {
    final contextRef = context; // Store context reference
    if (!mounted) return;

    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: AddTaskDialog(
              selectedDate:
                  Provider.of<CalendarController>(contextRef, listen: false)
                      .selectedDate,
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      final controller =
          Provider.of<CalendarController>(context, listen: false);
      final newTask = Task(
        id: DateTime.now().toString(),
        title: result['title'],
        subtitle: result['subtitle'],
        startTime: result['startTime'],
        endTime: result['endTime'],
        type: result['type'],
        color: controller.primaryColor,
        date: controller.selectedDate,
      );
      controller.addTask(newTask);
    }
  }

  void _showEditTaskDialog(BuildContext context, Task task) async {
    final contextRef = context; // Store context reference
    if (!mounted) return;

    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: AddTaskDialog(
              selectedDate: task.date,
              initialData: task.toMap(),
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      final controller =
          Provider.of<CalendarController>(contextRef, listen: false);
      final updatedTask = task.copyWith(
        title: result['title'],
        subtitle: result['subtitle'],
        startTime: result['startTime'],
        endTime: result['endTime'],
        type: result['type'],
      );
      controller.updateTask(updatedTask);
    }
  }
}
