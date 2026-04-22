import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../training_flashcards_models.dart';
import 'preview_card/training_flashcard_face_card.dart';

class TrainingFlashcardPreviewCard extends StatefulWidget {
  const TrainingFlashcardPreviewCard({
    super.key,
    required this.flashcard,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.tapTargetKey,
  });

  final TrainingFlashcardDraft flashcard;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final GlobalKey? tapTargetKey;

  @override
  State<TrainingFlashcardPreviewCard> createState() =>
      _TrainingFlashcardPreviewCardState();
}

class _TrainingFlashcardPreviewCardState
    extends State<TrainingFlashcardPreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_controller.isAnimating) return;
    if (_controller.value >= 0.5) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = widget.flashcard;

    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final isBackVisible = angle > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: isBackVisible
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: TrainingFlashcardFaceCard(
                      title: 'Verso',
                      content: flashcard.backText,
                      imagePath: flashcard.backImage,
                      primary: widget.primary,
                      surfaceContainer: widget.surfaceContainer,
                      surfaceContainerHigh: widget.surfaceContainerHigh,
                      onSurface: widget.onSurface,
                      onSurfaceMuted: widget.onSurfaceMuted,
                      tapTargetKey: widget.tapTargetKey,
                    ),
                  )
                : TrainingFlashcardFaceCard(
                    title: 'Frente',
                    content: flashcard.frontText,
                    imagePath: flashcard.frontImage,
                    primary: widget.primary,
                    surfaceContainer: widget.surfaceContainer,
                    surfaceContainerHigh: widget.surfaceContainerHigh,
                    onSurface: widget.onSurface,
                    onSurfaceMuted: widget.onSurfaceMuted,
                    tapTargetKey: widget.tapTargetKey,
                  ),
          );
        },
      ),
    );
  }
}
