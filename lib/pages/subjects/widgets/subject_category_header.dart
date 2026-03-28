import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectCategoryHeader extends StatelessWidget {
  const SubjectCategoryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String subtitle;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'CATEGORIA',
            style: GoogleFonts.plusJakartaSans(
              color: primary,
              fontSize: 9.5,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
