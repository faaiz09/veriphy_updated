// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_veriphy/widgets/add_event_dialog.dart';
import 'package:rm_veriphy/widgets/calendar_views/daily_view.dart';
import 'package:rm_veriphy/widgets/calendar_views/monthly_view.dart';
import 'package:rm_veriphy/widgets/calendar_views/weekly_view.dart';
import 'package:rm_veriphy/widgets/calendar_views/yearly_view.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/controllers/calender_controller.dart';

enum CalendarView { daily, weekly, monthly, yearly }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  CalendarView _currentView = CalendarView.monthly;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentView = CalendarView.values[_tabController.index];
        });
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarController(),
      child: Consumer<CalendarController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: _buildAppBar(context, controller),
            body: Column(
              children: [
                _buildViewSelector(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      DailyView(),
                      WeeklyView(),
                      MonthlyView(),
                      YearlyView(),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddEventDialog(context, controller),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, CalendarController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Text(
            DateFormat('MMMM').format(controller.selectedDate),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            controller.selectedDate.year.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.today),
          onPressed: () => controller.selectDate(DateTime.now()),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Implement menu functionality
          },
        ),
      ],
    );
  }

  Widget _buildViewSelector() {
    return Container(
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
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(icon: Icon(Icons.view_day), text: "Day"),
          Tab(icon: Icon(Icons.view_week), text: "Week"),
          Tab(icon: Icon(Icons.calendar_view_month), text: "Month"),
          Tab(icon: Icon(Icons.calendar_today), text: "Year"),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, CalendarController controller) async {
    final event = await showDialog<CalendarEvent>(
      context: context,
      builder: (context) => AddEventDialog(selectedDate: controller.selectedDate),
    );

    if (event != null) {
      controller.addEvent(event);
    }
  }
}

extension on CalendarController {
  void addEvent(CalendarEvent event) {}
}

class CalendarEvent {
  final String title;
  final EventType type;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;
  final DateTime date;
  final String id;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.date,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

enum EventType { meeting, other }
