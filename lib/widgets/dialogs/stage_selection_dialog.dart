// lib/widgets/dialogs/stage_selection_dialog.dart

import 'package:flutter/material.dart';

class StageSelectionDialog extends StatelessWidget {
  final String currentStage;

  const StageSelectionDialog({
    super.key,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      'JumpStart',
      'In Progress',
      'Review',
      'Approved',
      'Sign & Pay',
      'Completed',
    ];

    return AlertDialog(
      title: const Text('Update Stage'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: stages.map((stage) {
            return RadioListTile<String>(
              title: Text(stage),
              value: stage,
              groupValue: currentStage,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
