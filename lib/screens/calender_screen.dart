import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_veriphy/widgets/add_event_dialog.dart';

enum CalendarView { month, multiMonth, agenda }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  CalendarView _currentView = CalendarView.month;
  DateTime _selectedDate = DateTime.now();
  final DateTime _displayedMonth = DateTime.now();

  // Sample event data - Replace with your actual data structure
  final Map<DateTime, List<CalendarEvent>> _events = {
    DateTime.now(): [
      CalendarEvent(
        title: 'Team Meeting',
        type: EventType.meeting,
        startTime: TimeOfDay.now(),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        color: Colors.blue,
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
      CalendarEvent(
        title: 'Other Event',
        type: EventType.other,
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        color: Colors.red,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildViewSelector(),
          _buildCalendarContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text(
            DateFormat('MMMM').format(_displayedMonth),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _displayedMonth.year.toString(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (final view in CalendarView.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(view.name),
                selected: _currentView == view,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _currentView = view);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case CalendarView.month:
        return _buildMonthView();
      case CalendarView.multiMonth:
        return _buildMultiMonthView();
      case CalendarView.agenda:
        return _buildAgendaView();
    }
  }

  Widget _buildMonthView() {
    return Expanded(
      child: Column(
        children: [
          _buildWeekDayHeader(),
          _buildMonthGrid(),
          if (_events[_selectedDate]?.isNotEmpty ?? false)
            _buildEventList(_events[_selectedDate]!),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
          Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 42, // 6 weeks * 7 days
        itemBuilder: (context, index) {
          final int day = index - firstWeekday + 1;
          final currentDate =
              DateTime(_displayedMonth.year, _displayedMonth.month, day);
          final isToday = _isToday(currentDate);
          final isSelected = _isSelectedDate(currentDate);
          final hasEvents = _events[currentDate]?.isNotEmpty ?? false;

          return _buildDayCell(
            day: day,
            isToday: isToday,
            isSelected: isSelected,
            hasEvents: hasEvents,
            isEnabled: day > 0 && day <= daysInMonth,
          );
        },
      ),
    );
  }

  Widget _buildDayCell({
    required int day,
    required bool isToday,
    required bool isSelected,
    required bool hasEvents,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: isEnabled
          ? () => _selectDate(
              DateTime(_displayedMonth.year, _displayedMonth.month, day))
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          border: isToday
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnabled ? day.toString() : '',
              style: TextStyle(
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                color: isEnabled ? null : Colors.grey,
              ),
            ),
            if (hasEvents)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _events[DateTime(
                        _displayedMonth.year, _displayedMonth.month, day)]!
                    .take(3)
                    .map((event) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: event.color,
                            shape: BoxShape.circle,
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<CalendarEvent> events) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(
                _getEventIcon(event.type),
                color: event.color,
              ),
              title: Text(event.title),
              subtitle: Text(
                '${event.startTime.format(context)} - ${event.endTime.format(context)}',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMultiMonthView() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final year = _displayedMonth.year;
          final firstDayOfMonth = DateTime(year, month, 1);
          final daysInMonth = DateTime(year, month + 1, 0).day;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM').format(firstDayOfMonth),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: daysInMonth + firstDayOfMonth.weekday - 1,
                  itemBuilder: (context, dayIndex) {
                    final day = dayIndex - firstDayOfMonth.weekday + 2;
                    final currentDate = DateTime(year, month, day);
                    final isToday = _isToday(currentDate);
                    final isSelected = _isSelectedDate(currentDate);
                    final hasEvents = _events[currentDate]?.isNotEmpty ?? false;

                    return _buildDayCell(
                      day: day,
                      isToday: isToday,
                      isSelected: isSelected,
                      hasEvents: hasEvents,
                      isEnabled: day > 0 && day <= daysInMonth,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAgendaView() {
    final sortedEvents = _getSortedEvents();
    return Expanded(
      child: ListView.builder(
        itemCount: sortedEvents.length,
        itemBuilder: (context, index) {
          final date = sortedEvents.keys.elementAt(index);
          final events = sortedEvents[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  DateFormat('EEEE, MMMM d').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ...events.map((event) => _buildAgendaEventTile(event)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAgendaEventTile(CalendarEvent event) {
    return ListTile(
      leading: Container(
        width: 4,
        height: 40,
        color: event.color,
      ),
      title: Text(event.title),
      subtitle: Text(
        '${event.startTime.format(context)} - ${event.endTime.format(context)}',
      ),
      trailing: Icon(_getEventIcon(event.type)),
    );
  }

  void _showAddEventDialog() async {
    final event = await showDialog<CalendarEvent>(
      context: context,
      builder: (context) => AddEventDialog(selectedDate: _selectedDate),
    );

    if (event != null) {
      setState(() {
        if (_events[_selectedDate] == null) {
          _events[_selectedDate] = [];
        }
        _events[_selectedDate]!.add(event);
      });
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.meeting:
        return Icons.video_call;
      case EventType.other:
        return Icons.event;
      default:
        return Icons.event;
    }
  }

  Map<DateTime, List<CalendarEvent>> _getSortedEvents() {
    final sortedKeys = _events.keys.toList()..sort();
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, _events[key]!)),
    );
  }
}

enum EventType { meeting, other }

class CalendarEvent {
  final String title;
  final EventType type;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}
