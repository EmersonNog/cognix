import 'package:flutter/material.dart';

import '../../../theme/cognix_theme_colors.dart';

class AccountSecurityPalette {
  static Color surface = const Color(0xFF05051A);
  static Color card = const Color(0xFF121D38);
  static Color cardSoft = const Color(0xFF162448);
  static Color primary = const Color(0xFF8E7CFF);
  static Color primaryDim = const Color(0xFF5F6BFF);
  static Color secondary = const Color(0xFF7ED6C5);
  static Color accent = const Color(0xFFFFC857);
  static Color danger = const Color(0xFFEF6A6A);
  static Color dangerSoft = const Color(0xFFFFA0A0);
  static Color onSurface = const Color(0xFFF3F5FF);
  static Color onSurfaceMuted = const Color(0xFF9AA6D1);
  static bool isDark = true;

  static void syncWithContext(BuildContext context) {
    final colors = context.cognixColors;
    isDark = Theme.of(context).brightness == Brightness.dark;
    surface = colors.surface;
    card = colors.surfaceContainer;
    cardSoft = colors.surfaceContainerHigh;
    primary = colors.primary;
    primaryDim = colors.primaryDim;
    secondary = colors.secondary;
    accent = colors.accent;
    danger = colors.danger;
    dangerSoft = colors.danger.withValues(alpha: isDark ? 0.78 : 0.9);
    onSurface = colors.onSurface;
    onSurfaceMuted = colors.onSurfaceMuted;
  }

  static Color get border =>
      onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.18);

  static Color get shadow =>
      Colors.black.withValues(alpha: isDark ? 0.22 : 0.08);

  static Color get primaryForeground =>
      isDark ? const Color(0xFF060E20) : Colors.white;

  const AccountSecurityPalette._();
}
