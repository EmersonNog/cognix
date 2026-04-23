part of '../training_pomodoro_screen.dart';

void _setPhaseDurationForState(
  _TrainingPomodoroScreenState state, {
  required TrainingPomodoroPhase phase,
  required int totalSeconds,
}) {
  if (state._isRunning) {
    showCognixMessage(state.context, 'Pause o timer para ajustar as durações.');
    return;
  }

  final clampedSeconds = switch (phase) {
    TrainingPomodoroPhase.focus => totalSeconds.clamp(1, 90 * 60).toInt(),
    TrainingPomodoroPhase.pause => totalSeconds.clamp(1, 60 * 60).toInt(),
  };

  final nextSettings = switch (phase) {
    TrainingPomodoroPhase.focus => state._settings.copyWith(
      focusSeconds: clampedSeconds,
    ),
    TrainingPomodoroPhase.pause => state._settings.copyWith(
      pauseSeconds: clampedSeconds,
    ),
  };

  state._update(() {
    state._settings = nextSettings;
    if (state._phase == phase && !state._isRunning) {
      state._remainingSeconds = state._secondsForPhase(state._phase);
    }
  });

  unawaited(_persistSnapshotForState(state));
}

({int minutes, int seconds}) _timePartsForPhaseForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroPhase phase,
) {
  final totalSeconds = state._secondsForPhase(phase);
  return (minutes: totalSeconds ~/ 60, seconds: totalSeconds % 60);
}

void _beginInlineDurationEditForState(_TrainingPomodoroScreenState state) {
  if (state._isRunning) {
    showCognixMessage(state.context, 'Pause o timer para editar a duração.');
    return;
  }

  final parts = _timePartsForPhaseForState(state, state._phase);
  state._minutesController
    ..text = parts.minutes.toString().padLeft(2, '0')
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: state._minutesController.text.length,
    );
  state._secondsController
    ..text = parts.seconds.toString().padLeft(2, '0')
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: state._secondsController.text.length,
    );

  state._update(() => state._isEditingDuration = true);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!state.mounted) return;
    state._minutesFocusNode.requestFocus();
  });
}

bool _commitInlineDurationEditForState(_TrainingPomodoroScreenState state) {
  if (!state._isEditingDuration) return true;

  final parsedMinutes = int.tryParse(state._minutesController.text.trim());
  final parsedSeconds = int.tryParse(state._secondsController.text.trim());
  if (parsedMinutes == null || parsedSeconds == null || parsedSeconds > 59) {
    showCognixMessage(
      state.context,
      'Digite minutos e segundos válidos.',
      type: CognixMessageType.error,
    );
    state._minutesFocusNode.requestFocus();
    return false;
  }

  final totalSeconds = (parsedMinutes * 60) + parsedSeconds;
  if (totalSeconds <= 0) {
    showCognixMessage(
      state.context,
      'O tempo precisa ser maior que zero.',
      type: CognixMessageType.error,
    );
    state._minutesFocusNode.requestFocus();
    return false;
  }

  _setPhaseDurationForState(
    state,
    phase: state._phase,
    totalSeconds: totalSeconds,
  );
  state._minutesFocusNode.unfocus();
  state._secondsFocusNode.unfocus();
  if (!state.mounted) return true;
  state._update(() => state._isEditingDuration = false);
  return true;
}

void _selectFocusPhaseForState(_TrainingPomodoroScreenState state) {
  _switchPhaseForState(state, TrainingPomodoroPhase.focus);
}

void _selectPausePhaseForState(_TrainingPomodoroScreenState state) {
  _switchPhaseForState(state, TrainingPomodoroPhase.pause);
}

void _switchPhaseForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroPhase nextPhase,
) {
  if (state._isEditingDuration && !_commitInlineDurationEditForState(state)) {
    return;
  }

  if (state._isRunning) {
    showCognixMessage(state.context, 'Pause o timer para trocar a fase.');
    return;
  }

  if (state._phase == nextPhase) return;

  state._update(() {
    state._phase = nextPhase;
    state._remainingSeconds = state._secondsForPhase(nextPhase);
    state._phaseEndsAtEpochMs = null;
    state._isRunning = false;
  });

  unawaited(_persistSnapshotForState(state));
}
