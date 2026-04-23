part of '../training_pomodoro_screen.dart';

void _selectAmbientTrackForState(
  _TrainingPomodoroScreenState state,
  TrainingPomodoroAmbientTrack track,
) {
  if (state._selectedAmbientTrack == track) return;
  state._update(() => state._selectedAmbientTrack = track);
}

void _toggleAmbientPlaybackForState(_TrainingPomodoroScreenState state) {
  state._update(() => state._isAmbientPlaying = !state._isAmbientPlaying);
}

void _setAmbientVolumeForState(
  _TrainingPomodoroScreenState state,
  double value,
) {
  final safeValue = value.clamp(0.0, 1.0);
  if (state._ambientVolume == safeValue) return;
  state._update(() => state._ambientVolume = safeValue);
}
