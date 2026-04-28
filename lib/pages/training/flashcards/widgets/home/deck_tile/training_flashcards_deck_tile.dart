import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../training_flashcards_models.dart';

part 'deck_tile_background.dart';
part 'deck_tile_content.dart';
part 'deck_tile_style.dart';

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
    this.previewMode = false,
  });

  final String subject;
  final List<TrainingFlashcardDraft> flashcards;
  final int reviewedCount;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color primary;
  final VoidCallback onTap;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final style = _TrainingFlashcardsDeckTileStyle.fromTile(this, context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 138,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: style.outlineColor),
            gradient: LinearGradient(
              colors: [
                style.baseCardColor,
                style.midCardColor,
                surfaceContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              _DeckTileBackground(style: style),
              _DeckTileContent(tile: this, style: style),
            ],
          ),
        ),
      ),
    );
  }
}
