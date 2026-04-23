import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

part 'timer_panel/training_pomodoro_timer_panel_actions.dart';
part 'timer_panel/training_pomodoro_timer_panel_dial.dart';
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
    final colorScheme = theme.colorScheme;
    final isLightMode = theme.brightness == Brightness.light;
    final shellColor = surfaceContainer;
    final selectedSegmentColor = surfaceContainerHigh.withValues(alpha: 0.96);
    final ringTrackColor = surfaceContainerHigh;
    final ringGlowColor = primary.withValues(alpha: isLightMode ? 0.08 : 0.16);
    final primaryActionColor = isRunning
        ? colorScheme.secondaryContainer
        : primary;
    final primaryActionForegroundColor = isRunning
        ? colorScheme.onSecondaryContainer
        : Colors.white;

    return Column(
      children: [
        _TrainingPomodoroSegmentedControl(
          shellColor: shellColor,
          borderColor: surfaceContainerHigh,
          selectedSegmentColor: selectedSegmentColor,
          activeColor: primary,
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
          primary: primary,
          ringTrackColor: ringTrackColor,
          ringGlowColor: ringGlowColor,
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
          onSurface: onSurface,
          onPrimaryAction: onPrimaryAction,
          onReset: onReset,
        ),
      ],
    );
  }
}
