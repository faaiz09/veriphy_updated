// lib/widgets/task/create_task_dialog.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/task_provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/models/task/task_type.dart';
import 'package:rm_veriphy/models/task/tat.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  // WARNING: Do not reuse this GlobalKey in multiple widgets simultaneously!
  final _formKey = GlobalKey<FormState>();
  TaskType? _selectedTaskType;
  TAT? _selectedTAT;
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return AlertDialog(
      title: const Text('Create New Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Type Dropdown
              DropdownButtonFormField<TaskType>(
                value: _selectedTaskType,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: taskProvider.taskTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.taskName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTaskType = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select a task type';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // TAT Dropdown
              DropdownButtonFormField<TAT>(
                value: _selectedTAT,
                decoration: const InputDecoration(labelText: 'TAT'),
                items: taskProvider.tatList.map((tat) {
                  return DropdownMenuItem(
                    value: tat,
                    child: Text('${tat.duration} ${tat.unit}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTAT = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select a TAT';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Creation Date'),
                subtitle: Text(
                  '${_selectedDate.toLocal()}'.split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Description TextField
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              taskProvider.isLoading ? null : () => _handleCreateTask(context),
          child: taskProvider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _handleCreateTask(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;

    try {
      await context.read<TaskProvider>().createTask(
            userId: userId,
            taskTypeId: _selectedTaskType!.id,
            tatId: _selectedTAT!.id,
            creationDate: _selectedDate,
            description: _descriptionController.text,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating task: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
