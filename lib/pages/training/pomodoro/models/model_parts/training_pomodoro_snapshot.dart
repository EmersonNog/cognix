part of '../training_pomodoro_models.dart';

class TrainingPomodoroSnapshot {
  const TrainingPomodoroSnapshot({
    required this.settings,
    required this.phase,
    required this.remainingSeconds,
    required this.completedFocusSessions,
    required this.isRunning,
    this.phaseEndsAtEpochMs,
  });

  factory TrainingPomodoroSnapshot.initial() {
    const settings = TrainingPomodoroSettings();
    return TrainingPomodoroSnapshot(
      settings: settings,
      phase: TrainingPomodoroPhase.focus,
      remainingSeconds: settings.focusSeconds,
      completedFocusSessions: 0,
      isRunning: false,
    );
  }

  factory TrainingPomodoroSnapshot.fromJson(Map<String, dynamic> json) {
    final rawPhaseValue = json['phase']?.toString();
    final phase = trainingPomodoroPhaseFromStorage(rawPhaseValue);
    final settings = TrainingPomodoroSettings.fromJson(
      (json['settings'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{},
      legacyPhaseValue: rawPhaseValue,
    );
    final fallbackSeconds = settings.secondsFor(phase);

    return TrainingPomodoroSnapshot(
      settings: settings,
      phase: phase,
      remainingSeconds: _clampRemainingSeconds(
        json['remainingSeconds'],
        fallback: fallbackSeconds,
        max: fallbackSeconds,
      ),
      completedFocusSessions: _clampCompletedSessions(
        json['completedFocusSessions'],
      ),
      isRunning: json['isRunning'] == true,
      phaseEndsAtEpochMs: _positiveIntOrNull(json['phaseEndsAtEpochMs']),
    );
  }

  final TrainingPomodoroSettings settings;
  final TrainingPomodoroPhase phase;
  final int remainingSeconds;
  final int completedFocusSessions;
  final bool isRunning;
  final int? phaseEndsAtEpochMs;

  TrainingPomodoroSnapshot copyWith({
    TrainingPomodoroSettings? settings,
    TrainingPomodoroPhase? phase,
    int? remainingSeconds,
    int? completedFocusSessions,
    bool? isRunning,
    int? phaseEndsAtEpochMs,
    bool clearPhaseEndsAt = false,
  }) {
    return TrainingPomodoroSnapshot(
      settings: settings ?? this.settings,
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      completedFocusSessions:
          completedFocusSessions ?? this.completedFocusSessions,
      isRunning: isRunning ?? this.isRunning,
      phaseEndsAtEpochMs: clearPhaseEndsAt
          ? null
          : phaseEndsAtEpochMs ?? this.phaseEndsAtEpochMs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settings': settings.toJson(),
      'phase': phase.storageValue,
      'remainingSeconds': remainingSeconds,
      'completedFocusSessions': completedFocusSessions,
      'isRunning': isRunning,
      'phaseEndsAtEpochMs': phaseEndsAtEpochMs,
    };
  }
}
