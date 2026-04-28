part of '../training_area_card.dart';

class _TrainingAreaCardBackground extends StatelessWidget {
  const _TrainingAreaCardBackground({
    required this.card,
    required this.style,
  });

  final TrainingAreaCard card;
  final _TrainingAreaCardStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -34,
          right: -22,
          child: style.isLightTheme
              ? const SizedBox.shrink()
              : Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        card.item.accent.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: -18,
          right: -14,
          child: Icon(
            card.item.icon,
            size: 84,
            color: style.backgroundIconColor,
          ),
        ),
      ],
    );
  }
}
