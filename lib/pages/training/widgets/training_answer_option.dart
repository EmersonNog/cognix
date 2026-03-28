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
  });

  final String letter;
  final String text;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;
  final Color onSurface;
  final Color primary;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final background = selected ? surfaceContainerHigh : surfaceContainer;
    final borderColor = selected ? primary.withOpacity(0.5) : Colors.transparent;

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
              color: selected ? primary.withOpacity(0.15) : surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                letter,
                style: GoogleFonts.plusJakartaSans(
                  color: selected ? primary : onSurfaceMuted,
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
                color: onSurface,
                fontSize: 12.5,
              ),
            ),
          ),
          if (selected) Icon(Icons.check_circle, color: primary, size: 18),
        ],
      ),
    );
  }
}
