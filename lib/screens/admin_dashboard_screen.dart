// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final now = DateTime.now();
    final formattedDate =
        "${_weekdayName(now.weekday)}, ${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Good Morning',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                // Summary Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SummaryCard(label: 'RMs Ready', value: '18'),
                    _SummaryCard(label: 'Tasks Due', value: '12'),
                    _SummaryCard(label: 'Cases Escalated', value: '5'),
                  ],
                ),
                const SizedBox(height: 24),
                // Appointments Section
                Text(
                  "Today's Appointments",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _AppointmentTile(
                    name: 'Lina Shah',
                    count: 4,
                    image: 'https://randomuser.me/api/portraits/women/1.jpg'),
                _AppointmentTile(
                    name: 'Priya Jain',
                    count: 3,
                    image: 'https://randomuser.me/api/portraits/women/2.jpg'),
                _AppointmentTile(
                    name: 'Deepak Kumar',
                    count: 3,
                    image: 'https://randomuser.me/api/portraits/men/1.jpg'),
                const SizedBox(height: 8),
                _SimpleTile(
                    icon: Icons.calendar_today, label: "Today's appointments"),
                _SimpleTile(icon: Icons.list_alt, label: 'View All tommss'),
                const SizedBox(height: 32),
                // RM Readiness Section
                Text(
                  'RM Readiness',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _CircularPercent(percent: 0.8),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('130 Activities Today',
                            style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text('12 Tasks Due', style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text('5 Cases Escalated',
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Team Activity
                Text(
                  'Team Activity',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _TeamActivityTile(
                    name: 'Lina Shah',
                    appointments: 4,
                    tasks: 12,
                    image: 'https://randomuser.me/api/portraits/women/1.jpg'),
                _TeamActivityTile(
                    name: 'Priya Jain',
                    appointments: 5,
                    tasks: 9,
                    image: 'https://randomuser.me/api/portraits/women/2.jpg'),
                _TeamActivityTile(
                    name: 'Prem Das',
                    appointments: 7,
                    tasks: 3,
                    image: 'https://randomuser.me/api/portraits/men/2.jpg'),
                const SizedBox(height: 32),
                // Activity Breakdown
                Text(
                  'Activity Breakdown',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _BarChartPlaceholder(),
                const SizedBox(height: 32),
                // Upcoming Tasks
                Text(
                  'Upcoming Tasks',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _UpcomingTaskTile(
                    title: 'Drlya Jain',
                    subtitle: 'Document Follow up',
                    time: '11:00 AM'),
                _UpcomingTaskTile(
                    title: 'Case Review',
                    subtitle: 'Case Review',
                    time: '1:30 PM'),
                _UpcomingTaskTile(
                    title: 'Rajesh Singh',
                    subtitle: 'KYC Verification',
                    time: '2:00 PM'),
                const SizedBox(height: 32),
                // Escalations
                Text(
                  'Escalations',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _EscalationTile(
                    name: 'Sudha Patel',
                    count: 2,
                    status: 'Ready',
                    appointments: 4),
                _EscalationTile(
                    name: 'Deepak Kumar',
                    count: 1,
                    status: 'Ready',
                    appointments: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _weekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(weekday - 1) % 7];
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.green[50],
      elevation: 0,
      child: Container(
        width: 100,
        height: 70,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.green[700], fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String name;
  final int count;
  final String image;
  const _AppointmentTile(
      {required this.name, required this.count, required this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(image)),
      title: Text(name),
      trailing: Text('$count appointments',
          style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SimpleTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(label),
    );
  }
}

class _CircularPercent extends StatelessWidget {
  final double percent;
  const _CircularPercent({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: percent,
            color: Colors.green[700],
            backgroundColor: Colors.green[100],
            strokeWidth: 8,
          ),
        ),
        Text('${(percent * 100).toInt()}%\nReady',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _TeamActivityTile extends StatelessWidget {
  final String name;
  final int appointments;
  final int tasks;
  final String image;
  const _TeamActivityTile(
      {required this.name,
      required this.appointments,
      required this.tasks,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(image)),
      title: Text(name),
      subtitle: Text('$appointments Appointments'),
      trailing: Text('$tasks Tasks',
          style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _BarChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for chart
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text('Bar Chart Placeholder',
            style: TextStyle(color: Colors.green[700])),
      ),
    );
  }
}

class _UpcomingTaskTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  const _UpcomingTaskTile(
      {required this.title, required this.subtitle, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.task_alt, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

class _EscalationTile extends StatelessWidget {
  final String name;
  final int count;
  final String status;
  final int appointments;
  const _EscalationTile(
      {required this.name,
      required this.count,
      required this.status,
      required this.appointments});

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Ready' ? Colors.green : Colors.orange;
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(Icons.person, color: Colors.white)),
      title: Text(name),
      subtitle: Text(
          '$count Escalation${count > 1 ? 's' : ''} • $appointments appointment${appointments > 1 ? 's' : ''}'),
      trailing: Text(status,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
    );
  }
}
