import 'package:flutter/material.dart';

import '../../theme/cognix_theme_colors.dart';

@immutable
class AuthTheme {
  const AuthTheme({
    required this.surface,
    required this.surfaceLow,
    required this.surfaceContainer,
    required this.surfaceHighest,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.secondaryDim,
    required this.primaryGradient,
    required this.cardShadow,
    required this.glassBadgeBackground,
  });

  final Color surface;
  final Color surfaceLow;
  final Color surfaceContainer;
  final Color surfaceHighest;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final Color secondaryDim;
  final LinearGradient primaryGradient;
  final Color cardShadow;
  final Color glassBadgeBackground;

  static AuthTheme of(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthTheme(
      surface: colors.surface,
      surfaceLow: colors.surfaceLow,
      surfaceContainer: colors.surfaceContainer,
      surfaceHighest: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primary: colors.primary,
      primaryDim: colors.primaryDim,
      secondaryDim: colors.secondaryDim,
      primaryGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.primary, colors.primaryDim],
      ),
      cardShadow: colors.onSurface.withValues(alpha: isDark ? 0.06 : 0.10),
      glassBadgeBackground: colors.surfaceContainerHigh.withValues(
        alpha: isDark ? 0.60 : 0.92,
      ),
    );
  }
}
