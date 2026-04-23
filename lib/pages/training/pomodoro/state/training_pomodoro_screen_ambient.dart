part of '../training_pomodoro_screen.dart';

void _syncAmbientStateForState(_TrainingPomodoroScreenState state) {
  state._selectedAmbientTrack = currentTrainingPomodoroAmbientTrack;
  state._isAmbientPlaying = isTrainingPomodoroAmbientPlaying;
  state._ambientVolume = currentTrainingPomodoroAmbientVolume;
}

void _selectAmbientTrackForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroAmbientTrack track,
) {
  if (state._selectedAmbientTrack == track) return;

  final previousTrack = state._selectedAmbientTrack;
  state._update(() => state._selectedAmbientTrack = track);

  if (!state._isAmbientPlaying) return;
  unawaited(
    _playSelectedAmbientTrackForState(
      state,
      nextTrack: track,
      previousTrack: previousTrack,
    ),
  );
}

void _toggleAmbientPlaybackForState(_TrainingPomodoroScreenState state) {
  if (state._isAmbientPlaying) {
    unawaited(_pauseAmbientPlaybackForState(state));
    return;
  }

  unawaited(
    _playSelectedAmbientTrackForState(
      state,
      nextTrack: state._selectedAmbientTrack,
    ),
  );
}

void _setAmbientVolumeForState(
  _TrainingPomodoroScreenState state,
  double value,
) {
  final safeValue = value.clamp(0.0, 1.0);
  if (state._ambientVolume == safeValue) return;
  state._update(() => state._ambientVolume = safeValue.toDouble());
  unawaited(setTrainingPomodoroAmbientVolume(safeValue.toDouble()));
}

Future<void> _playSelectedAmbientTrackForState(
  _TrainingPomodoroScreenState state, {
  required TrainingPomodoroAmbientTrack nextTrack,
  TrainingPomodoroAmbientTrack? previousTrack,
}) async {
  try {
    await playTrainingPomodoroAmbient(
      track: nextTrack,
      volume: state._ambientVolume,
    );
    if (!state.mounted) return;
    state._update(() => state._isAmbientPlaying = true);
  } catch (_) {
    if (!state.mounted) return;
    if (previousTrack != null) {
      state._update(() => state._selectedAmbientTrack = previousTrack);
    }
    state._update(() => state._isAmbientPlaying = false);
    showCognixMessage(
      state.context,
      'Não foi possível tocar o áudio agora.',
      type: CognixMessageType.error,
    );
  }
}

Future<void> _pauseAmbientPlaybackForState(
  _TrainingPomodoroScreenState state,
) async {
  try {
    await pauseTrainingPomodoroAmbient();
    if (!state.mounted) return;
    state._update(() => state._isAmbientPlaying = false);
  } catch (_) {
    if (!state.mounted) return;
    showCognixMessage(
      state.context,
      'Não foi possível pausar o áudio agora.',
      type: CognixMessageType.error,
    );
  }
}
