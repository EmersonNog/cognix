import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingSessionQuestionCard extends StatelessWidget {
  const TrainingSessionQuestionCard({
    super.key,
    required this.discipline,
    required this.statement,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String discipline;
  final String statement;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discipline,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statement,
            style: GoogleFonts.inter(
              color: onSurface,
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
