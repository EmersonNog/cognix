import 'package:flutter/material.dart';

@immutable
class CognixThemeColors extends ThemeExtension<CognixThemeColors> {
  const CognixThemeColors({
    required this.surface,
    required this.surfaceLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.secondary,
    required this.secondaryDim,
    required this.accent,
    required this.success,
    required this.danger,
  });

  final Color surface;
  final Color surfaceLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final Color secondary;
  final Color secondaryDim;
  final Color accent;
  final Color success;
  final Color danger;

  @override
  CognixThemeColors copyWith({
    Color? surface,
    Color? surfaceLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? primary,
    Color? primaryDim,
    Color? secondary,
    Color? secondaryDim,
    Color? accent,
    Color? success,
    Color? danger,
  }) {
    return CognixThemeColors(
      surface: surface ?? this.surface,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      primary: primary ?? this.primary,
      primaryDim: primaryDim ?? this.primaryDim,
      secondary: secondary ?? this.secondary,
      secondaryDim: secondaryDim ?? this.secondaryDim,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  CognixThemeColors lerp(
    covariant ThemeExtension<CognixThemeColors>? other,
    double t,
  ) {
    if (other is! CognixThemeColors) {
      return this;
    }

    return CognixThemeColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryDim: Color.lerp(secondaryDim, other.secondaryDim, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension CognixThemeColorsContext on BuildContext {
  CognixThemeColors get cognixColors {
    final colors = Theme.of(this).extension<CognixThemeColors>();
    assert(colors != null, 'CognixThemeColors is not configured on ThemeData.');
    return colors!;
  }
}
