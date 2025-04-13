// lib/widgets/calendar_views/yearly_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';

class YearlyView extends StatelessWidget {
  const YearlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final months = controller.getYearMonths(controller.selectedDate);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return _buildMonthCard(context, months[index]);
      },
    );
  }

  Widget _buildMonthCard(BuildContext context, DateTime month) {
    final controller = Provider.of<CalendarController>(context);
    final isSelected = month.month == controller.selectedDate.month;
    final tasks = controller.getTasksForMonth(month);

    return InkWell(
      onTap: () {
        controller.selectDate(month);
        controller.changeView(CalendarView.monthly);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : tasks.isNotEmpty
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.getMonthName(month),
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${tasks.length} tasks',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
