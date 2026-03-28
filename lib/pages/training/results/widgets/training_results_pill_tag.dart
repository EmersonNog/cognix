import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsPillTag extends StatelessWidget {
  const TrainingResultsPillTag({
    super.key,
    required this.label,
    required this.background,
    required this.textColor,
  });

  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 9.5,
          letterSpacing: 1.3,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
