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
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final flashcardCount = flashcards.length;
    final isReviewed = flashcardCount > 0 && reviewedCount >= flashcardCount;
    final countLabel =
        '$flashcardCount ${flashcardCount == 1 ? 'flashcard' : 'flashcards'}';
    final normalizedReviewedCount = reviewedCount.clamp(0, flashcardCount);
    final progressValue = flashcardCount == 0
        ? 0.0
        : normalizedReviewedCount / flashcardCount;
    final deckAccent = isReviewed ? const Color(0xFF2FB36D) : primary;
    final baseCardColor = isLightMode
        ? Color.alphaBlend(
            deckAccent.withValues(alpha: isReviewed ? 0.14 : 0.11),
            surfaceContainer,
          )
        : surfaceContainer;
    final midCardColor = isLightMode
        ? Color.alphaBlend(
            deckAccent.withValues(alpha: isReviewed ? 0.08 : 0.055),
            surfaceContainer,
          )
        : surfaceContainer;
    final progressColor = isReviewed
        ? (isLightMode ? const Color(0xFF23995B) : const Color(0xFF7BE49C))
        : (isLightMode
              ? primary.withValues(alpha: 0.92)
              : Colors.white.withValues(alpha: 0.92));
    final outlineColor = isLightMode
        ? deckAccent.withValues(alpha: 0.18)
        : surfaceContainerHigh.withValues(alpha: 0.8);
    final iconChipColor = isLightMode
        ? Colors.white.withValues(alpha: 0.54)
        : Colors.white.withValues(alpha: 0.08);
    final iconChipBorder = isLightMode
        ? Colors.white.withValues(alpha: 0.36)
        : Colors.white.withValues(alpha: 0.06);
    final iconTint = isLightMode
        ? deckAccent.withValues(alpha: 0.88)
        : Colors.white.withValues(alpha: 0.92);
    final subtleTextColor = isLightMode
        ? onSurface.withValues(alpha: 0.82)
        : Colors.white.withValues(alpha: 0.96);
    final ornamentTint = isLightMode
        ? deckAccent.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.08);
    final progressTrackColor = isLightMode
        ? onSurface.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.10);
    final reviewedTextColor = isLightMode
        ? const Color(0xFF157347)
        : const Color(0xFFB8FFD0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 138,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: outlineColor),
            gradient: LinearGradient(
              colors: [baseCardColor, midCardColor, surfaceContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
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
                        Colors.white.withValues(
                          alpha: isLightMode ? 0.08 : 0.03,
                        ),
                        Colors.transparent,
                        deckAccent.withValues(
                          alpha: isLightMode ? 0.045 : 0.05,
                        ),
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
                              Colors.white.withValues(
                                alpha: isLightMode ? 0.10 : 0.10,
                              ),
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
                    color: ornamentTint,
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
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
                              color: iconChipColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: iconChipBorder),
                            ),
                            child: Icon(
                              Icons.style_rounded,
                              color: iconTint,
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
                                  color: reviewedTextColor,
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
                          color: subtleTextColor,
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
                          backgroundColor: progressTrackColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
