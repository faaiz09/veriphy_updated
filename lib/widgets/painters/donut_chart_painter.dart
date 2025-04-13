// lib/widgets/painters/donut_chart_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rm_veriphy/models/chart/chart_data.dart';

class DonutChartPainter extends CustomPainter {
  final Map<String, ChartData> data;

  DonutChartPainter(this.data);

  // In your DonutChartPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;

    final total = data.values.fold<int>(0, (sum, item) => sum + item.value);

    if (total == 0) return;

    double startAngle = -pi / 2;

    // Draw segments and labels
    for (var entry in data.entries) {
      if (entry.value.value > 0) {
        final sweepAngle = 2 * pi * (entry.value.value / total);
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = entry.value.color;

        // Draw segment
        final path = Path()
          ..moveTo(center.dx, center.dy)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            startAngle,
            sweepAngle,
            false,
          )
          ..arcTo(
            Rect.fromCircle(center: center, radius: innerRadius),
            startAngle + sweepAngle,
            -sweepAngle,
            false,
          )
          ..close();

        canvas.drawPath(path, paint);
        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
