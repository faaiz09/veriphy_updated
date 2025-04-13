// lib/widgets/task/task_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/task_provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';

class TaskListItem extends StatelessWidget {
  final dynamic task;

  const TaskListItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(task['task_name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['description'] ?? ''),
            const SizedBox(height: 4),
            Text(
              'Due: ${task['due_date'] ?? 'Not set'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: _buildStatusButton(context),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    final status = task['status']?.toString().toLowerCase() ?? '';
    final isCompleted = status == 'completed';

    return TextButton(
      onPressed: isCompleted ? null : () => _handleStatusUpdate(context),
      style: TextButton.styleFrom(
        foregroundColor:
            isCompleted ? Colors.green : Theme.of(context).primaryColor,
      ),
      child: Text(isCompleted ? 'Completed' : 'Mark Complete'),
    );
  }

  Future<void> _handleStatusUpdate(BuildContext context) async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;

    try {
      await context.read<TaskProvider>().updateTask(
            userId: userId,
            taskId: task['id'].toString(),
            status: 'Completed',
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task completed successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $e')),
        );
      }
    }
  }
}
