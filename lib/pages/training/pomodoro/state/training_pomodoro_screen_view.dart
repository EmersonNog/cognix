part of '../training_pomodoro_screen.dart';

Widget _buildScreenForState(
  _TrainingPomodoroScreenState state,
  BuildContext context,
) {
  final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

  return Scaffold(
    backgroundColor: backgroundColor,
    appBar: AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      scrolledUnderElevation: 0,
      title: Text(
        'Pomodoro',
        style: GoogleFonts.manrope(
          color: state.widget.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    body: state._isHydrating
        ? Center(child: CircularProgressIndicator(color: state.widget.primary))
        : _buildScreenContentForState(state),
  );
}

Widget _buildScreenContentForState(_TrainingPomodoroScreenState state) {
  final presentation = _timerPresentationForState(state);

  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
    children: [
      TrainingPomodoroTimerPanel(
        isFocusPhase: state._phase == TrainingPomodoroPhase.focus,
        timeDisplay: presentation.timeDisplay,
        progress: presentation.progress,
        primary: state.widget.primary,
        surfaceContainer: state.widget.surfaceContainer,
        surfaceContainerHigh: state.widget.surfaceContainerHigh,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        isRunning: state._isRunning,
        isEditingDuration: state._isEditingDuration,
        minutesController: state._minutesController,
        secondsController: state._secondsController,
        minutesFocusNode: state._minutesFocusNode,
        secondsFocusNode: state._secondsFocusNode,
        onSelectFocus: state._selectFocusPhase,
        onSelectPause: state._selectPausePhase,
        onEditCenter: state._beginInlineDurationEdit,
        onSubmitInlineEdit: state._commitInlineDurationEdit,
        onPrimaryAction: state._toggleRunning,
        onReset: state._resetCurrentPhase,
      ),
      const SizedBox(height: 28),
      TrainingPomodoroAmbientPanel(
        selectedTrack: state._selectedAmbientTrack,
        isPlaying: state._isAmbientPlaying,
        volume: state._ambientVolume,
        onSelectTrack: state._selectAmbientTrack,
        onTogglePlayback: state._toggleAmbientPlayback,
        onVolumeChanged: state._setAmbientVolume,
      ),
    ],
  );
}

({double progress, String timeDisplay}) _timerPresentationForState(
  _TrainingPomodoroScreenState state,
) {
  final totalSeconds = state._secondsForPhase(state._phase);
  final progress = totalSeconds == 0
      ? 0.0
      : (1 - (state._remainingSeconds / totalSeconds))
            .clamp(0.0, 1.0)
            .toDouble();
  final safeRemainingSeconds = state._remainingSeconds.clamp(0, 5999).toInt();
  final timeDisplay =
      '${(safeRemainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(safeRemainingSeconds % 60).toString().padLeft(2, '0')}';

  return (progress: progress, timeDisplay: timeDisplay);
}
