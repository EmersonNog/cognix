import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'support_palette.dart';

class SupportSectionTitle extends StatelessWidget {
  const SupportSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: supportOnSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: supportOnSurfaceMuted,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
