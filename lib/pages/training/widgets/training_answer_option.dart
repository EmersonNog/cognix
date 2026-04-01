import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingAnswerOption extends StatelessWidget {
  const TrainingAnswerOption({
    super.key,
    required this.letter,
    required this.text,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
    required this.onSurface,
    required this.primary,
    this.selected = false,
    this.isDisabled = false,
    this.showSelectedCorrect = false,
    this.showSelectedIncorrect = false,
    this.showCorrectReveal = false,
  });

  final String letter;
  final String text;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;
  final Color onSurface;
  final Color primary;
  final bool selected;
  final bool isDisabled;
  final bool showSelectedCorrect;
  final bool showSelectedIncorrect;
  final bool showCorrectReveal;

  @override
  Widget build(BuildContext context) {
    final isPositive = showSelectedCorrect || showCorrectReveal;
    final isNegative = showSelectedIncorrect;

    final accentColor = isNegative
        ? const Color(0xFFFF6B7A)
        : showCorrectReveal
        ? const Color(0xFF4FD7A8)
        : isPositive
        ? const Color(0xFF31C48D)
        : primary;

    final background = isNegative
        ? const Color(0xFFFF6B7A).withOpacity(0.12)
        : showCorrectReveal
        ? const Color(0xFF4FD7A8).withOpacity(0.1)
        : isPositive
        ? const Color(0xFF31C48D).withOpacity(0.14)
        : selected
        ? surfaceContainerHigh
        : surfaceContainer;
    final borderColor = isPositive || isNegative || selected
        ? accentColor.withOpacity(isPositive || isNegative ? 0.7 : 0.5)
        : Colors.transparent;
    final badgeBackground = isPositive || isNegative
        ? accentColor.withOpacity(0.16)
        : selected
        ? primary.withOpacity(0.15)
        : surfaceContainerHigh;
    final badgeForeground = isPositive || isNegative
        ? accentColor
        : selected
        ? primary
        : onSurfaceMuted;
    final trailingIcon = showSelectedCorrect
        ? Icons.check_circle
        : showSelectedIncorrect
        ? Icons.cancel_rounded
        : showCorrectReveal
        ? Icons.check_circle_outline_rounded
        : selected
        ? Icons.check_circle
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: badgeBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                letter,
                style: GoogleFonts.plusJakartaSans(
                  color: badgeForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: isDisabled && !isPositive && !isNegative
                    ? onSurface.withOpacity(0.92)
                    : onSurface,
                fontSize: 12.5,
              ),
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon, color: accentColor, size: 18),
        ],
      ),
    );
  }
}
