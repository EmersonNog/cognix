import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsScoreRing extends StatelessWidget {
  const TrainingResultsScoreRing({
    super.key,
    required this.score,
    required this.total,
    required this.primary,
    required this.primaryDim,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final int score;
  final int total;
  final Color primary;
  final Color primaryDim;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : score / total;

    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 7,
                backgroundColor: surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.manrope(
                      color: onSurface,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '$score'),
                      TextSpan(
                        text: '/$total',
                        style: TextStyle(
                          color: onSurfaceMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PONTUAÇÃO',
                  style: GoogleFonts.plusJakartaSans(
                    color: primaryDim,
                    fontSize: 9.5,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
