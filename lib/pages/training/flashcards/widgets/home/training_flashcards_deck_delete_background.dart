import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardsDeckDeleteBackground extends StatelessWidget {
  const TrainingFlashcardsDeckDeleteBackground({
    super.key,
    required this.surfaceContainerHigh,
  });

  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final backgroundColor = isLightMode
        ? const Color.fromARGB(255, 255, 32, 66)
        : const Color(0xFF4A1820);
    final borderColor = isLightMode
        ? const Color.fromARGB(255, 255, 32, 66)
        : surfaceContainerHigh.withValues(alpha: 0.75);
    final labelColor = isLightMode
        ? const Color(0xFFFFEFF1)
        : const Color(0xFFFFB4B4);
    final iconContainerColor = isLightMode
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.white.withValues(alpha: 0.06);
    final iconContainerBorderColor = isLightMode
        ? Colors.white.withValues(alpha: 0.24)
        : Colors.white.withValues(alpha: 0.08);
    final iconColor = isLightMode
        ? const Color(0xFFFFF5F6)
        : const Color(0xFFFF8C8C);

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(36),
        right: Radius.circular(36),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Apagar deck',
              style: GoogleFonts.plusJakartaSans(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconContainerColor,
                shape: BoxShape.circle,
                border: Border.all(color: iconContainerBorderColor),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: iconColor,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
