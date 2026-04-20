import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';

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

  static const double _minCardHeight = 176;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minCardHeight),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.onSurfaceMuted.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
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
            const SizedBox(height: 12),
            Text(
              helper,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 11.5,
                height: 1.35,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
