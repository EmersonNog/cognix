import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsMetricCard extends StatelessWidget {
  const TrainingResultsMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.progress,
    required this.background,
    required this.icon,
    required this.accentColor,
    this.valueFontSize = 14,
    this.barHeight = 6,
    this.solidFill = false,
    this.trackColor,
  });

  final String label;
  final String value;
  final Color onSurface;
  final Color onSurfaceMuted;
  final double progress;
  final Color background;
  final IconData icon;
  final Color accentColor;
  final double valueFontSize;
  final double barHeight;
  final bool solidFill;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 16),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 9.3,
              letterSpacing: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: barHeight,
              color: trackColor ?? accentColor.withOpacity(0.22),
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0, 1),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: solidFill ? accentColor : null,
                    gradient: solidFill
                        ? null
                        : LinearGradient(
                            colors: [accentColor.withOpacity(0.5), accentColor],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
