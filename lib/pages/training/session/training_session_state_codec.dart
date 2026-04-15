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
    'alternatives': question.alternatives
        .map(
          (alternative) => {
            'letter': alternative.letter,
            'text': alternative.text,
            'fileUrl': alternative.fileUrl,
          },
        )
        .toList(),
    'subcategory': question.subcategory,
    'discipline': question.discipline,
    'year': question.year,
    'alternativesIntroduction': question.alternativesIntroduction,
    'answerKey': question.answerKey,
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
    alternatives: _deserializeAlternatives(row['alternatives']),
    subcategory: row['subcategory']?.toString() ?? fallbackSubcategory,
    discipline: row['discipline']?.toString() ?? fallbackDiscipline,
    year: int.tryParse('${row['year']}'),
    alternativesIntroduction:
        row['alternativesIntroduction']?.toString() ??
        row['introducao_alternativas']?.toString(),
    answerKey: _normalizeStoredAnswerKey(row['answerKey'] ?? row['gabarito']),
    tip: row['tip']?.toString() ?? row['dica']?.toString(),
  );
}

List<QuestionAlternative> _deserializeAlternatives(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  final parsed = <QuestionAlternative>[];
  for (var i = 0; i < raw.length; i++) {
    final item = raw[i];
    if (item is Map) {
      final rawLetter = item['letter']?.toString();
      final letter =
          rawLetter != null && rawLetter.trim().isNotEmpty
          ? rawLetter.trim().toUpperCase()
          : _letterFromIndex(i);
      final text = item['text']?.toString() ?? item['value']?.toString() ?? '';
      final fileUrl =
          item['fileUrl']?.toString() ??
          item['file_url']?.toString() ??
          item['arquivo']?.toString();
      if (text.trim().isEmpty && (fileUrl == null || fileUrl.trim().isEmpty)) {
        continue;
      }
      parsed.add(
        QuestionAlternative(
          letter: letter,
          text: text,
          fileUrl: fileUrl?.trim().isEmpty == true ? null : fileUrl?.trim(),
        ),
      );
      continue;
    }

    final text = item?.toString() ?? '';
    if (text.trim().isEmpty) continue;
    parsed.add(QuestionAlternative(letter: _letterFromIndex(i), text: text));
  }

  return parsed;
}

String _letterFromIndex(int index) {
  final normalizedIndex = index.clamp(0, 25);
  return String.fromCharCode(65 + normalizedIndex);
}

String? _normalizeStoredAnswerKey(dynamic raw) {
  final value = raw?.toString().trim();
  if (value == null || value.isEmpty) {
    return null;
  }

  final upper = value.toUpperCase();
  if (upper.length == 1 && RegExp(r'^[A-Z]$').hasMatch(upper)) {
    return upper;
  }

  final match = RegExp(
    r'(?:alternativa|opcao|option)?\s*([A-Z])(?:\b|[\)\.\:\-])',
    caseSensitive: false,
  ).firstMatch(value);
  return match?.group(1)?.toUpperCase();
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
