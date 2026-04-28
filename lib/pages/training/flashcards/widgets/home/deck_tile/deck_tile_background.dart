part of 'training_flashcards_deck_tile.dart';

class _DeckTileBackground extends StatelessWidget {
  const _DeckTileBackground({required this.style});

  final _TrainingFlashcardsDeckTileStyle style;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isLightMode ? 0.08 : 0.03),
                  Colors.transparent,
                  style.deckAccent.withValues(alpha: isLightMode ? 0.045 : 0.05),
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
              color: style.ornamentTint,
            ),
          ),
        ),
      ],
    );
  }
}
