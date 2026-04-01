import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/training_tab_models.dart';

class TrainingRhythmCard extends StatelessWidget {
  const TrainingRhythmCard({
    super.key,
    required this.data,
    required this.surfaceContainerHigh,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final TrainingRhythmData data;
  final Color surfaceContainerHigh;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.auto_graph_rounded, color: primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seu ritmo hoje',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  data.completedCountLabel,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted.withOpacity(0.82),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              data.badgeLabel,
              style: GoogleFonts.plusJakartaSans(
                color: primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
