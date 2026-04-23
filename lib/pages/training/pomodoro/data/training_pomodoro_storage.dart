import 'dart:convert';

import '../../../../services/local/shared_preferences_store.dart';
import '../models/training_pomodoro_models.dart';

const _pomodoroSnapshotKey = 'training.pomodoro.snapshot';

ScopedPreferenceKey _resolvePomodoroSnapshotKey() {
  return SharedPreferencesStore.resolveScopedKey(_pomodoroSnapshotKey);
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
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return TrainingPomodoroSnapshot.fromJson(decoded);
  } catch (_) {
    return null;
  }
}

Future<void> writeTrainingPomodoroSnapshot(
  TrainingPomodoroSnapshot snapshot,
) async {
  final prefs = await SharedPreferencesStore.instance();
  final key = _resolvePomodoroSnapshotKey();
  await prefs.setString(key.storageKey, jsonEncode(snapshot.toJson()));
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
