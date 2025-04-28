// lib/widgets/summary_item.dart
import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String value;
  final String label;

  const SummaryItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
            inherit: true,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            inherit: true,
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(179),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
