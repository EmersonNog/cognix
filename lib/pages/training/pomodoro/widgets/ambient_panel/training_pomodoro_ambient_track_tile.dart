import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../theme/cognix_theme_colors.dart';
import 'training_pomodoro_ambient_track.dart';

class TrainingPomodoroAmbientTrackTile extends StatelessWidget {
  const TrainingPomodoroAmbientTrackTile({
    super.key,
    required this.track,
    required this.isSelected,
    required this.onTap,
  });

  final TrainingPomodoroAmbientTrack track;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cognixColors;
    final isLightMode = theme.brightness == Brightness.light;
    final accent = track.accent(colors);
    final backgroundColor = Color.alphaBlend(
      isSelected
          ? accent.withValues(alpha: isLightMode ? 0.12 : 0.16)
          : Colors.transparent,
      colors.surfaceContainerHigh,
    );
    final borderColor = isSelected
        ? accent.withValues(alpha: isLightMode ? 0.85 : 1.0)
        : colors.onSurface.withValues(alpha: isLightMode ? 0.08 : 0.1);
    final iconColor = isSelected ? accent : colors.onSurfaceMuted;
    final labelColor = isSelected ? colors.onSurface : colors.onSurfaceMuted;

    return Material(
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1.18,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(track.icon, color: iconColor, size: 21),
                const SizedBox(height: 7),
                Text(
                  track.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: labelColor,
                    fontSize: 10.8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
