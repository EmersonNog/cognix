import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'training_flashcards_dashed_rounded_rect_painter.dart';

class TrainingFlashcardsCreateActionCard extends StatelessWidget {
  const TrainingFlashcardsCreateActionCard({
    super.key,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.totalFlashcards,
    required this.onCreateFlashcard,
  });

  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final int totalFlashcards;
  final VoidCallback onCreateFlashcard;

  @override
  Widget build(BuildContext context) {
    final headline = totalFlashcards == 0
        ? 'Criar flashcard'
        : 'Continue seus flashcards';
    final description = totalFlashcards == 0
        ? 'Adicione perguntas e respostas para revisar.'
        : '$totalFlashcards cards prontos para revisar.';

    return CustomPaint(
      painter: TrainingFlashcardsDashedRoundedRectPainter(
        color: onSurfaceMuted.withValues(alpha: 0.85),
        radius: 28,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            primary.withValues(alpha: 0.05),
            surfaceContainer,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.note_alt_outlined,
                    size: 22,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        headline,
                        style: GoogleFonts.manrope(
                          color: onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                          color: onSurfaceMuted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCreateFlashcard,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(
                  'Criar flashcard',
                  style: GoogleFonts.manrope(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
