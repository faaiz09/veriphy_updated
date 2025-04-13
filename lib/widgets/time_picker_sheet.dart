// lib/widgets/time_picker_sheet.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimePickerSheet extends StatefulWidget {
  final TimeOfDay initialTime;

  const TimePickerSheet({
    super.key,
    required this.initialTime,
  });

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTimeInput(),
          const SizedBox(height: 30),
          _buildTimeClock(),
          const Spacer(),
          _buildSelectButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNumberInput(
          selectedTime.hour.toString().padLeft(2, '0'),
          'Hour',
          (value) {
            final hour = int.tryParse(value);
            if (hour != null && hour >= 0 && hour < 24) {
              setState(() {
                selectedTime =
                    TimeOfDay(hour: hour, minute: selectedTime.minute);
              });
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(':', style: TextStyle(fontSize: 30)),
        ),
        _buildNumberInput(
          selectedTime.minute.toString().padLeft(2, '0'),
          'Minute',
          (value) {
            final minute = int.tryParse(value);
            if (minute != null && minute >= 0 && minute < 60) {
              setState(() {
                selectedTime =
                    TimeOfDay(hour: selectedTime.hour, minute: minute);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildNumberInput(
      String value, String label, Function(String) onChanged) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: value),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeClock() {
    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: ClockPainter(selectedTime),
      ),
    );
  }

  Widget _buildSelectButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedTime),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Select',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final TimeOfDay time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw clock face
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Draw hour markers
    paint
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      canvas.drawLine(
        Offset(
          center.dx + (radius - 20) * math.cos(angle),
          center.dy + (radius - 20) * math.sin(angle),
        ),
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        paint,
      );
    }

    // Draw hour hand
    final hourAngle =
        (time.hour % 12 + time.minute / 60) * math.pi / 6 - math.pi / 2;
    paint
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.5 * math.cos(hourAngle),
        center.dy + radius * 0.5 * math.sin(hourAngle),
      ),
      paint,
    );

    // Draw minute hand
    final minuteAngle = time.minute * math.pi / 30 - math.pi / 2;
    paint.strokeWidth = 2;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.7 * math.cos(minuteAngle),
        center.dy + radius * 0.7 * math.sin(minuteAngle),
      ),
      paint,
    );

    // Draw center dot
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    canvas.drawCircle(center, 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
