import '../models/training_pomodoro_models.dart';

TrainingPomodoroSnapshot resolveTrainingPomodoroSnapshot(
  TrainingPomodoroSnapshot? snapshot, {
  DateTime? now,
}) {
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

  final nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
  final initialEndAt = resolved.phaseEndsAtEpochMs!;
  var overflowSeconds = ((nowMs - initialEndAt) / 1000).floor();

  if (overflowSeconds < 0) {
    return resolved.copyWith(
      remainingSeconds: trainingPomodoroRemainingFromEndAt(
        initialEndAt,
        now: now,
      ),
    );
  }

  var phase = resolved.phase;
  var completedFocusSessions = resolved.completedFocusSessions;
  while (true) {
    final transition = trainingPomodoroTransitionFromPhase(
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

int trainingPomodoroRemainingFromEndAt(
  int phaseEndsAtEpochMs, {
  DateTime? now,
}) {
  final remainingMs =
      phaseEndsAtEpochMs - (now ?? DateTime.now()).millisecondsSinceEpoch;
  final remainingSeconds = (remainingMs / 1000).ceil();
  return remainingSeconds < 0 ? 0 : remainingSeconds;
}

(TrainingPomodoroPhase, int) trainingPomodoroTransitionFromPhase({
  required TrainingPomodoroPhase phase,
  required int completedFocusSessions,
  required bool countCompletedFocus,
}) {
  if (phase == TrainingPomodoroPhase.focus) {
    final nextCompletedFocusSessions = countCompletedFocus
        ? completedFocusSessions + 1
        : completedFocusSessions;
    return (TrainingPomodoroPhase.pause, nextCompletedFocusSessions);
  }

  return (TrainingPomodoroPhase.focus, completedFocusSessions);
}

bool trainingPomodoroSnapshotsEqual(
  TrainingPomodoroSnapshot first,
  TrainingPomodoroSnapshot second,
) {
  return first.settings.focusSeconds == second.settings.focusSeconds &&
      first.settings.pauseSeconds == second.settings.pauseSeconds &&
      first.phase == second.phase &&
      first.remainingSeconds == second.remainingSeconds &&
      first.completedFocusSessions == second.completedFocusSessions &&
      first.isRunning == second.isRunning &&
      first.phaseEndsAtEpochMs == second.phaseEndsAtEpochMs;
}
