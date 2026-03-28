import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsStatCard extends StatelessWidget {
  const TrainingResultsStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.icon,
    required this.background,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;
  final IconData icon;
  final Color background;

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
          Icon(icon, color: primary, size: 16),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
