import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../theme/cognix_theme_colors.dart';

class TrainingPomodoroAmbientVolumeControl extends StatelessWidget {
  const TrainingPomodoroAmbientVolumeControl({
    super.key,
    required this.accent,
    required this.volume,
    required this.onChanged,
  });

  final Color accent;
  final double volume;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final percentage = (volume * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up_rounded, color: accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Volume',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.manrope(
                  color: colors.onSurfaceMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: accent,
              inactiveTrackColor: accent.withValues(alpha: 0.18),
              thumbColor: accent,
              overlayColor: accent.withValues(alpha: 0.14),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
            ),
            child: Slider(value: volume, min: 0, max: 1, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
