import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'training_flashcard_image_view.dart';

class TrainingFlashcardFaceCard extends StatelessWidget {
  const TrainingFlashcardFaceCard({
    super.key,
    required this.title,
    required this.content,
    required this.imagePath,
    required this.primary,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    this.tapTargetKey,
  });

  final String title;
  final String content;
  final String imagePath;
  final Color primary;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final GlobalKey? tapTargetKey;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final hasImage = imagePath.isNotEmpty;
    final flipHint = title == 'Frente'
        ? 'Clique para ver a resposta'
        : 'Clique para ver a pergunta';
    final cardBackgroundColor = isLightMode ? Colors.white : surfaceContainer;
    final cardBorderColor = isLightMode
        ? Colors.transparent
        : surfaceContainerHigh.withValues(alpha: 0.76);
    final cardGradient = isLightMode
        ? null
        : LinearGradient(
            colors: [
              Color.alphaBlend(
                primary.withValues(alpha: 0.08),
                cardBackgroundColor,
              ),
              Color.alphaBlend(
                primary.withValues(alpha: 0.03),
                cardBackgroundColor,
              ),
              cardBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    final cardShadowColor = isLightMode
        ? Colors.black.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.10);
    final chipBackgroundColor = primary.withValues(
      alpha: isLightMode ? 0.13 : 0.12,
    );
    final overlayGradient = isLightMode
        ? null
        : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight == double.infinity
            ? 500.0
            : constraints.maxHeight;

        return Container(
          height: cardHeight,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: cardBorderColor == Colors.transparent
                ? null
                : Border.all(color: cardBorderColor),
            gradient: cardGradient,
            boxShadow: [
              BoxShadow(
                color: cardShadowColor,
                blurRadius: isLightMode ? 24 : 18,
                spreadRadius: 0,
                offset: Offset(0, isLightMode ? 10 : 10),
              ),
              if (isLightMode)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: overlayGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: chipBackgroundColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: chipBackgroundColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.visibility_outlined,
                      color: primary,
                      size: 19,
                    ),
                  ),
                ),
                if (hasImage)
                  Positioned(
                    top: 52,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: TrainingFlashcardImageView(
                        imageData: imagePath,
                        height: cardHeight * 0.34,
                        surfaceContainerHigh: surfaceContainerHigh,
                        onSurfaceMuted: onSurfaceMuted,
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      hasImage ? cardHeight * 0.19 : 0,
                      24,
                      hasImage ? 18 : 0,
                    ),
                    child: Container(
                      key: tapTargetKey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: onSurface,
                          fontSize: hasImage ? 20 : 24,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 2,
                  child: Text(
                    flipHint,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: isLightMode
                          ? onSurfaceMuted.withValues(alpha: 0.9)
                          : onSurfaceMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
