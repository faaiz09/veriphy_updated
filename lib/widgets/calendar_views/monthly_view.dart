// lib/widgets/calendar_views/monthly_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
import 'package:intl/intl.dart';
import 'package:rm_veriphy/screens/add_task_dialog.dart';
import '../../models/task_model.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final days = controller.getMonthDays(controller.selectedDate);

    return Column(
      children: [
        _buildMonthNavigator(context, controller),
        _buildWeekDayHeader(),
        Expanded(
          child: _buildCalendarGrid(context, days),
        ),
        if (controller.getTasksForDate(controller.selectedDate).isNotEmpty)
          _buildSelectedDayTasks(context),
      ],
    );
  }

  Widget _buildMonthNavigator(
      BuildContext context, CalendarController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            onPressed: () {
              final newDate = DateTime(
                controller.selectedDate.year,
                controller.selectedDate.month - 1,
                1,
              );
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
                  initialDatePickerMode: DatePickerMode.year,
                );
                if (picked != null) {
                  controller.selectDate(picked);
                }
              },
              child: Text(
                DateFormat('MMMM yyyy').format(controller.selectedDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newDate = DateTime(
                controller.selectedDate.year,
                controller.selectedDate.month + 1,
                1,
              );
              controller.selectDate(newDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeader() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays
            .map(
              (day) => Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, List<DateTime> days) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        return _buildDayCell(context, days[index]);
      },
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date) {
    final controller = Provider.of<CalendarController>(context);
    final isSelected = date.day == controller.selectedDate.day &&
        date.month == controller.selectedDate.month &&
        date.year == controller.selectedDate.year;
    final isCurrentMonth = date.month == controller.selectedDate.month;
    final isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;
    final tasks = controller.getTasksForDate(date);

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : isToday
                  ? Theme.of(context).primaryColor.withAlpha(26)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: Theme.of(context).primaryColor)
              : null,
          boxShadow: isSelected || isToday
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withAlpha(51),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: TextStyle(
                color: !isCurrentMonth
                    ? Colors.grey.withAlpha(128)
                    : isSelected
                        ? Colors.white.withAlpha(204)
                        : isToday
                            ? Theme.of(context).primaryColor
                            : null,
                fontWeight: isSelected || isToday ? FontWeight.bold : null,
                fontSize: 14,
              ),
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  tasks.length > 3 ? 3 : tasks.length,
                  (i) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withAlpha(204)
                          : tasks[i].color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (tasks.length > 3)
                Text(
                  '+${tasks.length - 3}',
                  style: TextStyle(
                    fontSize: 8,
                    color: isSelected ? Colors.white : Colors.grey.withAlpha(51),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayTasks(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final tasks = controller.getTasksForDate(controller.selectedDate);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, MMMM d').format(controller.selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                onPressed: () => _addNewTask(context, controller.selectedDate),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskItem(context, task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.withAlpha(128),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 16),
            onPressed: () => _showTaskOptions(context, task),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                _editTask(context, task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Task',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteTask(context, task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTask(BuildContext context, DateTime selectedDate) async {
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      Provider.of<CalendarController>(context, listen: false)
          .updateTask(updatedTask);
    }
  }

  void _deleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<CalendarController>(context, listen: false)
                  .deleteTask(task.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
