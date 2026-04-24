import 'dart:convert';

import '../../../../services/local/shared_preferences_store.dart';
import '../models/training_pomodoro_models.dart';

const _pomodoroSnapshotKey = 'training.pomodoro.snapshot';
const _pomodoroRuntimeSessionKey = 'runtimeSessionId';

final String trainingPomodoroRuntimeSessionId =
    _createTrainingPomodoroRuntimeSessionId();

String _createTrainingPomodoroRuntimeSessionId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final entropy = Object().hashCode.toRadixString(36);
  return '$timestamp-$entropy';
}

ScopedPreferenceKey _resolvePomodoroSnapshotKey() {
  return SharedPreferencesStore.resolveScopedKey(_pomodoroSnapshotKey);
}

Map<String, dynamic> encodeTrainingPomodoroSnapshotPayload(
  TrainingPomodoroSnapshot snapshot, {
  String? runtimeSessionId,
}) {
  return {
    ...snapshot.toJson(),
    _pomodoroRuntimeSessionKey:
        runtimeSessionId ?? trainingPomodoroRuntimeSessionId,
  };
}

TrainingPomodoroSnapshot? decodeTrainingPomodoroSnapshotPayload(
  Object? payload, {
  String? runtimeSessionId,
}) {
  if (payload is! Map) {
    return null;
  }

  final decoded = payload.cast<String, dynamic>();
  final storedRuntimeSessionId = decoded[_pomodoroRuntimeSessionKey]
      ?.toString()
      .trim();
  final expectedRuntimeSessionId =
      runtimeSessionId ?? trainingPomodoroRuntimeSessionId;

  if (storedRuntimeSessionId == null ||
      storedRuntimeSessionId.isEmpty ||
      storedRuntimeSessionId != expectedRuntimeSessionId) {
    return null;
  }

  return TrainingPomodoroSnapshot.fromJson(decoded);
}

Future<TrainingPomodoroSnapshot?> readTrainingPomodoroSnapshot() async {
  final prefs = await SharedPreferencesStore.instance();
  final key = _resolvePomodoroSnapshotKey();
  final raw = await prefs.getString(key.storageKey);
  if (key.hasLegacyBaseKey) {
    await prefs.remove(key.baseKey);
  }
  if (raw == null || raw.isEmpty) {
    return null;
  }

  try {
    final decoded = jsonDecode(raw);
    final snapshot = decodeTrainingPomodoroSnapshotPayload(decoded);
    if (snapshot == null) {
      await prefs.remove(key.storageKey);
      if (key.hasLegacyBaseKey) {
        await prefs.remove(key.baseKey);
      }
    }
    return snapshot;
  } catch (_) {
    await prefs.remove(key.storageKey);
    if (key.hasLegacyBaseKey) {
      await prefs.remove(key.baseKey);
    }
    return null;
  }
}

Future<void> writeTrainingPomodoroSnapshot(
  TrainingPomodoroSnapshot snapshot,
) async {
  final prefs = await SharedPreferencesStore.instance();
  final key = _resolvePomodoroSnapshotKey();
  await prefs.setString(
    key.storageKey,
    jsonEncode(encodeTrainingPomodoroSnapshotPayload(snapshot)),
  );
  if (key.hasLegacyBaseKey) {
    await prefs.remove(key.baseKey);
  }
}

Future<void> clearTrainingPomodoroSnapshot() async {
  final prefs = await SharedPreferencesStore.instance();
  final key = _resolvePomodoroSnapshotKey();
  await prefs.remove(key.storageKey);
  if (key.hasLegacyBaseKey) {
    await prefs.remove(key.baseKey);
  }
}
