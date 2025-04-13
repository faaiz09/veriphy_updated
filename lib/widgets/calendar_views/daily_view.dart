// lib/widgets/calendar_views/daily_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/calender_controller.dart';
import '../../models/task_model.dart';
import '../../screens/add_task_dialog.dart';

class DailyView extends StatelessWidget {
  const DailyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final tasks = controller.getTasksForDate(controller.selectedDate);

    return Column(
      children: [
        _buildDateHeader(context),
        Expanded(
          child: tasks.isEmpty
              ? _buildEmptyState()
              : _buildTasksList(context, tasks),
        ),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Schedule Today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          Text(
            controller.getWeekDayName(controller.selectedDate),
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<Task> tasks) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      onReorder: (oldIndex, newIndex) {
        Provider.of<CalendarController>(context, listen: false)
            .reorderTasks(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(context, task, Key(task.id));
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, Key key) {
    return Dismissible(
      key: key,
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeColumn(task),
            Expanded(child: _buildTaskContent(context, task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(Task task) {
    return SizedBox(
      width: 60,
      child: Text(
        '${task.startTime.hour.toString().padLeft(2, '0')}:${task.startTime.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTaskContent(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () => _editTask(context, task),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: task.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: task.color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            Icon(
              Icons.drag_handle,
              color: Colors.grey[400],
            ),
          ],
        ),
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
