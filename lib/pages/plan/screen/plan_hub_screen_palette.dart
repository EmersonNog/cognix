part of '../plan_hub_screen.dart';

class _PlanHubPalette {
  const _PlanHubPalette({
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.accent,
    required this.isDark,
  });

  factory _PlanHubPalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _PlanHubPalette(
      surface: colors.surface,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primary: colors.primary,
      primaryDim: colors.primaryDim,
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
  final Color accent;
  final bool isDark;

  Color get borderColor =>
      onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.18);

  Color get shadowColor => Colors.black.withValues(alpha: isDark ? 0.22 : 0.08);

  Color get primaryForeground =>
      isDark ? const Color(0xFF060E20) : Colors.white;
}
