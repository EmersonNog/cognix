import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardImageFieldButton extends StatelessWidget {
  const TrainingFlashcardImageFieldButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final String label;
  final VoidCallback onTap;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceContainerHigh.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: surfaceContainerHigh),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, color: onSurfaceMuted, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
