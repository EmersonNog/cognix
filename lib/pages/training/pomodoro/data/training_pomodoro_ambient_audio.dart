import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../widgets/ambient_panel/training_pomodoro_ambient_track.dart';

final AudioPlayer _trainingPomodoroAmbientPlayer = AudioPlayer(
  playerId: 'training_pomodoro_ambient',
);

final AudioContext _trainingPomodoroAmbientAudioContext = AudioContext(
  android: AudioContextAndroid(
    contentType: AndroidContentType.music,
    usageType: AndroidUsageType.media,
    audioFocus: AndroidAudioFocus.gain,
  ),
  iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
);

bool _trainingPomodoroAmbientConfigured = false;
bool _trainingPomodoroAmbientIsPlaying = false;
bool _trainingPomodoroAmbientIsPaused = false;
TrainingPomodoroAmbientTrack _trainingPomodoroAmbientSelectedTrack =
    TrainingPomodoroAmbientTrack.lofi;
double _trainingPomodoroAmbientVolume = 0.50;

bool get isTrainingPomodoroAmbientPlaying => _trainingPomodoroAmbientIsPlaying;

TrainingPomodoroAmbientTrack get currentTrainingPomodoroAmbientTrack =>
    _trainingPomodoroAmbientSelectedTrack;

double get currentTrainingPomodoroAmbientVolume =>
    _trainingPomodoroAmbientVolume;

Future<void> playTrainingPomodoroAmbient({
  required TrainingPomodoroAmbientTrack track,
  required double volume,
}) async {
  final previousTrack = _trainingPomodoroAmbientSelectedTrack;
  final previousVolume = _trainingPomodoroAmbientVolume;

  try {
    await _configureTrainingPomodoroAmbientPlayer();

    final safeVolume = volume.clamp(0.0, 1.0).toDouble();
    final isResumingCurrentTrack =
        _trainingPomodoroAmbientSelectedTrack == track &&
        _trainingPomodoroAmbientIsPaused;

    _trainingPomodoroAmbientSelectedTrack = track;
    _trainingPomodoroAmbientVolume = safeVolume;

    await _trainingPomodoroAmbientPlayer.setVolume(safeVolume);

    if (isResumingCurrentTrack) {
      await _trainingPomodoroAmbientPlayer.resume();
    } else {
      await _trainingPomodoroAmbientPlayer.stop();
      await _trainingPomodoroAmbientPlayer.play(
        AssetSource(track.assetPath, mimeType: 'audio/mpeg'),
        ctx: _trainingPomodoroAmbientAudioContext,
        mode: PlayerMode.mediaPlayer,
        volume: safeVolume,
      );
    }

    _trainingPomodoroAmbientIsPlaying = true;
    _trainingPomodoroAmbientIsPaused = false;
  } catch (error, stackTrace) {
    _trainingPomodoroAmbientSelectedTrack = previousTrack;
    _trainingPomodoroAmbientVolume = previousVolume;
    _trainingPomodoroAmbientIsPlaying = false;
    _trainingPomodoroAmbientIsPaused = false;
    debugPrint(
      'Pomodoro ambient playback failed: $error\n$stackTrace',
    );
    rethrow;
  }
}

Future<void> pauseTrainingPomodoroAmbient() async {
  if (!_trainingPomodoroAmbientConfigured || !_trainingPomodoroAmbientIsPlaying) {
    return;
  }

  try {
    await _trainingPomodoroAmbientPlayer.pause();
    _trainingPomodoroAmbientIsPlaying = false;
    _trainingPomodoroAmbientIsPaused = true;
  } catch (error, stackTrace) {
    debugPrint(
      'Pomodoro ambient pause failed: $error\n$stackTrace',
    );
    rethrow;
  }
}

Future<void> setTrainingPomodoroAmbientVolume(double value) async {
  final safeVolume = value.clamp(0.0, 1.0).toDouble();
  _trainingPomodoroAmbientVolume = safeVolume;

  if (!_trainingPomodoroAmbientConfigured) return;

  try {
    await _trainingPomodoroAmbientPlayer.setVolume(safeVolume);
  } catch (error, stackTrace) {
    debugPrint(
      'Pomodoro ambient volume update failed: $error\n$stackTrace',
    );
    rethrow;
  }
}

Future<void> _configureTrainingPomodoroAmbientPlayer() async {
  if (_trainingPomodoroAmbientConfigured) return;

  await _trainingPomodoroAmbientPlayer.setAudioContext(
    _trainingPomodoroAmbientAudioContext,
  );
  await _trainingPomodoroAmbientPlayer.setPlayerMode(PlayerMode.mediaPlayer);
  await _trainingPomodoroAmbientPlayer.setReleaseMode(ReleaseMode.loop);
  await _trainingPomodoroAmbientPlayer.setVolume(
    _trainingPomodoroAmbientVolume,
  );

  _trainingPomodoroAmbientConfigured = true;
}
