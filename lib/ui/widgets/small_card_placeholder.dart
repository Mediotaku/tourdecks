import 'package:flutter/material.dart';

class SmallCardPlaceholder extends StatelessWidget {
  const SmallCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: Color.fromARGB(255, 255, 128, 128),
        strokeWidth: 3.3,
        borderRadius: 20,
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          size: 62,
          color: Color.fromARGB(255, 255, 128, 128),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius),
          ),
        );

    const dashWidth = 9.5;
    const dashSpace = 9.5;

    for (final metric in path.computeMetrics()) {
      double distance = 5.0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final end = distance + length;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, end.clamp(0.0, metric.length)),
            paint,
          );
        }
        distance = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
