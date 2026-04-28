import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../training_area_models.dart';

part 'training_area_card/background.dart';
part 'training_area_card/content.dart';
part 'training_area_card/style.dart';

class TrainingAreaCard extends StatelessWidget {
  const TrainingAreaCard({
    super.key,
    required this.item,
    required this.totalQuestions,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
    this.locked = false,
  });

  final TrainingAreaItem item;
  final int totalQuestions;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback? onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final style = _TrainingAreaCardStyle.fromCard(this, context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: locked ? null : onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: style.cardGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: style.borderColor),
            boxShadow: [
              BoxShadow(
                color: style.shadowColor,
                blurRadius: style.shadowBlurRadius,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: _TrainingAreaCardBackground(card: this, style: style),
              ),
              _TrainingAreaCardContent(card: this, style: style),
            ],
          ),
        ),
      ),
    );
  }
}
