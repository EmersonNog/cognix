part of '../training_pomodoro_models.dart';

String formatPomodoroClock(int totalSeconds) {
  final clampedSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = (clampedSeconds ~/ 60).toString().padLeft(2, '0');
  final seconds = (clampedSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

int _durationSecondsFromJson(
  Map<String, dynamic> json, {
  required String secondsKey,
  required String legacyMinutesKey,
  required int fallback,
  required int max,
}) {
  final rawSeconds = json[secondsKey];
  if (rawSeconds != null) {
    return _clampDurationSeconds(rawSeconds, fallback: fallback, max: max);
  }

  final optionalDuration = _optionalDurationSecondsFromJson(
    json,
    secondsKey: secondsKey,
    legacyMinutesKey: legacyMinutesKey,
    max: max,
  );
  return optionalDuration ?? fallback;
}

int _pauseDurationSecondsFromJson(
  Map<String, dynamic> json, {
  String? legacyPhaseValue,
}) {
  final directPauseDuration = _optionalDurationSecondsFromJson(
    json,
    secondsKey: 'pauseSeconds',
    legacyMinutesKey: 'pauseMinutes',
    max: 60 * 60,
  );
  if (directPauseDuration != null) {
    return directPauseDuration;
  }

  final prefersLongBreak = legacyPhaseValue == 'long_break';
  final orderedLegacyKeys = prefersLongBreak
      ? const [
          ('longBreakSeconds', 'longBreakMinutes'),
          ('shortBreakSeconds', 'shortBreakMinutes'),
        ]
      : const [
          ('shortBreakSeconds', 'shortBreakMinutes'),
          ('longBreakSeconds', 'longBreakMinutes'),
        ];

  for (final (secondsKey, legacyMinutesKey) in orderedLegacyKeys) {
    final legacyDuration = _optionalDurationSecondsFromJson(
      json,
      secondsKey: secondsKey,
      legacyMinutesKey: legacyMinutesKey,
      max: 60 * 60,
    );
    if (legacyDuration != null) {
      return legacyDuration;
    }
  }

  return 5 * 60;
}

int? _optionalDurationSecondsFromJson(
  Map<String, dynamic> json, {
  required String secondsKey,
  required String legacyMinutesKey,
  required int max,
}) {
  final rawSeconds = json[secondsKey];
  if (rawSeconds != null) {
    return _parseDurationSeconds(rawSeconds, max: max);
  }

  final rawLegacyMinutes = json[legacyMinutesKey];
  final parsedLegacyMinutes = int.tryParse('$rawLegacyMinutes');
  if (parsedLegacyMinutes == null) return null;
  return _clampDurationSeconds(parsedLegacyMinutes * 60, fallback: 1, max: max);
}

int? _parseDurationSeconds(Object? raw, {required int max}) {
  final parsed = int.tryParse('$raw');
  if (parsed == null) return null;
  return parsed.clamp(1, max).toInt();
}

int _clampDurationSeconds(
  Object? raw, {
  required int fallback,
  required int max,
}) {
  final parsed = int.tryParse('$raw');
  if (parsed == null) return fallback;
  return parsed.clamp(1, max).toInt();
}

int _clampRemainingSeconds(Object? raw, {required int fallback, int? max}) {
  final parsed = int.tryParse('$raw');
  if (parsed == null) return fallback;
  final upperBound = max ?? fallback;
  return parsed.clamp(1, upperBound).toInt();
}

int _clampCompletedSessions(Object? raw) {
  final parsed = int.tryParse('$raw');
  if (parsed == null) return 0;
  return parsed < 0 ? 0 : parsed;
}

int? _positiveIntOrNull(Object? raw) {
  final parsed = int.tryParse('$raw');
  if (parsed == null || parsed <= 0) return null;
  return parsed;
}
