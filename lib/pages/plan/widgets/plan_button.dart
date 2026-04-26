import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PlanButtonStyle { primary, secondary }

class PlanButton extends StatelessWidget {
  const PlanButton({
    super.key,
    required this.label,
    required this.style,
    required this.primary,
    required this.primaryDim,
    required this.onSurface,
    required this.surfaceContainerHigh,
  });

  final String label;
  final PlanButtonStyle style;
  final Color primary;
  final Color primaryDim;
  final Color onSurface;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    final isPrimary = style == PlanButtonStyle.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: isPrimary ? null : surfaceContainerHigh,
        gradient: isPrimary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryDim, primary],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          color: isPrimary ? Colors.white : onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
