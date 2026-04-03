import '../../../services/questions/questions_api.dart';
import 'training_session_models.dart';

Map<String, dynamic> buildTrainingSessionPayload({
  required String discipline,
  required String subcategory,
  required int currentIndex,
  required List<QuestionItem> questions,
  required Map<int, int> selections,
  required Map<int, String> lastSubmittedByQuestionId,
  required Map<int, bool?> isCorrectByQuestionId,
  required Map<int, int> correctOptionIndexByQuestionId,
  required int elapsedSeconds,
  required bool paused,
  required int? totalAvailable,
  required int offset,
  required bool includeQuestions,
  required bool showingAnswerFeedback,
  required int? feedbackQuestionId,
  required int? correctOptionIndex,
  required bool? lastAnswerWasCorrect,
}) {
  return <String, dynamic>{
    'discipline': discipline,
    'subcategory': subcategory,
    'currentIndex': currentIndex,
    'questionIds': questions.map((q) => q.id).toList(),
    'selections': selections.map((k, v) => MapEntry('$k', v)),
    'lastSubmitted': lastSubmittedByQuestionId.map((k, v) => MapEntry('$k', v)),
    'isCorrect': isCorrectByQuestionId.map(
      (k, v) => MapEntry('$k', v ?? 'null'),
    ),
    'correctOptionIndexByQuestionId': correctOptionIndexByQuestionId.map(
      (k, v) => MapEntry('$k', v),
    ),
    'elapsedSeconds': elapsedSeconds,
    'paused': paused,
    'totalAvailable': totalAvailable,
    'offset': offset,
    'showingAnswerFeedback': showingAnswerFeedback,
    'feedbackQuestionId': feedbackQuestionId,
    'currentCorrectOptionIndex': correctOptionIndex,
    'lastAnswerWasCorrect': lastAnswerWasCorrect,
    'savedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    if (includeQuestions)
      'questions': questions.map(serializeQuestionItem).toList(),
  };
}

Map<String, dynamic> buildCompletedTrainingSessionPayload({
  required String discipline,
  required String subcategory,
  required TrainingCompletedSessionResult result,
}) {
  return <String, dynamic>{
    'discipline': discipline,
    'subcategory': subcategory,
    'completed': true,
    'savedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    'result': <String, dynamic>{
      'totalQuestions': result.totalQuestions,
      'answeredQuestions': result.answeredQuestions,
      'correctAnswers': result.correctAnswers,
      'wrongAnswers': result.wrongAnswers,
      'elapsedSeconds': result.elapsedSeconds,
    },
  };
}

Map<String, dynamic> serializeQuestionItem(QuestionItem question) {
  return {
    'id': question.id,
    'statement': question.statement,
    'alternatives': question.alternatives,
    'subcategory': question.subcategory,
    'discipline': question.discipline,
    'year': question.year,
    'tip': question.tip,
  };
}

QuestionItem deserializeQuestionItem(
  Map row, {
  required String fallbackSubcategory,
  required String fallbackDiscipline,
}) {
  return QuestionItem(
    id: int.tryParse('${row['id']}') ?? 0,
    statement: row['statement']?.toString() ?? '',
    alternatives:
        (row['alternatives'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    subcategory: row['subcategory']?.toString() ?? fallbackSubcategory,
    discipline: row['discipline']?.toString() ?? fallbackDiscipline,
    year: int.tryParse('${row['year']}'),
    tip: row['tip']?.toString() ?? row['dica']?.toString(),
  );
}

bool matchesTrainingSessionState(
  Map<String, dynamic>? state, {
  required String discipline,
  required String subcategory,
}) {
  if (state == null) return false;
  return state['discipline'] == discipline &&
      state['subcategory'] == subcategory;
}

bool isCompletedTrainingSessionState(
  Map<String, dynamic>? state, {
  required String discipline,
  required String subcategory,
}) {
  return state != null &&
      state['discipline'] == discipline &&
      state['subcategory'] == subcategory &&
      state['completed'] == true;
}

TrainingCompletedSessionResult? completedResultFromTrainingSessionState(
  Map<String, dynamic> state,
) {
  final result = state['result'];
  if (result is! Map) return null;

  final totalQuestions = int.tryParse('${result['totalQuestions']}');
  final answeredQuestions = int.tryParse('${result['answeredQuestions']}');
  final correctAnswers = int.tryParse('${result['correctAnswers']}');
  final wrongAnswers = int.tryParse('${result['wrongAnswers']}');
  final elapsedSeconds = int.tryParse('${result['elapsedSeconds']}');

  if (totalQuestions == null ||
      answeredQuestions == null ||
      correctAnswers == null ||
      wrongAnswers == null ||
      elapsedSeconds == null) {
    return null;
  }

  return TrainingCompletedSessionResult(
    totalQuestions: totalQuestions,
    answeredQuestions: answeredQuestions,
    correctAnswers: correctAnswers,
    wrongAnswers: wrongAnswers,
    elapsedSeconds: elapsedSeconds,
  );
}

int clampTrainingSessionIndex(dynamic rawIndex, int length) {
  final value = int.tryParse('$rawIndex') ?? 0;
  if (length <= 0) return 0;
  if (value < 0) return 0;
  if (value >= length) return length - 1;
  return value;
}

Map<String, dynamic> filterTrainingSessionMapByIds(
  dynamic raw,
  Set<int> allowedIds,
) {
  if (raw is! Map) return <String, dynamic>{};
  final result = <String, dynamic>{};
  raw.forEach((key, value) {
    final id = int.tryParse(key.toString());
    if (id != null && allowedIds.contains(id)) {
      result[key.toString()] = value;
    }
  });
  return result;
}

Map<int, int> parseTrainingSelections(dynamic raw) {
  if (raw is! Map) return <int, int>{};
  return raw.map((k, v) {
    final key = int.tryParse(k.toString()) ?? 0;
    final value = int.tryParse(v.toString()) ?? 0;
    return MapEntry(key, value);
  });
}

Map<int, String> parseTrainingLastSubmitted(dynamic raw) {
  if (raw is! Map) return <int, String>{};
  return raw.map((k, v) => MapEntry(int.parse(k), v.toString()));
}

Map<int, bool?> parseTrainingCorrectMap(dynamic raw) {
  if (raw is! Map) return <int, bool?>{};
  return raw.map((k, v) {
    final key = int.tryParse(k.toString()) ?? 0;
    if (v == 'null') return MapEntry(key, null);
    if (v is bool) return MapEntry(key, v);
    if (v is String) {
      if (v.toLowerCase() == 'true') return MapEntry(key, true);
      if (v.toLowerCase() == 'false') return MapEntry(key, false);
    }
    return MapEntry(key, null);
  });
}

Map<int, int> parseTrainingCorrectOptionIndexMap(dynamic raw) {
  if (raw is! Map) return <int, int>{};
  return raw.map((k, v) {
    final key = int.tryParse(k.toString()) ?? 0;
    final value = int.tryParse(v.toString()) ?? 0;
    return MapEntry(key, value);
  });
}

int? parseTrainingCurrentCorrectOptionIndex(Map<String, dynamic> decoded) {
  return int.tryParse(
    '${decoded['currentCorrectOptionIndex'] ?? decoded['correctOptionIndex']}',
  );
}

TrainingRestoredSessionData? parseTrainingRestoredSessionData(
  Map<String, dynamic> decoded, {
  required String fallbackSubcategory,
  required String fallbackDiscipline,
}) {
  final items = decoded['questions'];
  if (items is! List || items.isEmpty) {
    return null;
  }

  final questions = items.whereType<Map>().map((row) {
    return deserializeQuestionItem(
      row,
      fallbackSubcategory: fallbackSubcategory,
      fallbackDiscipline: fallbackDiscipline,
    );
  }).toList();

  return TrainingRestoredSessionData(
    questions: questions,
    currentIndex: int.tryParse('${decoded['currentIndex']}') ?? 0,
    totalAvailable: int.tryParse('${decoded['totalAvailable']}'),
    offset: int.tryParse('${decoded['offset']}') ?? questions.length,
    selections: parseTrainingSelections(decoded['selections']),
    lastSubmittedByQuestionId: parseTrainingLastSubmitted(
      decoded['lastSubmitted'],
    ),
    isCorrectByQuestionId: parseTrainingCorrectMap(decoded['isCorrect']),
    correctOptionIndexByQuestionId: parseTrainingCorrectOptionIndexMap(
      decoded['correctOptionIndexByQuestionId'] ??
          decoded['correctOptionIndex'],
    ),
    paused: decoded['paused'] == true,
    elapsedSeconds: int.tryParse('${decoded['elapsedSeconds']}') ?? 0,
    showingAnswerFeedback: decoded['showingAnswerFeedback'] == true,
    feedbackQuestionId: int.tryParse('${decoded['feedbackQuestionId']}'),
    correctOptionIndex: parseTrainingCurrentCorrectOptionIndex(decoded),
    lastAnswerWasCorrect: decoded['lastAnswerWasCorrect'] is bool
        ? decoded['lastAnswerWasCorrect'] as bool
        : null,
  );
}

Map<String, dynamic>? chooseTrainingSessionState({
  Map<String, dynamic>? localState,
  TrainingSessionState? remoteState,
}) {
  final localSavedAt = localState?['savedAt'];
  final localSavedAtMs = int.tryParse('${localSavedAt ?? ''}');
  final remoteSavedAtMs = remoteState?.updatedAt
      ?.toUtc()
      .millisecondsSinceEpoch;

  if (localState != null && remoteState != null) {
    if ((remoteSavedAtMs ?? 0) > (localSavedAtMs ?? 0)) {
      return remoteState.state;
    }
    return localState;
  }

  if (remoteState != null) {
    return remoteState.state;
  }

  return localState;
}
