// lib/widgets/calendar_views/monthly_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
// import '../../models/task_model.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final days = controller.getMonthDays(controller.selectedDate);

    return Column(
      children: [
        _buildWeekDayHeader(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              return _buildDayCell(context, days[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayHeader() {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays
            .map(
              (day) => Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date) {
    final controller = Provider.of<CalendarController>(context);
    final isSelected = date.day == controller.selectedDate.day &&
        date.month == controller.selectedDate.month;
    final isCurrentMonth = date.month == controller.selectedDate.month;
    final tasks = controller.getTasksForDate(date);

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : tasks.isNotEmpty
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: tasks.isNotEmpty && !isSelected
              ? Border.all(color: Theme.of(context).primaryColor)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: !isCurrentMonth
                      ? Colors.grey
                      : isSelected
                          ? Colors.white
                          : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
            if (tasks.isNotEmpty)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
