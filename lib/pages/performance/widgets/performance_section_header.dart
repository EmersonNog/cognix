import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceSectionHeader extends StatelessWidget {
  const PerformanceSectionHeader({
    required this.title,
    required this.subtitle,
    required this.onSurface,
    required this.onSurfaceMuted,
    super.key,
  });

  final String title;
  final String subtitle;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: onSurfaceMuted,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
