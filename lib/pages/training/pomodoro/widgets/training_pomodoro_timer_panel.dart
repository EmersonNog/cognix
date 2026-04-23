import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/cognix_theme_colors.dart';

part 'timer_panel/training_pomodoro_timer_panel_actions.dart';
part 'timer_panel/training_pomodoro_timer_panel_dial.dart';
part 'timer_panel/training_pomodoro_timer_panel_dial_content.dart';
part 'timer_panel/training_pomodoro_timer_panel_dial_painter.dart';
part 'timer_panel/training_pomodoro_timer_panel_segmented_control.dart';

class TrainingPomodoroTimerPanel extends StatelessWidget {
  const TrainingPomodoroTimerPanel({
    super.key,
    required this.isFocusPhase,
    required this.timeDisplay,
    required this.progress,
    required this.primary,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.isRunning,
    required this.isEditingDuration,
    required this.minutesController,
    required this.secondsController,
    required this.minutesFocusNode,
    required this.secondsFocusNode,
    required this.onSelectFocus,
    required this.onSelectPause,
    required this.onEditCenter,
    required this.onSubmitInlineEdit,
    required this.onPrimaryAction,
    required this.onReset,
  });

  final bool isFocusPhase;
  final String timeDisplay;
  final double progress;
  final Color primary;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool isRunning;
  final bool isEditingDuration;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final FocusNode minutesFocusNode;
  final FocusNode secondsFocusNode;
  final VoidCallback onSelectFocus;
  final VoidCallback onSelectPause;
  final VoidCallback onEditCenter;
  final bool Function() onSubmitInlineEdit;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cognixColors;
    final isLightMode = theme.brightness == Brightness.light;
    final pauseAccent = colors.accent;
    final phaseAccent = isFocusPhase ? primary : pauseAccent;
    final shellColor = surfaceContainer;
    final selectedSegmentColor = surfaceContainerHigh;
    final ringTrackColor = surfaceContainerHigh;
    final primaryActionColor = isRunning
        ? Color.alphaBlend(
            phaseAccent.withValues(alpha: isLightMode ? 0.12 : 0.18),
            surfaceContainerHigh,
          )
        : phaseAccent;
    final primaryActionForegroundColor = isRunning
        ? phaseAccent
        : _foregroundColorFor(phaseAccent);
    final resetBorderColor = surfaceContainerHigh;
    final resetIconColor = onSurfaceMuted;

    return Column(
      children: [
        _TrainingPomodoroSegmentedControl(
          shellColor: shellColor,
          borderColor: surfaceContainerHigh,
          selectedSegmentColor: selectedSegmentColor,
          activeColor: onSurface,
          inactiveColor: onSurfaceMuted,
          isFocusPhase: isFocusPhase,
          onSelectFocus: onSelectFocus,
          onSelectPause: onSelectPause,
        ),
        const SizedBox(height: 28),
        _TrainingPomodoroCountdownDial(
          isFocusPhase: isFocusPhase,
          isEditingDuration: isEditingDuration,
          timeDisplay: timeDisplay,
          progress: progress,
          primary: phaseAccent,
          ringTrackColor: ringTrackColor,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          minutesController: minutesController,
          secondsController: secondsController,
          minutesFocusNode: minutesFocusNode,
          secondsFocusNode: secondsFocusNode,
          onEditCenter: onEditCenter,
          onSubmitInlineEdit: onSubmitInlineEdit,
        ),
        const SizedBox(height: 22),
        _TrainingPomodoroActionRow(
          isRunning: isRunning,
          primaryActionColor: primaryActionColor,
          primaryActionForegroundColor: primaryActionForegroundColor,
          shellColor: shellColor,
          resetBorderColor: resetBorderColor,
          resetIconColor: resetIconColor,
          onPrimaryAction: onPrimaryAction,
          onReset: onReset,
        ),
      ],
    );
  }
}

Color _foregroundColorFor(Color backgroundColor) {
  final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
  return brightness == Brightness.dark ? Colors.white : const Color(0xFF091328);
}
