// lib/widgets/aging_indicator.dart
import 'package:flutter/material.dart';

class AgingIndicator extends StatelessWidget {
  final int days;

  const AgingIndicator({
    super.key,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16),
        const SizedBox(width: 4),
        Text(
          'Ageing: $days days',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}