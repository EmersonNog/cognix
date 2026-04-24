import 'package:cognix/pages/training/pomodoro/data/training_pomodoro_storage.dart';
import 'package:cognix/pages/training/pomodoro/models/training_pomodoro_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('training pomodoro snapshot payload', () {
    const runtimeSessionId = 'runtime-session';
    final snapshot = TrainingPomodoroSnapshot(
      settings: const TrainingPomodoroSettings(
        focusSeconds: 1500,
        pauseSeconds: 300,
      ),
      phase: TrainingPomodoroPhase.focus,
      remainingSeconds: 1200,
      completedFocusSessions: 2,
      isRunning: true,
      phaseEndsAtEpochMs: 123456789,
    );

    test('restores snapshots from the current runtime session', () {
      final payload = encodeTrainingPomodoroSnapshotPayload(
        snapshot,
        runtimeSessionId: runtimeSessionId,
      );

      final restored = decodeTrainingPomodoroSnapshotPayload(
        payload,
        runtimeSessionId: runtimeSessionId,
      );

      expect(restored, isNotNull);
      expect(restored!.phase, TrainingPomodoroPhase.focus);
      expect(restored.remainingSeconds, 1200);
      expect(restored.completedFocusSessions, 2);
      expect(restored.isRunning, isTrue);
      expect(restored.phaseEndsAtEpochMs, 123456789);
    });

    test('ignores snapshots from another runtime session', () {
      final payload = encodeTrainingPomodoroSnapshotPayload(
        snapshot,
        runtimeSessionId: 'previous-runtime',
      );

      final restored = decodeTrainingPomodoroSnapshotPayload(
        payload,
        runtimeSessionId: runtimeSessionId,
      );

      expect(restored, isNull);
    });

    test('ignores legacy payloads without a runtime session id', () {
      final restored = decodeTrainingPomodoroSnapshotPayload(
        snapshot.toJson(),
        runtimeSessionId: runtimeSessionId,
      );

      expect(restored, isNull);
    });
  });
}
