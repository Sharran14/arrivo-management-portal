// circular_slider.dart

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularSlider extends StatefulWidget {
  final double size;
  final Color knobColor;
  final Color trackColor;
  final Color progressColor;

  const CircularSlider({
    this.size = 200,
    this.knobColor = Colors.blue,
    this.trackColor = Colors.grey,
    this.progressColor = Colors.blueAccent,
  });

  @override
  _CircularSliderState createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  double _currentValue = 50;
  double _angle = 0.0;
  late Offset _center;

  // Calculate the position of the knob on the circle based on the angle
  Offset _calculateKnobPosition(double radius, double angle) {
    double radians = math.pi * (angle - 90) / 180;
    return Offset(
      radius * math.cos(radians) + _center.dx,
      radius * math.sin(radians) + _center.dy,
    );
  }

  // Handle the drag gesture
  void _onPanUpdate(DragUpdateDetails details) {
    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - _center.dx;
    final dy = touchPosition.dy - _center.dy;
    final radians = math.atan2(dy, dx);
    final angle = radians * 180 / math.pi + 90;
    setState(() {
      _angle = (angle < 0 ? angle + 360 : angle) % 360;
      _currentValue = (_angle / 360 * 100).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2;
    _center = Offset(radius, radius);

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular track and progress
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: CircularSliderPainter(
                trackColor: widget.trackColor,
                progressColor: widget.progressColor,
                angle: _angle,
              ),
            ),

            // Display the current value
            Center(
              child: Text(
                _currentValue.toInt().toString(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Knob to drag
            Positioned(
              left: _calculateKnobPosition(radius, _angle).dx - -10,
              top: _calculateKnobPosition(radius, _angle).dy - -10,
              child: GestureDetector(
                onPanUpdate: _onPanUpdate,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: widget.knobColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  final Color trackColor;
  final Color progressColor;
  final double angle;

  CircularSliderPainter({
    required this.trackColor,
    required this.progressColor,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the circular track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(center, radius, trackPaint);

    // Draw the progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    double sweepAngle = math.pi * 2 * (angle / 360);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.5, // Start at the top of the circle
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularSliderPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
