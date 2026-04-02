import 'dart:convert';

import '../../../services/local/shared_preferences_store.dart';

import '../../../services/questions/questions_api.dart';
import 'training_session_models.dart';
import 'training_session_state_codec.dart';

Future<Map<String, dynamic>?> readLocalTrainingSessionState(
  String sessionKey,
) async {
  final prefs = await SharedPreferencesStore.instance();
  final raw = await prefs.getString(sessionKey);
  if (raw == null || raw.isEmpty) {
    return null;
  }

  try {
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

Future<void> writeLocalTrainingSessionState(
  String sessionKey,
  Map<String, dynamic> payload,
) async {
  final prefs = await SharedPreferencesStore.instance();
  await prefs.setString(sessionKey, jsonEncode(payload));
}

Future<void> saveRemoteTrainingSessionState({
  required String discipline,
  required String subcategory,
  required Map<String, dynamic> payload,
}) async {
  await saveTrainingSession(
    discipline: discipline,
    subcategory: subcategory,
    state: payload,
  );
}

Future<TrainingSessionState?> readRemoteTrainingSessionState({
  required String discipline,
  required String subcategory,
}) async {
  try {
    return await fetchTrainingSession(
      discipline: discipline,
      subcategory: subcategory,
    );
  } catch (_) {
    return null;
  }
}

Future<Map<String, dynamic>?> hydrateTrainingSessionState(
  Map<String, dynamic> decoded,
) async {
  if (decoded['questions'] is List && (decoded['questions'] as List).isNotEmpty) {
    return decoded;
  }

  final idsRaw = decoded['questionIds'];
  if (idsRaw is! List || idsRaw.isEmpty) {
    return null;
  }

  final ids = idsRaw
      .map((e) => int.tryParse(e.toString()))
      .whereType<int>()
      .toList();
  if (ids.isEmpty) {
    return null;
  }

  final items = await fetchQuestionsByIds(ids);
  if (items.isEmpty) return null;

  final returnedIds = items.map((e) => e.id).toSet();
  final filteredIds = ids.where(returnedIds.contains).toList();
  if (filteredIds.isEmpty) return null;

  return {
    ...decoded,
    'questionIds': filteredIds,
    'currentIndex': clampTrainingSessionIndex(
      decoded['currentIndex'],
      filteredIds.length,
    ),
    'selections': filterTrainingSessionMapByIds(
      decoded['selections'],
      returnedIds,
    ),
    'lastSubmitted': filterTrainingSessionMapByIds(
      decoded['lastSubmitted'],
      returnedIds,
    ),
    'isCorrect': filterTrainingSessionMapByIds(
      decoded['isCorrect'],
      returnedIds,
    ),
    'correctOptionIndexByQuestionId': filterTrainingSessionMapByIds(
      decoded['correctOptionIndexByQuestionId'] ?? decoded['correctOptionIndex'],
      returnedIds,
    ),
    'feedbackQuestionId': (() {
      final raw = int.tryParse('${decoded['feedbackQuestionId']}');
      if (raw == null || !returnedIds.contains(raw)) {
        return null;
      }
      return raw;
    })(),
    'questions': items.map(serializeQuestionItem).toList(),
  };
}

TrainingCompletedSessionResult buildCompletedTrainingSessionResult({
  required int totalQuestions,
  required int answeredQuestions,
  required int correctAnswers,
  required int wrongAnswers,
  required int elapsedSeconds,
}) {
  return TrainingCompletedSessionResult(
    totalQuestions: totalQuestions,
    answeredQuestions: answeredQuestions,
    correctAnswers: correctAnswers,
    wrongAnswers: wrongAnswers,
    elapsedSeconds: elapsedSeconds,
  );
}

Future<TrainingSessionRestoreOutcome?> restoreTrainingSessionSnapshot({
  required String sessionKey,
  required String discipline,
  required String subcategory,
}) async {
  var localState = await readLocalTrainingSessionState(sessionKey);
  if (
    !matchesTrainingSessionState(
      localState,
      discipline: discipline,
      subcategory: subcategory,
    )
  ) {
    localState = null;
  }

  final remoteState = await readRemoteTrainingSessionState(
    discipline: discipline,
    subcategory: subcategory,
  );

  final chosen = chooseTrainingSessionState(
    localState: localState,
    remoteState: remoteState,
  );
  if (chosen == null) {
    return null;
  }

  if (
    isCompletedTrainingSessionState(
      chosen,
      discipline: discipline,
      subcategory: subcategory,
    )
  ) {
    return TrainingSessionRestoreOutcome(
      completedResult: completedResultFromTrainingSessionState(chosen),
    );
  }

  final restoredState = await hydrateTrainingSessionState(chosen);
  if (restoredState == null) {
    return null;
  }

  return TrainingSessionRestoreOutcome(restoredState: restoredState);
}
