part of '../training_pomodoro_screen.dart';

Future<void> _hydrateSnapshotForState(
  _TrainingPomodoroScreenState state,
) async {
  final storedSnapshot = await readTrainingPomodoroSnapshot();
  final snapshot = _resolveSnapshotForState(state, storedSnapshot);
  if (!state.mounted) return;

  state._update(() {
    _applySnapshotForState(state, snapshot);
    state._isHydrating = false;
  });

  if (state._isRunning) {
    _startTickerForState(state);
  }
}

Future<void> _persistSnapshotForState(
  _TrainingPomodoroScreenState state,
) async {
  if (state._isHydrating) return;
  await writeTrainingPomodoroSnapshot(_buildSnapshotForState(state));
}

TrainingPomodoroSnapshot _buildSnapshotForState(
  _TrainingPomodoroScreenState state,
) {
  final remaining = _currentRemainingSecondsForState(state);
  return TrainingPomodoroSnapshot(
    settings: state._settings,
    phase: state._phase,
    remainingSeconds: remaining,
    completedFocusSessions: state._completedFocusSessions,
    isRunning: state._isRunning,
    phaseEndsAtEpochMs: state._isRunning ? state._phaseEndsAtEpochMs : null,
  );
}

void _applySnapshotForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroSnapshot snapshot,
) {
  state._settings = snapshot.settings;
  state._phase = snapshot.phase;
  state._remainingSeconds = snapshot.remainingSeconds;
  state._completedFocusSessions = snapshot.completedFocusSessions;
  state._isRunning = snapshot.isRunning;
  state._phaseEndsAtEpochMs = snapshot.phaseEndsAtEpochMs;
}

TrainingPomodoroSnapshot _resolveSnapshotForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroSnapshot? snapshot,
) {
  final resolved = snapshot ?? TrainingPomodoroSnapshot.initial();
  final settings = resolved.settings;

  if (!resolved.isRunning || resolved.phaseEndsAtEpochMs == null) {
    return resolved.copyWith(
      remainingSeconds: resolved.remainingSeconds
          .clamp(1, settings.secondsFor(resolved.phase))
          .toInt(),
      clearPhaseEndsAt: true,
      isRunning: false,
    );
  }

  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final initialEndAt = resolved.phaseEndsAtEpochMs!;
  var overflowSeconds = ((nowMs - initialEndAt) / 1000).floor();

  if (overflowSeconds < 0) {
    return resolved.copyWith(
      remainingSeconds: _remainingFromEndAtForState(state, initialEndAt),
    );
  }

  var phase = resolved.phase;
  var completedFocusSessions = resolved.completedFocusSessions;
  while (true) {
    final transition = _transitionFromPhaseForState(
      phase: phase,
      completedFocusSessions: completedFocusSessions,
      countCompletedFocus: phase == TrainingPomodoroPhase.focus,
    );
    phase = transition.$1;
    completedFocusSessions = transition.$2;
    final phaseDuration = settings.secondsFor(phase);

    if (overflowSeconds < phaseDuration) {
      final remainingSeconds = phaseDuration - overflowSeconds;
      return TrainingPomodoroSnapshot(
        settings: resolved.settings,
        phase: phase,
        remainingSeconds: remainingSeconds,
        completedFocusSessions: completedFocusSessions,
        isRunning: true,
        phaseEndsAtEpochMs: nowMs + (remainingSeconds * 1000),
      );
    }

    overflowSeconds -= phaseDuration;
  }
}
