import 'package:flutter/material.dart';

class DotBackground extends CustomPainter {
  final double radius;
  final Color circleColor;
  final Color backgroundColor;
  final double spacing;

  DotBackground({
    this.radius = 4.5,
    this.circleColor = const Color.fromARGB(255, 217, 217, 217),
    this.backgroundColor = const Color.fromARGB(245, 245, 245, 245),
    this.spacing = 22,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    final paint = Paint()..color = circleColor;
    final yCount = (size.height / (spacing * 2)).ceil();
    final xCount = (size.width / (spacing * 2)).ceil();

    for (var i = 0; i < yCount; i++) {
      final y = spacing * (2 * i + 1);
      for (var j = 0; j < xCount; j++) {
        final x = spacing * (2 * j + 1);
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotBackground oldDelegate) => false;
}
