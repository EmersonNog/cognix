import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../../../widgets/cognix/cognix_messages.dart';
import 'data/training_pomodoro_feedback.dart';
import 'data/training_pomodoro_runtime.dart';
import 'data/training_pomodoro_storage.dart';
import 'models/training_pomodoro_models.dart';

final trainingPomodoroOverlayController = TrainingPomodoroOverlayController._();

class TrainingPomodoroOverlayController extends ChangeNotifier {
  TrainingPomodoroOverlayController._();

  TrainingPomodoroSnapshot? _snapshot;
  Timer? _ticker;
  bool _foregroundSessionAttached = false;
  bool _isHydrating = false;
  bool _notificationScheduled = false;

  bool get isVisible =>
      _snapshot?.isRunning == true && !_foregroundSessionAttached;

  TrainingPomodoroPhase? get phase => _snapshot?.phase;

  int get remainingSeconds {
    final snapshot = _snapshot;
    if (snapshot == null) return 0;
    if (!snapshot.isRunning || snapshot.phaseEndsAtEpochMs == null) {
      return snapshot.remainingSeconds;
    }

    return trainingPomodoroRemainingFromEndAt(snapshot.phaseEndsAtEpochMs!);
  }

  String get timeDisplay => formatPomodoroClock(remainingSeconds);

  Future<void> hydrate() async {
    if (_isHydrating) return;
    _isHydrating = true;
    try {
      final storedSnapshot = await readTrainingPomodoroSnapshot();
      final resolvedSnapshot = resolveTrainingPomodoroSnapshot(storedSnapshot);
      _snapshot = resolvedSnapshot;
      _syncTicker();

      if (storedSnapshot != null &&
          !trainingPomodoroSnapshotsEqual(storedSnapshot, resolvedSnapshot)) {
        await writeTrainingPomodoroSnapshot(resolvedSnapshot);
      }

      _notifyListenersSafely();
    } finally {
      _isHydrating = false;
    }
  }

  void attachForegroundSession() {
    _foregroundSessionAttached = true;
    _syncTicker();
    _notifyListenersSafely();
  }

  void detachForegroundSession() {
    _foregroundSessionAttached = false;
    _syncTicker();
    _notifyListenersSafely();
  }

  void updateSnapshot(TrainingPomodoroSnapshot snapshot) {
    _snapshot = snapshot;
    _syncTicker();
    _notifyListenersSafely();
  }

  void clear() {
    _snapshot = null;
    _stopTicker();
    _notifyListenersSafely();
  }

  void _syncTicker() {
    if (_snapshot?.isRunning != true) {
      _stopTicker();
      return;
    }

    _ticker ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTick(),
    );
  }

  void _handleTick() {
    final snapshot = _snapshot;
    if (snapshot == null || !snapshot.isRunning) {
      _stopTicker();
      _notifyListenersSafely();
      return;
    }

    if (_foregroundSessionAttached) {
      _notifyListenersSafely();
      return;
    }

    final resolvedSnapshot = resolveTrainingPomodoroSnapshot(snapshot);
    final changed = !trainingPomodoroSnapshotsEqual(snapshot, resolvedSnapshot);
    _snapshot = resolvedSnapshot;

    if (changed) {
      _handleBackgroundPhaseTransition(snapshot, resolvedSnapshot);
      unawaited(writeTrainingPomodoroSnapshot(resolvedSnapshot));
    }

    _notifyListenersSafely();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _handleBackgroundPhaseTransition(
    TrainingPomodoroSnapshot previous,
    TrainingPomodoroSnapshot next,
  ) {
    if (!previous.isRunning || previous.phase == next.phase) return;

    if (previous.phase == TrainingPomodoroPhase.focus) {
      showGlobalCognixMessage(
        'Sessão de foco concluída. Hora da ${next.phase.label.toLowerCase()}.',
        type: CognixMessageType.success,
      );
      unawaited(playTrainingPomodoroFocusCompletionFeedback());
      return;
    }

    showGlobalCognixMessage('Pausa concluída. Vamos voltar ao foco.');
    unawaited(playTrainingPomodoroPauseCompletionFeedback());
  }

  void _notifyListenersSafely() {
    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    final canNotifyImmediately =
        schedulerPhase == SchedulerPhase.idle ||
        schedulerPhase == SchedulerPhase.postFrameCallbacks;

    if (canNotifyImmediately) {
      notifyListeners();
      return;
    }

    if (_notificationScheduled) return;
    _notificationScheduled = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      notifyListeners();
    });
  }
}
