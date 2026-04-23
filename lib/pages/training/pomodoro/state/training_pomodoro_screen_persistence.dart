part of '../training_pomodoro_screen.dart';

Future<void> _hydrateSnapshotForState(
  _TrainingPomodoroScreenState state,
) async {
  final storedSnapshot = await readTrainingPomodoroSnapshot();
  final snapshot = resolveTrainingPomodoroSnapshot(storedSnapshot);
  if (!state.mounted) return;

  state._update(() {
    _applySnapshotForState(state, snapshot);
    state._isHydrating = false;
  });
  trainingPomodoroOverlayController.updateSnapshot(snapshot);

  if (state._isRunning) {
    _startTickerForState(state);
  }
}

Future<void> _persistSnapshotForState(
  _TrainingPomodoroScreenState state,
) async {
  if (state._isHydrating) return;
  final snapshot = _buildSnapshotForState(state);
  trainingPomodoroOverlayController.updateSnapshot(snapshot);
  await writeTrainingPomodoroSnapshot(snapshot);
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
