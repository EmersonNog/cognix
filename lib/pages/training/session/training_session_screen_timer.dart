part of 'training_session_screen.dart';

void _startTimerForState(_TrainingSessionScreenState state) {
  if (!state._paused) {
    state._stopwatch.start();
  }

  state._ticker?.cancel();
  state._ticker = Timer.periodic(const Duration(seconds: 1), (_) {
    if (!state.mounted || !state._stopwatch.isRunning) return;

    final seconds = _currentElapsedForState(state).inSeconds;
    if (seconds != state._lastSavedSecond && seconds % 5 == 0) {
      state._lastSavedSecond = seconds;
      _saveSessionStateForState(state);
    }
    state._update(() {});
  });
}

void _togglePauseForState(_TrainingSessionScreenState state) {
  state._update(() {
    state._paused = !state._paused;
    if (state._paused) {
      state._elapsedOffset += state._stopwatch.elapsed;
      state._stopwatch
        ..stop()
        ..reset();
    } else {
      state._stopwatch.start();
    }
  });
  _saveSessionStateForState(state);
}

String _formatElapsedForDuration(Duration elapsed) {
  final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
  final hours = elapsed.inHours;
  if (hours > 0) {
    final hh = hours.toString().padLeft(2, '0');
    return '$hh:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

Duration _currentElapsedForState(_TrainingSessionScreenState state) {
  return state._elapsedOffset + state._stopwatch.elapsed;
}
