part of '../support_screen.dart';

class _SupportPalette {
  const _SupportPalette({
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.secondary,
    required this.accent,
    required this.isDark,
  });

  factory _SupportPalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _SupportPalette(
      surface: colors.surface,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primary: colors.primary,
      primaryDim: colors.primaryDim,
      secondary: colors.secondary,
      accent: colors.accent,
      isDark: isDark,
    );
  }

  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final Color secondary;
  final Color accent;
  final bool isDark;

  Color get borderColor =>
      onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.18);

  Color get shadowColor => Colors.black.withValues(alpha: isDark ? 0.22 : 0.08);

  Color get primaryForeground =>
      isDark ? const Color(0xFF060E20) : Colors.white;
}
