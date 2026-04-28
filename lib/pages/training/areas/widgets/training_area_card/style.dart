part of '../training_area_card.dart';

class _TrainingAreaCardStyle {
  const _TrainingAreaCardStyle({
    required this.isLightTheme,
    required this.backgroundIconColor,
    required this.cardGradient,
    required this.borderColor,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.leadingIconBackground,
    required this.leadingIconBorder,
    required this.pillBackground,
    required this.countBackground,
    required this.countBorder,
    required this.trailingBackground,
    required this.trailingBorder,
    required this.trailingIconColor,
  });

  final bool isLightTheme;
  final Color backgroundIconColor;
  final LinearGradient cardGradient;
  final Color borderColor;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Color leadingIconBackground;
  final Color leadingIconBorder;
  final Color pillBackground;
  final Color countBackground;
  final Color countBorder;
  final Color trailingBackground;
  final Color trailingBorder;
  final Color trailingIconColor;

  factory _TrainingAreaCardStyle.fromCard(
    TrainingAreaCard card,
    BuildContext context,
  ) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final backgroundIconColor = isLightTheme
        ? card.onSurfaceMuted.withValues(alpha: 0.10)
        : card.item.accent.withValues(alpha: 0.06);
    final cardGradient = LinearGradient(
      colors: [
        Color.alphaBlend(
          card.item.accent.withValues(alpha: isLightTheme ? 0.06 : 0.12),
          card.surfaceContainer,
        ),
        Color.alphaBlend(
          card.item.accent.withValues(alpha: isLightTheme ? 0.02 : 0.04),
          card.surfaceContainer,
        ),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return _TrainingAreaCardStyle(
      isLightTheme: isLightTheme,
      backgroundIconColor: backgroundIconColor,
      cardGradient: cardGradient,
      borderColor: card.item.accent.withValues(alpha: isLightTheme ? 0.10 : 0.16),
      shadowColor: card.item.accent.withValues(
        alpha: isLightTheme ? 0.05 : 0.12,
      ),
      shadowBlurRadius: isLightTheme ? 14 : 22,
      leadingIconBackground: card.item.accent.withValues(alpha: 0.15),
      leadingIconBorder: card.item.accent.withValues(alpha: 0.18),
      pillBackground: card.item.accent.withValues(alpha: 0.12),
      countBackground: card.surfaceContainerHigh.withValues(alpha: 0.82),
      countBorder: card.item.accent.withValues(alpha: 0.12),
      trailingBackground: isLightTheme
          ? card.surfaceContainerHigh.withValues(alpha: 0.92)
          : card.surfaceContainerHigh.withValues(alpha: 0.78),
      trailingBorder: card.item.accent.withValues(
        alpha: isLightTheme ? 0.10 : 0.06,
      ),
      trailingIconColor: isLightTheme
          ? card.item.accent.withValues(alpha: 0.72)
          : card.onSurface,
    );
  }
}
