part of 'training_flashcards_deck_tile.dart';

class _DeckTileContent extends StatelessWidget {
  const _DeckTileContent({required this.tile, required this.style});

  final TrainingFlashcardsDeckTile tile;
  final _TrainingFlashcardsDeckTileStyle style;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
                    color: style.iconChipColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: style.iconChipBorder),
                  ),
                  child: Icon(
                    Icons.style_rounded,
                    color: style.iconTint,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, right: 56),
                    child: Text(
                      tile.subject,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        color: tile.onSurface,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ),
                ),
                _DeckTileBadge(tile: tile, style: style),
              ],
            ),
            const Spacer(),
            Text(
              tile.previewMode
                  ? '${style.countLabel} para explorar'
                  : style.countLabel,
              style: GoogleFonts.plusJakartaSans(
                color: style.subtleTextColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (tile.previewMode) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: style.deckAccent.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Disponível com assinatura',
                    style: GoogleFonts.inter(
                      color: style.deckAccent.withValues(alpha: 0.9),
                      fontSize: 11.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: style.progressValue,
                  minHeight: 7,
                  backgroundColor: style.progressTrackColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    style.progressColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeckTileBadge extends StatelessWidget {
  const _DeckTileBadge({required this.tile, required this.style});

  final TrainingFlashcardsDeckTile tile;
  final _TrainingFlashcardsDeckTileStyle style;

  @override
  Widget build(BuildContext context) {
    if (tile.previewMode) {
      return _DeckTilePill(
        label: 'Premium',
        textColor: style.iconTint,
        backgroundColor: style.deckAccent.withValues(alpha: 0.14),
        borderColor: style.deckAccent.withValues(alpha: 0.2),
      );
    }

    if (style.isReviewed) {
      return _DeckTilePill(
        label: 'Revisado',
        textColor: style.reviewedTextColor,
        backgroundColor: style.deckAccent.withValues(alpha: 0.18),
        borderColor: style.deckAccent.withValues(alpha: 0.24),
      );
    }

    return const SizedBox.shrink();
  }
}

class _DeckTilePill extends StatelessWidget {
  const _DeckTilePill({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
