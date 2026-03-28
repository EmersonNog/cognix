import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanBenefitItem extends StatelessWidget {
  const PlanBenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onSurfaceMuted,
    required this.onSurface,
    required this.surfaceContainer,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color onSurfaceMuted;
  final Color onSurface;
  final Color surfaceContainer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFA3A6FF), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
