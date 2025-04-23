// lib/widgets/calendar_views/yearly_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';
import 'package:intl/intl.dart';

class YearlyView extends StatelessWidget {
  const YearlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);
    final months = controller.getYearMonths(controller.selectedDate);

    return Column(
      children: [
        _buildYearNavigator(context, controller),
        Expanded(
          child: GridView.builder(
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
          ),
        ),
      ],
    );
  }

  Widget _buildYearNavigator(BuildContext context, CalendarController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              final newDate = DateTime(controller.selectedDate.year - 1, 1, 1);
              controller.selectDate(newDate);
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => _buildYearPickerDialog(context, controller),
                );
                if (picked != null) {
                  controller.selectDate(picked);
                }
              },
              child: Text(
                controller.selectedDate.year.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newDate = DateTime(controller.selectedDate.year + 1, 1, 1);
              controller.selectDate(newDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYearPickerDialog(BuildContext context, CalendarController controller) {
    final currentYear = controller.selectedDate.year;
    final startYear = currentYear - 50;
    final endYear = currentYear + 50;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Select Year',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: endYear - startYear + 1,
                itemBuilder: (context, index) {
                  final year = startYear + index;
                  final isSelected = year == currentYear;
                  return ListTile(
                    title: Text(
                      year.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).primaryColor : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, DateTime(year, controller.selectedDate.month, 1));
                    },
                    selected: isSelected,
                    selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCard(BuildContext context, DateTime month) {
    final controller = Provider.of<CalendarController>(context);
    final isSelected = month.month == controller.selectedDate.month && 
                       month.year == controller.selectedDate.year;
    final isCurrentMonth = month.month == DateTime.now().month && 
                          month.year == DateTime.now().year;
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
              : isCurrentMonth
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : isCurrentMonth
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (tasks.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM').format(month),
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : isCurrentMonth
                            ? Theme.of(context).primaryColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tasks.isEmpty ? 'No tasks' : '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white
                          : isCurrentMonth
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                    ),
                  ),
                ),
                if (tasks.isNotEmpty) ...[
                  const SizedBox(height: 8),
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
                              ? Colors.white.withOpacity(0.8)
                              : tasks[i].color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
