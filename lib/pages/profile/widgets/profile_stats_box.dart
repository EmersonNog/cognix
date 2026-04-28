import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';

class ProfileStatsBox extends StatelessWidget {
  const ProfileStatsBox({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.previewMode = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: onSurfaceMuted.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primary, size: 18),
            ),
            const SizedBox(height: 10),
            if (previewMode)
              Icon(
                Icons.lock_rounded,
                color: onSurface.withValues(alpha: 0.82),
                size: 22,
              )
            else
              Text(
                value,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            if (previewMode) ...[
              const SizedBox(height: 6),
              Text(
                'Premium',
                style: GoogleFonts.inter(
                  color: primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
