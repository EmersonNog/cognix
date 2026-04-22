import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingDetailHeader extends StatelessWidget {
  const TrainingDetailHeader({
    super.key,
    required this.title,
    required this.countLabel,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String title;
  final String countLabel;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pronto para praticar?',
          style: GoogleFonts.manrope(
            color: onSurface,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Nossa tecnologia ajusta as questões ao seu nível em $title.',
          style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 13),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            countLabel,
            style: GoogleFonts.plusJakartaSans(
              color: primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
