part of '../training_pomodoro_screen.dart';

int _currentRemainingSecondsForState(_TrainingPomodoroScreenState state) {
  if (!state._isRunning || state._phaseEndsAtEpochMs == null) {
    return state._remainingSeconds;
  }

  return _remainingFromEndAtForState(state, state._phaseEndsAtEpochMs!);
}

int _remainingFromEndAtForState(
  _TrainingPomodoroScreenState _,
  int phaseEndsAtEpochMs,
) {
  return trainingPomodoroRemainingFromEndAt(phaseEndsAtEpochMs);
}

void _handleResumeForState(_TrainingPomodoroScreenState state) {
  if (!state._isRunning) return;

  final remainingSeconds = _currentRemainingSecondsForState(state);
  if (remainingSeconds <= 0) {
    _completeCurrentPhaseForState(state);
    return;
  }

  if (!state.mounted) return;
  state._update(() => state._remainingSeconds = remainingSeconds);
  _startTickerForState(state);
}

void _startTickerForState(_TrainingPomodoroScreenState state) {
  _stopTickerForState(state);
  state._ticker = Timer.periodic(const Duration(seconds: 1), (_) {
    final remainingSeconds = _currentRemainingSecondsForState(state);
    if (!state.mounted) return;

    if (remainingSeconds <= 0) {
      _completeCurrentPhaseForState(state);
      return;
    }

    state._update(() => state._remainingSeconds = remainingSeconds);
  });
}

void _stopTickerForState(_TrainingPomodoroScreenState state) {
  state._ticker?.cancel();
  state._ticker = null;
}

void _toggleRunningForState(_TrainingPomodoroScreenState state) {
  if (state._isEditingDuration && !_commitInlineDurationEditForState(state)) {
    return;
  }

  if (state._isRunning) {
    _pauseTimerForState(state);
  } else {
    _startTimerForState(state);
  }
}

void _startTimerForState(_TrainingPomodoroScreenState state) {
  final remainingSeconds = state._remainingSeconds <= 0
      ? state._secondsForPhase(state._phase)
      : state._remainingSeconds;
  final phaseEndsAtEpochMs =
      DateTime.now().millisecondsSinceEpoch + (remainingSeconds * 1000);

  state._update(() {
    state._remainingSeconds = remainingSeconds;
    state._phaseEndsAtEpochMs = phaseEndsAtEpochMs;
    state._isRunning = true;
  });

  _startTickerForState(state);
  unawaited(_persistSnapshotForState(state));
}

void _pauseTimerForState(_TrainingPomodoroScreenState state) {
  _stopTickerForState(state);
  state._update(() {
    state._remainingSeconds = _currentRemainingSecondsForState(
      state,
    ).clamp(1, state._secondsForPhase(state._phase)).toInt();
    state._phaseEndsAtEpochMs = null;
    state._isRunning = false;
  });
  unawaited(_persistSnapshotForState(state));
}

void _resetCurrentPhaseForState(_TrainingPomodoroScreenState state) {
  if (state._isEditingDuration && !_commitInlineDurationEditForState(state)) {
    return;
  }

  _stopTickerForState(state);
  state._update(() {
    state._remainingSeconds = state._secondsForPhase(state._phase);
    state._phaseEndsAtEpochMs = null;
    state._isRunning = false;
  });
  unawaited(_persistSnapshotForState(state));
}

void _completeCurrentPhaseForState(_TrainingPomodoroScreenState state) {
  _stopTickerForState(state);
  final completedPhase = state._phase;
  final transition = trainingPomodoroTransitionFromPhase(
    phase: completedPhase,
    completedFocusSessions: state._completedFocusSessions,
    countCompletedFocus: completedPhase == TrainingPomodoroPhase.focus,
  );
  final nextPhase = transition.$1;
  final completedFocusSessions = transition.$2;
  final nextRemainingSeconds = state._secondsForPhase(nextPhase);
  final nextPhaseEndsAtEpochMs =
      DateTime.now().millisecondsSinceEpoch + (nextRemainingSeconds * 1000);

  state._update(() {
    state._phase = nextPhase;
    state._completedFocusSessions = completedFocusSessions;
    state._remainingSeconds = nextRemainingSeconds;
    state._phaseEndsAtEpochMs = nextPhaseEndsAtEpochMs;
    state._isRunning = true;
  });

  _startTickerForState(state);
  unawaited(_persistSnapshotForState(state));

  if (!state.mounted) return;
  if (completedPhase == TrainingPomodoroPhase.focus) {
    showCognixMessage(
      state.context,
      'Sessão de foco concluída. Hora da ${nextPhase.label.toLowerCase()}.',
      type: CognixMessageType.success,
    );
    unawaited(playTrainingPomodoroFocusCompletionFeedback());
  } else {
    showCognixMessage(state.context, 'Pausa concluída. Vamos voltar ao foco.');
    unawaited(playTrainingPomodoroPauseCompletionFeedback());
  }
}
