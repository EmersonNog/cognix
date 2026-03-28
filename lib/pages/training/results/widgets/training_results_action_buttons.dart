import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingResultsPrimaryButton extends StatelessWidget {
  const TrainingResultsPrimaryButton({
    super.key,
    required this.label,
    required this.background,
    required this.icon,
  });

  final String label;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: background.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingResultsSecondaryButton extends StatelessWidget {
  const TrainingResultsSecondaryButton({
    super.key,
    required this.label,
    required this.background,
    required this.icon,
    required this.onSurfaceMuted,
  });

  final String label;
  final Color background;
  final IconData icon;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: onSurfaceMuted, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
