part of '../training_pomodoro_screen.dart';

void _initScreenForState(_TrainingPomodoroScreenState state) {
  WidgetsBinding.instance.addObserver(state);
  _syncAmbientStateForState(state);
  trainingPomodoroOverlayController.attachForegroundSession();
  unawaited(_hydrateSnapshotForState(state));
}

void _handleLifecycleChangeForState(
  _TrainingPomodoroScreenState state,
  AppLifecycleState nextState,
) {
  if (nextState == AppLifecycleState.resumed) {
    _handleResumeForState(state);
    return;
  }

  if (nextState == AppLifecycleState.inactive ||
      nextState == AppLifecycleState.paused ||
      nextState == AppLifecycleState.hidden) {
    unawaited(_persistSnapshotForState(state));
  }
}

void _disposeScreenForState(_TrainingPomodoroScreenState state) {
  WidgetsBinding.instance.removeObserver(state);
  _stopTickerForState(state);
  state._minutesController.dispose();
  state._secondsController.dispose();
  state._minutesFocusNode.dispose();
  state._secondsFocusNode.dispose();

  if (!state._isHydrating) {
    trainingPomodoroOverlayController.updateSnapshot(
      _buildSnapshotForState(state),
    );
    unawaited(_persistSnapshotForState(state));
  }

  trainingPomodoroOverlayController.detachForegroundSession();
}
