import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../training_flashcards_models.dart';

class TrainingFlashcardsDeckTile extends StatelessWidget {
  const TrainingFlashcardsDeckTile({
    super.key,
    required this.subject,
    required this.flashcards,
    required this.reviewedCount,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.primary,
    required this.onTap,
  });

  final String subject;
  final List<TrainingFlashcardDraft> flashcards;
  final int reviewedCount;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final flashcardCount = flashcards.length;
    final isReviewed = flashcardCount > 0 && reviewedCount >= flashcardCount;
    final countLabel =
        '$flashcardCount ${flashcardCount == 1 ? 'flashcard' : 'flashcards'}';
    final normalizedReviewedCount = reviewedCount.clamp(0, flashcardCount);
    final progressValue = flashcardCount == 0
        ? 0.0
        : normalizedReviewedCount / flashcardCount;
    final deckAccent = isReviewed ? const Color(0xFF2FB36D) : primary;
    final progressColor = isReviewed
        ? const Color(0xFF7BE49C)
        : Colors.white.withValues(alpha: 0.92);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 138,
          padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: surfaceContainerHigh.withValues(alpha: 0.8),
            ),
            gradient: LinearGradient(
              colors: [
                Color.alphaBlend(
                  deckAccent.withValues(alpha: isReviewed ? 0.26 : 0.20),
                  surfaceContainer,
                ),
                Color.alphaBlend(
                  deckAccent.withValues(alpha: isReviewed ? 0.14 : 0.10),
                  surfaceContainer,
                ),
                Color.alphaBlend(
                  deckAccent.withValues(alpha: isReviewed ? 0.08 : 0.04),
                  surfaceContainer,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.03),
                        Colors.transparent,
                        deckAccent.withValues(alpha: 0.05),
                      ],
                      stops: const [0.0, 0.58, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                    angle: -0.34,
                    child: SizedBox(
                      width: 118,
                      height: 180,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.10),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: const Alignment(0.82, 0.08),
                  child: Icon(
                    Icons.layers_rounded,
                    size: 74,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Icon(
                            Icons.style_rounded,
                            color: Colors.white.withValues(alpha: 0.92),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, right: 56),
                            child: Text(
                              subject,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                color: onSurface,
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                            ),
                          ),
                        ),
                        if (isReviewed)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: deckAccent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: deckAccent.withValues(alpha: 0.24),
                              ),
                            ),
                            child: Text(
                              'Revisado',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFB8FFD0),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      countLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.96),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 7,
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
