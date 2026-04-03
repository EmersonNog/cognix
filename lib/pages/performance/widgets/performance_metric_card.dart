import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceMetricCard extends StatelessWidget {
  const PerformanceMetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    super.key,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;

  static const double _cardHeight = 176;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101A33),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.75,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            helper,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 11.5,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
