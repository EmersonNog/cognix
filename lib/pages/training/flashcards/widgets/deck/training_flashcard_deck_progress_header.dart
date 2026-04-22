import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardDeckProgressHeader extends StatelessWidget {
  const TrainingFlashcardDeckProgressHeader({
    super.key,
    required this.progressLabel,
    required this.progress,
    required this.primary,
    required this.surfaceContainerHigh,
  });

  final String progressLabel;
  final double progress;
  final Color primary;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progressLabel,
            style: GoogleFonts.plusJakartaSans(
              color: primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: surfaceContainerHigh.withValues(alpha: 0.75),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }
}
