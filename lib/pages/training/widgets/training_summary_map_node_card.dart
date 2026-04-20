import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingSummaryMapNodeCard extends StatelessWidget {
  const TrainingSummaryMapNodeCard({
    super.key,
    required this.title,
    required this.isCompact,
    required this.maxNodeWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    required this.onLongPress,
    required this.onDoubleTap,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.primary,
  });

  final String title;
  final bool isCompact;
  final double maxNodeWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      onLongPress: isLocked ? null : onLongPress,
      onDoubleTap: isLocked ? null : onDoubleTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? maxNodeWidth : 240),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primary.withValues(alpha: 0.5)
                  : primary.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0C1426).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
