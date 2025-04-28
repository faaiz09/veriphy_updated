// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/providers/dashboard_provider.dart';
import 'package:rm_veriphy/providers/task_provider.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    final user = context.watch<AuthProvider>().user;
    final dashboard = context.watch<DashboardProvider>();
    final tasks = context.watch<TaskProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Good morning, ${user?.firstName ?? 'User'}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Today's Overview
              Text(
                "Today's Overview",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _OverviewCard(
                    icon: Icons.insert_drive_file_outlined,
                    label: 'Pending Documents',
                    count: dashboard.pendingDocuments,
                    badgeColor: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _OverviewCard(
                    icon: Icons.schedule_outlined,
                    label: 'Follow-Ups',
                    count: tasks.pendingTasksCount,
                    badgeColor: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _OverviewCard(
                    icon: Icons.warning_amber_rounded,
                    label: 'Escalations',
                    count: tasks.pendingEscalations,
                    badgeColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'New\nOnboarding',
                  ),
                  _QuickActionButton(
                    icon: Icons.inbox_outlined,
                    label: 'Approvals',
                  ),
                  _QuickActionButton(
                    icon: Icons.bar_chart_outlined,
                    label: 'Reports',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color badgeColor;

  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CircleAvatar(
            radius: 14,
            backgroundColor: badgeColor,
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 30, color: primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
