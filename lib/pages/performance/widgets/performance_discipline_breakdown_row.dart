import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceDisciplineBreakdownRow extends StatelessWidget {
  const PerformanceDisciplineBreakdownRow({
    required this.label,
    required this.count,
    required this.share,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    super.key,
  });

  final String label;
  final int count;
  final double share;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$count questões',
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: share.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(share * 100).toStringAsFixed(0)}% do volume atual',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
