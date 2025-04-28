// lib/widgets/calendar_views/weekly_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
import 'package:rm_veriphy/screens/add_task_dialog.dart';
import '../../models/task_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CalendarController>();
    final weekDays = controller.getWeekDays(controller.selectedDate);

    return Column(
      children: [
        _buildWeekNavigator(context, controller),
        _buildWeekHeader(context, weekDays),
        _buildWeekCalendar(context, weekDays),
        const Divider(height: 1),
        Expanded(
          child: _buildDayTasks(context),
        ),
      ],
    );
  }

  Widget _buildWeekNavigator(BuildContext context, CalendarController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final newDate = controller.selectedDate.subtract(const Duration(days: 7));
              controller.selectDate(newDate);
            },
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
                    'Week ${DateFormat('w').format(controller.selectedDate)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${DateFormat('MMM').format(controller.selectedDate)} ${controller.selectedDate.year}',
                    style: TextStyle(
                      color: Colors.grey.withAlpha(153),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newDate = controller.selectedDate.add(const Duration(days: 7));
              controller.selectDate(newDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(BuildContext context, List<DateTime> weekDays) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekDays.map((date) => _buildDayHeader(context, date)).toList(),
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, DateTime date) {
    final controller = context.watch<CalendarController>();
    final isSelected = date.day == controller.selectedDate.day && 
                       date.month == controller.selectedDate.month &&
                       date.year == controller.selectedDate.year;
    final isToday = date.day == DateTime.now().day && 
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        width: MediaQuery.of(context).size.width / 7 - 10,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? controller.primaryColor.withAlpha(26) 
              : isToday 
                  ? controller.primaryColor.withAlpha(51) 
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              DateFormat('E').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.withAlpha(153),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? Colors.white.withAlpha(77) 
                    : isToday 
                        ? controller.primaryColor.withAlpha(51) 
                        : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : isToday 
                            ? controller.primaryColor 
                            : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context, List<DateTime> weekDays) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final date = weekDays[index];
          final tasks = context.read<CalendarController>().getTasksForDate(date);
          return Container(
            width: MediaQuery.of(context).size.width / 7,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                if (tasks.isNotEmpty) ...[
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.read<CalendarController>().primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
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
              color: Colors.grey.withAlpha(102),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks for ${DateFormat('EEEE, MMMM d').format(controller.selectedDate)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withAlpha(153),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
              onPressed: () => _addNewTask(context, controller.selectedDate),
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: task.color.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: task.color.withAlpha(77)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            task.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.subtitle,
                  style: TextStyle(
                    color: Colors.grey.withAlpha(153),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.withAlpha(153)),
                  const SizedBox(width: 4),
                  Text(
                    '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                    style: TextStyle(
                      color: Colors.grey.withAlpha(153),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editTask(context, task),
          ),
          onTap: () => _editTask(context, task),
        ),
      ),
    );
  }

  void _addNewTask(BuildContext context, DateTime selectedDate) async {
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddTaskDialog(selectedDate: selectedDate),
      ),
    );

    if (result != null) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result['title'],
        subtitle: result['subtitle'] ?? '',
        date: selectedDate,
        startTime: result['startTime'],
        endTime: result['endTime'],
        type: result['type'],
        color: result['color'] ?? Colors.blue,
      );
      Provider.of<CalendarController>(context, listen: false).addTask(task);
    }
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
