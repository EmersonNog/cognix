import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingPrimaryButton extends StatelessWidget {
  const TrainingPrimaryButton({
    super.key,
    required this.label,
    required this.primary,
  });

  final String label;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [primary.withOpacity(0.75), primary],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

class TrainingGhostButton extends StatelessWidget {
  const TrainingGhostButton({
    super.key,
    required this.label,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
  });

  final String label;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: surfaceContainerHigh.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: onSurfaceMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
