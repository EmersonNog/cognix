import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cognix_theme_colors.dart';

class AppTheme {
  static const darkColors = CognixThemeColors(
    surface: Color(0xFF060E20),
    surfaceLow: Color(0xFF091328),
    surfaceContainer: Color(0xFF0F1930),
    surfaceContainerHigh: Color(0xFF141F38),
    onSurface: Color(0xFFDEE5FF),
    onSurfaceMuted: Color(0xFF9AA6C5),
    primary: Color(0xFFA3A6FF),
    primaryDim: Color(0xFF6063EE),
    secondary: Color(0xFF7ED6C5),
    secondaryDim: Color(0xFF8455EF),
    accent: Color(0xFFFFC56E),
    success: Color(0xFF7ED6C5),
    danger: Color(0xFFEF6A6A),
  );

  static const lightColors = CognixThemeColors(
    surface: Color(0xFFF5F7FF),
    surfaceLow: Color(0xFFEFF3FF),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFE7ECFA),
    onSurface: Color(0xFF15213D),
    onSurfaceMuted: Color(0xFF5D6A8A),
    primary: Color(0xFF5C63E6),
    primaryDim: Color(0xFF8087F2),
    secondary: Color(0xFF2EA98F),
    secondaryDim: Color(0xFFB49AF5),
    accent: Color(0xFFE29A28),
    success: Color(0xFF23966D),
    danger: Color(0xFFD65454),
  );

  static ThemeData light() =>
      _buildTheme(brightness: Brightness.light, colors: lightColors);

  static ThemeData dark() =>
      _buildTheme(brightness: Brightness.dark, colors: darkColors);

  static ThemeData _buildTheme({
    required Brightness brightness,
    required CognixThemeColors colors,
  }) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: isDark ? const Color(0xFF060E20) : Colors.white,
        secondary: colors.secondary,
        onSecondary: isDark ? const Color(0xFF060E20) : Colors.white,
        error: colors.danger,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.onSurface,
      ),
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      splashFactory: InkRipple.splashFactory,
    );

    final textTheme = GoogleFonts.interTextTheme(
      base.textTheme,
    ).apply(bodyColor: colors.onSurface, displayColor: colors.onSurface);

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[colors],
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        titleTextStyle: GoogleFonts.manrope(
          color: colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardColor: colors.surfaceContainer,
      dividerColor: colors.onSurfaceMuted.withValues(alpha: 0.15),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        hintStyle: GoogleFonts.inter(
          color: colors.onSurfaceMuted.withValues(alpha: 0.85),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.onSurfaceMuted.withValues(alpha: 0.16),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.onSurfaceMuted.withValues(alpha: 0.16),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: isDark ? const Color(0xFF060E20) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
