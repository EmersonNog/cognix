import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceInsightHeader extends StatelessWidget {
  const PerformanceInsightHeader({
    super.key,
    required this.title,
    required this.metadataText,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String title;
  final String metadataText;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.insights_rounded, color: primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                metadataText,
                style: GoogleFonts.inter(
                  color: onSurfaceMuted.withValues(alpha: 0.9),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
