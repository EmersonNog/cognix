import 'package:flutter/material.dart';

class AuthTheme {
  static const surface = Color(0xFF060E20);
  static const surfaceLow = Color(0xFF091328);
  static const surfaceContainer = Color(0xFF0F1930);
  static const surfaceHighest = Color(0xFF192540);
  static const onSurface = Color(0xFFDEE5FF);
  static const onSurfaceMuted = Color(0xFF9AA6C5);
  static const primaryDim = Color(0xFF6063EE);
  static const primary = Color(0xFFA3A6FF);
  static const secondaryDim = Color(0xFF8455EF);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDim, primary],
  );
}
