// lib/widgets/calendar_views/daily_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/calender_controller.dart';
import '../../models/task_model.dart';
import '../../screens/add_task_dialog.dart';
import 'package:intl/intl.dart';

class DailyView extends StatelessWidget {
  const DailyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final tasks = controller.getTasksForDate(controller.selectedDate);

    return Column(
      children: [
        _buildDateHeader(context),
        _buildTimelineHeader(context),
        Expanded(
          child: tasks.isEmpty
              ? _buildEmptyState()
              : _buildTasksTimeline(context, tasks),
        ),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => controller.selectDate(
              controller.selectedDate.subtract(const Duration(days: 1)),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  controller.selectDate(picked);
                }
              },
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE').format(controller.selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM d, y').format(controller.selectedDate),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => controller.selectDate(
              controller.selectedDate.add(const Duration(days: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 60),
          Expanded(
            child: Text(
              'Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
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
            'No tasks scheduled for today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a new task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTimeline(BuildContext context, List<Task> tasks) {
    // Sort tasks by start time
    tasks.sort((a, b) {
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskTimelineItem(context, task, index == 0, index == tasks.length - 1);
      },
    );
  }

  Widget _buildTaskTimelineItem(BuildContext context, Task task, bool isFirst, bool isLast) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        Provider.of<CalendarController>(context, listen: false)
            .deleteTask(task.id);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  '${task.startTime.hour.toString().padLeft(2, '0')}:${task.startTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 100,
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(26),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _editTask(context, task),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: task.color.withAlpha(128),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.color.withAlpha(77),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: task.color.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.type.name,
                            style: TextStyle(
                              color: task.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_horiz, size: 20),
                          onPressed: () => _editTask(context, task),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (task.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editTask(BuildContext context, Task task) async {
    final contextRef = context;
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddTaskDialog(
          selectedDate: task.date,
          initialData: task.toMap(),
        ),
      ),
    );

    if (result != null) {
      final updatedTask = task.copyWith(
        title: result['title'],
        subtitle: result['subtitle'],
        startTime: result['startTime'],
        endTime: result['endTime'],
        type: result['type'],
      );
      Provider.of<CalendarController>(contextRef, listen: false)
          .updateTask(updatedTask);
    }
  }
}

extension on String {
  String get name => this;
}
