// lib/widgets/mtd_summary_chart.dart
// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';
import 'package:flutter/material.dart';

class MTDSummaryChart extends StatelessWidget {
  final Map<String, ChartData> data;
  final double size;

  const MTDSummaryChart({
    super.key,
    required this.data,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Pie Chart
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: PieChartPainter(data),
            child: Center(
              child: Text(
                data.values
                    .fold<int>(0, (sum, item) => sum + item.value)
                    .toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Legend
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data.entries
                .map((entry) => _buildLegendItem(
                      label: entry.key,
                      value: entry.value.value,
                      color: entry.value.color,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required String label,
    required int value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Label and value
          Expanded(
            child: Text(
              '$label ($value)',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class PieChartPainter extends CustomPainter {
  final Map<String, ChartData> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Calculate total value for percentages
    final total = data.values.fold<int>(0, (sum, item) => sum + item.value);

    // Draw pie segments
    double startAngle = -pi / 2; // Start from top

    data.values.forEach((item) {
      if (item.value > 0) {
        final sweepAngle = 2 * pi * (item.value / total);
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = item.color;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );

        startAngle += sweepAngle;
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
