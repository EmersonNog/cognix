import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsTopicProgress extends StatelessWidget {
  const TrainingResultsTopicProgress({
    super.key,
    required this.label,
    required this.progress,
    required this.valueLabel,
    required this.accentColor,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.trackColor,
  });

  final String label;
  final double progress;
  final String valueLabel;
  final Color accentColor;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                valueLabel,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 3,
              color: trackColor,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0, 1),
                alignment: Alignment.centerLeft,
                child: Container(color: accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
