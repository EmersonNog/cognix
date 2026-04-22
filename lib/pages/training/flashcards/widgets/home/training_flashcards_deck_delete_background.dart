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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4A1820),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: surfaceContainerHigh.withValues(alpha: 0.75)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Apagar deck',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFFFB4B4),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFFF8C8C),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
