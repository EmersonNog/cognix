part of '../training_pomodoro_models.dart';

enum TrainingPomodoroPhase { focus, pause }

extension TrainingPomodoroPhaseX on TrainingPomodoroPhase {
  String get storageValue => switch (this) {
    TrainingPomodoroPhase.focus => 'focus',
    TrainingPomodoroPhase.pause => 'pause',
  };

  String get label => switch (this) {
    TrainingPomodoroPhase.focus => 'Foco',
    TrainingPomodoroPhase.pause => 'Pausa',
  };

  String get description => switch (this) {
    TrainingPomodoroPhase.focus =>
      'Hora de concentrar e levar uma tarefa ate o fim.',
    TrainingPomodoroPhase.pause =>
      'Respire, se alongue e volte com a mente fresca.',
  };
}

TrainingPomodoroPhase trainingPomodoroPhaseFromStorage(String? value) {
  return switch (value) {
    'pause' || 'short_break' || 'long_break' => TrainingPomodoroPhase.pause,
    _ => TrainingPomodoroPhase.focus,
  };
}
