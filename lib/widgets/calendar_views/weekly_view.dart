// lib/widgets/calendar_views/weekly_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
import 'package:rm_veriphy/screens/add_task_dialog.dart';
import '../../models/task_model.dart';
import 'package:provider/provider.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CalendarController>();
    final weekDays = controller.getWeekDays(controller.selectedDate);

    return Column(
      children: [
        _buildWeekHeader(context, weekDays),
        _buildWeekCalendar(context, weekDays),
        const Divider(height: 1),
        Expanded(
          child: _buildDayTasks(context),
        ),
      ],
    );
  }

  Widget _buildWeekHeader(BuildContext context, List<DateTime> weekDays) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            weekDays.map((date) => _buildDayHeader(context, date)).toList(),
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, DateTime date) {
    final controller = context.watch<CalendarController>();
    final isSelected = date.day == controller.selectedDate.day;

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        width: 40,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? controller.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              controller.getWeekDayName(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context, List<DateTime> weekDays) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final date = weekDays[index];
          final tasks =
              context.read<CalendarController>().getTasksForDate(date);
          return Container(
            width: MediaQuery.of(context).size.width / 7,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: tasks.isNotEmpty
                        ? context.read<CalendarController>().primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (tasks.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${tasks.length} tasks',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayTasks(BuildContext context) {
    final controller = context.watch<CalendarController>();
    final tasks = controller.getTasksForDate(controller.selectedDate);

    if (tasks.isEmpty) {
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
              'No tasks for this day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(context, task, Key(task.id));
      },
      onReorder: (oldIndex, newIndex) {
        controller.reorderTasks(oldIndex, newIndex);
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, Key key) {
    return Dismissible(
      key: key,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<CalendarController>().deleteTask(task.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: task.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: task.color.withOpacity(0.3)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            Icons.drag_indicator,
            color: Colors.grey[400],
          ),
          title: Text(
            task.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${task.startTime.format(context)} - ${task.endTime.format(context)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
          onTap: () => _editTask(context, task),
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
