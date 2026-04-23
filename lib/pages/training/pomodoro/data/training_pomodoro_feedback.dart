import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

const _trainingPomodoroFocusCompletionToneAsset =
    'audio/pomodoro_focus_complete.wav';
const _trainingPomodoroPauseCompletionToneAsset =
    'audio/pomodoro_pause_complete.wav';
const _trainingPomodoroCompletionVibrationDurationMs = 700;
const _trainingPomodoroCompletionVibrationGapMs = 220;

final AudioPlayer _trainingPomodoroCompletionTonePlayer = AudioPlayer(
  playerId: 'training_pomodoro_completion',
);

final AudioContext _trainingPomodoroCompletionAudioContext = AudioContext(
  android: AudioContextAndroid(
    contentType: AndroidContentType.sonification,
    usageType: AndroidUsageType.alarm,
    audioFocus: AndroidAudioFocus.gainTransient,
  ),
  iOS: AudioContextIOS(
    category: AVAudioSessionCategory.playback,
    options: {AVAudioSessionOptions.duckOthers},
  ),
);

bool _trainingPomodoroCompletionToneConfigured = false;

Future<void> playTrainingPomodoroFocusCompletionFeedback() async {
  await Future.wait<void>([
    _playTrainingPomodoroCompletionVibration(),
    _playTrainingPomodoroCompletionTone(
      assetPath: _trainingPomodoroFocusCompletionToneAsset,
      debugLabel: 'focus',
    ),
  ]);
}

Future<void> playTrainingPomodoroPauseCompletionFeedback() async {
  await Future.wait<void>([
    _playTrainingPomodoroCompletionVibration(),
    _playTrainingPomodoroCompletionTone(
      assetPath: _trainingPomodoroPauseCompletionToneAsset,
      debugLabel: 'pause',
    ),
  ]);
}

Future<void> _playTrainingPomodoroCompletionVibration() async {
  try {
    final hasCustomSupport = await Vibration.hasCustomVibrationsSupport();
    if (hasCustomSupport) {
      await Vibration.vibrate(
        pattern: <int>[
          0,
          _trainingPomodoroCompletionVibrationDurationMs,
          _trainingPomodoroCompletionVibrationGapMs,
          _trainingPomodoroCompletionVibrationDurationMs,
        ],
      );
      return;
    }

    await Vibration.vibrate(
      duration: _trainingPomodoroCompletionVibrationDurationMs,
    );
    await Future<void>.delayed(
      const Duration(milliseconds: _trainingPomodoroCompletionVibrationGapMs),
    );
    await Vibration.vibrate(
      duration: _trainingPomodoroCompletionVibrationDurationMs,
    );
  } catch (_) {}
}

Future<void> _playTrainingPomodoroCompletionTone({
  required String assetPath,
  required String debugLabel,
}) async {
  try {
    await _configureTrainingPomodoroCompletionTonePlayer();
    await _trainingPomodoroCompletionTonePlayer.stop();
    await _trainingPomodoroCompletionTonePlayer.play(
      AssetSource(assetPath, mimeType: 'audio/wav'),
      ctx: _trainingPomodoroCompletionAudioContext,
      mode: PlayerMode.mediaPlayer,
      volume: 1.0,
    );
  } catch (error, stackTrace) {
    debugPrint(
      'Pomodoro $debugLabel completion tone failed: $error\n$stackTrace',
    );
  }
}

Future<void> _configureTrainingPomodoroCompletionTonePlayer() async {
  if (_trainingPomodoroCompletionToneConfigured) return;

  await _trainingPomodoroCompletionTonePlayer.setAudioContext(
    _trainingPomodoroCompletionAudioContext,
  );
  await _trainingPomodoroCompletionTonePlayer.setPlayerMode(
    PlayerMode.mediaPlayer,
  );
  await _trainingPomodoroCompletionTonePlayer.setReleaseMode(ReleaseMode.stop);
  await _trainingPomodoroCompletionTonePlayer.setVolume(1.0);

  _trainingPomodoroCompletionToneConfigured = true;
}
