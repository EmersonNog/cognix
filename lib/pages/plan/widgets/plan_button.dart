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
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final PlanButtonStyle style;
  final Color primary;
  final Color primaryDim;
  final Color onSurface;
  final Color surfaceContainerHigh;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isPrimary = style == PlanButtonStyle.primary;
    final enabled = onPressed != null && !isLoading;
    final backgroundColor = enabled
        ? (isPrimary ? null : surfaceContainerHigh)
        : onSurface.withValues(alpha: 0.10);
    final foregroundColor = enabled
        ? (isPrimary ? Colors.white : onSurface)
        : onSurface.withValues(alpha: 0.48);

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: enabled && isPrimary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryDim, primary],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        foregroundColor,
                      ),
                    ),
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
