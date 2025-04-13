import 'package:flutter/material.dart';

class StatusSegment {
  final String name;
  final int value;
  final Color color;

  StatusSegment(this.name, this.value, this.color);
}

class StatusPieChart extends CustomPainter {
  final List<StatusSegment> segments;

  StatusPieChart(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (final segment in segments) {
      final sweepAngle = (segment.value / total) * 2 * 3.14159;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = segment.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
