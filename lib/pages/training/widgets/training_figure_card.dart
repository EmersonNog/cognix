import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFigureCard extends StatelessWidget {
  const TrainingFigureCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.1, -0.2),
                  radius: 1.2,
                  colors: [
                    primary.withOpacity(0.18),
                    surfaceContainerHigh,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _RadarPainter(
                  lineColor: onSurfaceMuted.withOpacity(0.35),
                  glowColor: primary.withOpacity(0.22),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'FIGURA 1.2',
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceMuted,
                fontSize: 9.5,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Função densidade de probabilidade de um elétron em um orbital '
            'hidrogenoide sob perturbação externa.',
            style: GoogleFonts.inter(
              color: onSurface,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.lineColor, required this.glowColor});

  final Color lineColor;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.4;

    final glowPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, radius * 0.35, glowPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), linePaint);
    }

    for (var angle = 0.0; angle < 360; angle += 30) {
      final radians = angle * math.pi / 180;
      final dx = radius * 1.05 * math.cos(radians);
      final dy = radius * 1.05 * math.sin(radians);
      canvas.drawLine(center, center + Offset(dx, dy), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.glowColor != glowColor;
  }
}
