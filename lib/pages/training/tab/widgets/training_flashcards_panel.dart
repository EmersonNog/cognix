import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardsPanel extends StatelessWidget {
  const TrainingFlashcardsPanel({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.totalFlashcards,
    required this.onCreateFlashcard,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final int totalFlashcards;
  final VoidCallback onCreateFlashcard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Flashcards',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$totalFlashcards cards',
                  style: GoogleFonts.plusJakartaSans(
                    color: primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Crie seus próprios cards para revisar conceitos, perguntas e respostas em sessões curtas.',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCreateFlashcard,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primary.withValues(alpha: 0.14)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_rounded, color: primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Criar flashcard',
                        style: GoogleFonts.plusJakartaSans(
                          color: onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: primary, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
