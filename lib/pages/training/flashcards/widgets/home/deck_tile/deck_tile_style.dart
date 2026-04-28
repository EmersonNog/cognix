part of 'training_flashcards_deck_tile.dart';

class _TrainingFlashcardsDeckTileStyle {
  const _TrainingFlashcardsDeckTileStyle({
    required this.flashcardCount,
    required this.isReviewed,
    required this.countLabel,
    required this.progressValue,
    required this.deckAccent,
    required this.baseCardColor,
    required this.midCardColor,
    required this.progressColor,
    required this.outlineColor,
    required this.iconChipColor,
    required this.iconChipBorder,
    required this.iconTint,
    required this.subtleTextColor,
    required this.ornamentTint,
    required this.progressTrackColor,
    required this.reviewedTextColor,
  });

  final int flashcardCount;
  final bool isReviewed;
  final String countLabel;
  final double progressValue;
  final Color deckAccent;
  final Color baseCardColor;
  final Color midCardColor;
  final Color progressColor;
  final Color outlineColor;
  final Color iconChipColor;
  final Color iconChipBorder;
  final Color iconTint;
  final Color subtleTextColor;
  final Color ornamentTint;
  final Color progressTrackColor;
  final Color reviewedTextColor;

  factory _TrainingFlashcardsDeckTileStyle.fromTile(
    TrainingFlashcardsDeckTile tile,
    BuildContext context,
  ) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final flashcardCount = tile.flashcards.length;
    final isReviewed =
        !tile.previewMode &&
        flashcardCount > 0 &&
        tile.reviewedCount >= flashcardCount;
    final countLabel =
        '$flashcardCount ${flashcardCount == 1 ? 'flashcard' : 'flashcards'}';
    final normalizedReviewedCount = tile.reviewedCount.clamp(0, flashcardCount);
    final progressValue = tile.previewMode || flashcardCount == 0
        ? 0.0
        : normalizedReviewedCount / flashcardCount;
    final deckAccent = isReviewed ? const Color(0xFF2FB36D) : tile.primary;
    final baseCardColor = isLightMode
        ? Color.alphaBlend(
            deckAccent.withValues(alpha: isReviewed ? 0.14 : 0.11),
            tile.surfaceContainer,
          )
        : tile.surfaceContainer;
    final midCardColor = isLightMode
        ? Color.alphaBlend(
            deckAccent.withValues(alpha: isReviewed ? 0.08 : 0.055),
            tile.surfaceContainer,
          )
        : tile.surfaceContainer;
    final progressColor = isReviewed
        ? (isLightMode ? const Color(0xFF23995B) : const Color(0xFF7BE49C))
        : (isLightMode
              ? tile.primary.withValues(alpha: 0.92)
              : Colors.white.withValues(alpha: 0.92));
    final outlineColor = isLightMode
        ? deckAccent.withValues(alpha: 0.18)
        : tile.surfaceContainerHigh.withValues(alpha: 0.8);
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
        ? tile.onSurface.withValues(alpha: 0.82)
        : Colors.white.withValues(alpha: 0.96);
    final ornamentTint = isLightMode
        ? deckAccent.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.08);
    final progressTrackColor = isLightMode
        ? tile.onSurface.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.10);
    final reviewedTextColor = isLightMode
        ? const Color(0xFF157347)
        : const Color(0xFFB8FFD0);

    return _TrainingFlashcardsDeckTileStyle(
      flashcardCount: flashcardCount,
      isReviewed: isReviewed,
      countLabel: countLabel,
      progressValue: progressValue,
      deckAccent: deckAccent,
      baseCardColor: baseCardColor,
      midCardColor: midCardColor,
      progressColor: progressColor,
      outlineColor: outlineColor,
      iconChipColor: iconChipColor,
      iconChipBorder: iconChipBorder,
      iconTint: iconTint,
      subtleTextColor: subtleTextColor,
      ornamentTint: ornamentTint,
      progressTrackColor: progressTrackColor,
      reviewedTextColor: reviewedTextColor,
    );
  }
}
