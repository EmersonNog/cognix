import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardsRecoveredImageBanner extends StatelessWidget {
  const TrainingFlashcardsRecoveredImageBanner({
    super.key,
    required this.count,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final int count;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: surfaceContainerHigh.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.image_rounded, color: onSurface, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Imagem recuperada da galeria',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count == 1
                      ? 'O app recuperou 1 imagem apos reiniciar. Abra o criador de flashcard para selecionar outra imagem se precisar.'
                      : 'O app recuperou $count imagens após reiniciar. Abra o criador de flashcard para selecionar outra imagem se precisar.',
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
