import 'package:flutter/material.dart';

import '../../../../../theme/cognix_theme_colors.dart';

enum TrainingPomodoroAmbientTrack { lofi, rain, jazz, forest, cafe, piano }

extension TrainingPomodoroAmbientTrackPresentation
    on TrainingPomodoroAmbientTrack {
  String get title {
    switch (this) {
      case TrainingPomodoroAmbientTrack.lofi:
        return 'Lofi';
      case TrainingPomodoroAmbientTrack.rain:
        return 'Chuva';
      case TrainingPomodoroAmbientTrack.jazz:
        return 'Jazz';
      case TrainingPomodoroAmbientTrack.forest:
        return 'Floresta';
      case TrainingPomodoroAmbientTrack.cafe:
        return 'Cafe';
      case TrainingPomodoroAmbientTrack.piano:
        return 'Piano';
    }
  }

  String get label {
    switch (this) {
      case TrainingPomodoroAmbientTrack.lofi:
        return 'LOFI';
      case TrainingPomodoroAmbientTrack.rain:
        return 'CHUVA';
      case TrainingPomodoroAmbientTrack.jazz:
        return 'JAZZ';
      case TrainingPomodoroAmbientTrack.forest:
        return 'FLORESTA';
      case TrainingPomodoroAmbientTrack.cafe:
        return 'CAFÉ';
      case TrainingPomodoroAmbientTrack.piano:
        return 'PIANO';
    }
  }

  IconData get icon {
    switch (this) {
      case TrainingPomodoroAmbientTrack.lofi:
        return Icons.music_note_rounded;
      case TrainingPomodoroAmbientTrack.rain:
        return Icons.water_drop_rounded;
      case TrainingPomodoroAmbientTrack.jazz:
        return Icons.album_rounded;
      case TrainingPomodoroAmbientTrack.forest:
        return Icons.park_rounded;
      case TrainingPomodoroAmbientTrack.cafe:
        return Icons.coffee_rounded;
      case TrainingPomodoroAmbientTrack.piano:
        return Icons.piano_rounded;
    }
  }

  Color accent(CognixThemeColors colors) {
    switch (this) {
      case TrainingPomodoroAmbientTrack.lofi:
        return colors.primary;
      case TrainingPomodoroAmbientTrack.rain:
        return colors.secondary;
      case TrainingPomodoroAmbientTrack.jazz:
        return colors.accent;
      case TrainingPomodoroAmbientTrack.forest:
        return _forestAccentFor(colors.success);
      case TrainingPomodoroAmbientTrack.cafe:
        return colors.secondaryDim;
      case TrainingPomodoroAmbientTrack.piano:
        return colors.primaryDim;
    }
  }
}

Color forestAccentFor(Color baseColor) => _forestAccentFor(baseColor);

Color _forestAccentFor(Color baseColor) {
  final hsl = HSLColor.fromColor(baseColor);
  final hue = (hsl.hue - 28 + 360) % 360;
  final saturation = (hsl.saturation + 0.08).clamp(0.0, 1.0).toDouble();
  final lightness = (hsl.lightness - 0.05).clamp(0.0, 1.0).toDouble();

  return hsl
      .withHue(hue)
      .withSaturation(saturation)
      .withLightness(lightness)
      .toColor();
}
