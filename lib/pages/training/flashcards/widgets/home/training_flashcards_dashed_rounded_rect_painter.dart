import 'package:flutter/material.dart';

class TrainingFlashcardsDashedRoundedRectPainter extends CustomPainter {
  const TrainingFlashcardsDashedRoundedRectPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashWidth = 10.0;
      const dashSpace = 5.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant TrainingFlashcardsDashedRoundedRectPainter oldDelegate,
  ) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
