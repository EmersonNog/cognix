part of '../training_pomodoro_models.dart';

class TrainingPomodoroSettings {
  const TrainingPomodoroSettings({
    this.focusSeconds = 25 * 60,
    this.pauseSeconds = 5 * 60,
  });

  factory TrainingPomodoroSettings.fromJson(
    Map<String, dynamic> json, {
    String? legacyPhaseValue,
  }) {
    return TrainingPomodoroSettings(
      focusSeconds: _durationSecondsFromJson(
        json,
        secondsKey: 'focusSeconds',
        legacyMinutesKey: 'focusMinutes',
        fallback: 25 * 60,
        max: 90 * 60,
      ),
      pauseSeconds: _pauseDurationSecondsFromJson(
        json,
        legacyPhaseValue: legacyPhaseValue,
      ),
    );
  }

  final int focusSeconds;
  final int pauseSeconds;

  int secondsFor(TrainingPomodoroPhase phase) {
    return switch (phase) {
      TrainingPomodoroPhase.focus => focusSeconds,
      TrainingPomodoroPhase.pause => pauseSeconds,
    };
  }

  TrainingPomodoroSettings copyWith({int? focusSeconds, int? pauseSeconds}) {
    return TrainingPomodoroSettings(
      focusSeconds: focusSeconds ?? this.focusSeconds,
      pauseSeconds: pauseSeconds ?? this.pauseSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {'focusSeconds': focusSeconds, 'pauseSeconds': pauseSeconds};
  }
}
