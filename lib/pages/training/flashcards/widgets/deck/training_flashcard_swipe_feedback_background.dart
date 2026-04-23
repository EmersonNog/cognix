import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardSwipeFeedbackBackground extends StatelessWidget {
  const TrainingFlashcardSwipeFeedbackBackground({
    super.key,
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
    this.focusKey,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;
  final GlobalKey? focusKey;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final circle = Container(
      key: focusKey,
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isLightMode ? 0.18 : 0.12),
        border: Border.all(
          color: color.withValues(alpha: isLightMode ? 0.42 : 0.34),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isLightMode ? 0.12 : 0.18),
            blurRadius: isLightMode ? 14 : 18,
            offset: Offset(0, isLightMode ? 6 : 8),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 26),
    );

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLightMode ? 0.18 : 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: isLightMode ? 0.34 : 0.28),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: alignment == Alignment.centerLeft
            ? [
                circle,
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: color,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]
            : [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: color,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 12),
                circle,
              ],
      ),
    );
  }
}
