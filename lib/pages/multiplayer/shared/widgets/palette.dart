import 'package:flutter/material.dart';

import '../../../../theme/cognix_theme_colors.dart';

class MultiplayerPalette {
  const MultiplayerPalette({
    this.surface = const Color(0xFF050D1F),
    this.surfaceContainer = const Color(0xFF0E1930),
    this.surfaceContainerHigh = const Color(0xFF15233F),
    this.onSurface = const Color(0xFFE4EAFF),
    this.onSurfaceMuted = const Color(0xFF9AA8C7),
    this.primary = const Color(0xFF7ED6C5),
    this.secondary = const Color(0xFFF4A261),
    this.onPrimary = const Color(0xFF050D1F),
    this.shadowColor = const Color(0x33000000),
  });

  factory MultiplayerPalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = colors.secondary;

    return MultiplayerPalette(
      surface: colors.surface,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primary: primary,
      secondary: colors.accent,
      onPrimary:
          ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
          ? Colors.white
          : const Color(0xFF07111F),
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.2)
          : const Color(0xFF60709A).withValues(alpha: 0.14),
    );
  }

  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color secondary;
  final Color onPrimary;
  final Color shadowColor;
}
