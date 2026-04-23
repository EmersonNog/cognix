import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/cognix_theme_colors.dart';
import 'ambient_panel/training_pomodoro_ambient_track.dart';
import 'ambient_panel/training_pomodoro_ambient_track_tile.dart';
import 'ambient_panel/training_pomodoro_ambient_volume_control.dart';

class TrainingPomodoroAmbientPanel extends StatelessWidget {
  const TrainingPomodoroAmbientPanel({
    super.key,
    required this.selectedTrack,
    required this.isPlaying,
    required this.volume,
    required this.onSelectTrack,
    required this.onTogglePlayback,
    required this.onVolumeChanged,
  });

  final TrainingPomodoroAmbientTrack selectedTrack;
  final bool isPlaying;
  final double volume;
  final ValueChanged<TrainingPomodoroAmbientTrack> onSelectTrack;
  final VoidCallback onTogglePlayback;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cognixColors;
    final selectedAccent = selectedTrack.accent(colors);
    final isLightMode = theme.brightness == Brightness.light;
    final borderColor = colors.onSurface.withValues(
      alpha: isLightMode ? 0.08 : 0.1,
    );
    final actionBackground = _actionBackgroundFor(
      isPlaying: isPlaying,
      accent: selectedAccent,
      surface: colors.surfaceContainerHigh,
      isLightMode: isLightMode,
    );
    final actionForeground = isPlaying ? selectedAccent : Colors.white;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AmbientPanelHeader(selectedTrack: selectedTrack),
          const SizedBox(height: 20),
          _AmbientTrackGrid(
            selectedTrack: selectedTrack,
            onSelectTrack: onSelectTrack,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onTogglePlayback,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(isPlaying ? 'PAUSAR ÁUDIO' : 'TOCAR ÁUDIO'),
              style: FilledButton.styleFrom(
                backgroundColor: actionBackground,
                foregroundColor: actionForeground,
                minimumSize: const Size.fromHeight(46),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: isPlaying
                ? Padding(
                    key: const ValueKey('ambient-volume'),
                    padding: const EdgeInsets.only(top: 14),
                    child: TrainingPomodoroAmbientVolumeControl(
                      accent: selectedAccent,
                      volume: volume,
                      onChanged: onVolumeChanged,
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('ambient-volume-hidden')),
          ),
        ],
      ),
    );
  }
}

class _AmbientPanelHeader extends StatelessWidget {
  const _AmbientPanelHeader({required this.selectedTrack});

  final TrainingPomodoroAmbientTrack selectedTrack;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final selectedAccent = selectedTrack.accent(colors);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 44,
          decoration: BoxDecoration(
            color: selectedAccent,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ambiente',
                style: GoogleFonts.manrope(
                  color: colors.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sons de foco',
                style: GoogleFonts.manrope(
                  color: colors.onSurfaceMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                selectedTrack.title,
                style: GoogleFonts.manrope(
                  color: selectedAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmbientTrackGrid extends StatelessWidget {
  const _AmbientTrackGrid({
    required this.selectedTrack,
    required this.onSelectTrack,
  });

  final TrainingPomodoroAmbientTrack selectedTrack;
  final ValueChanged<TrainingPomodoroAmbientTrack> onSelectTrack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 248 ? 3 : 2;
        final tileWidth =
            (constraints.maxWidth - ((columns - 1) * 12)) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: TrainingPomodoroAmbientTrack.values
              .map(
                (track) => SizedBox(
                  width: tileWidth,
                  child: TrainingPomodoroAmbientTrackTile(
                    track: track,
                    isSelected: track == selectedTrack,
                    onTap: () => onSelectTrack(track),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

Color _actionBackgroundFor({
  required bool isPlaying,
  required Color accent,
  required Color surface,
  required bool isLightMode,
}) {
  if (!isPlaying) return accent;

  return Color.alphaBlend(
    accent.withValues(alpha: isLightMode ? 0.14 : 0.2),
    surface,
  );
}
