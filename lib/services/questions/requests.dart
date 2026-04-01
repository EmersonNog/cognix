import 'core.dart';
import 'models.dart';
import 'parsers.dart';
import 'request_helpers.dart';

Future<AttemptResult> submitAttempt({
  required int questionId,
  required String selectedLetter,
  required String discipline,
  required String subcategory,
}) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/attempts'),
    body: {
      'question_id': questionId,
      'selected_letter': selectedLetter,
      'discipline': discipline,
      'subcategory': subcategory,
    },
    errorMessage: 'Erro ao salvar tentativa',
  );

  return AttemptResult(
    questionId: int.tryParse('${payload['question_id']}') ?? questionId,
    selectedLetter: payload['selected_letter']?.toString() ?? selectedLetter,
    isCorrect:
        payload['is_correct'] is bool ? payload['is_correct'] as bool : null,
  );
}

Future<List<SubcategoryItem>> fetchSubcategories(String discipline) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/subcategories').replace(
      queryParameters: {'discipline': discipline},
    ),
    errorMessage: 'Erro ao carregar subcategorias',
  );

  final parsed = parseSubcategoryItems(
    payload,
    fallbackDiscipline: discipline,
  );
  if (parsed.isNotEmpty) {
    return parsed;
  }

  final canonicalDiscipline = await tryFindCanonicalDisciplineName(discipline);
  if (canonicalDiscipline == null || canonicalDiscipline == discipline) {
    return parsed;
  }

  final fallbackPayload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/subcategories').replace(
      queryParameters: {'discipline': canonicalDiscipline},
    ),
    errorMessage: 'Erro ao carregar subcategorias',
  );
  return parseSubcategoryItems(
    fallbackPayload,
    fallbackDiscipline: canonicalDiscipline,
  );
}

Future<List<QuestionItem>> fetchQuestionsBySubcategory({
  required String discipline,
  required String subcategory,
  int limit = 20,
  int offset = 0,
}) async {
  final page = await fetchQuestionsPageBySubcategory(
    discipline: discipline,
    subcategory: subcategory,
    limit: limit,
    offset: offset,
  );
  return page.items;
}

Future<List<QuestionItem>> fetchQuestionsByIds(List<int> ids) async {
  if (ids.isEmpty) return [];

  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/by_ids').replace(
      queryParameters: {'ids': ids.join(',')},
    ),
    errorMessage: 'Erro ao carregar questões',
  );

  final items = payload['items'];
  if (items is! List) {
    return [];
  }

  return items.whereType<Map>().map(parseQuestionItem).toList();
}

Future<QuestionsPage> fetchQuestionsPageBySubcategory({
  required String discipline,
  required String subcategory,
  int limit = 20,
  int offset = 0,
}) async {
  QuestionsPage? originalPage;
  Object? originalError;

  try {
    originalPage = await requestQuestionsPage(
      discipline: discipline,
      subcategory: subcategory,
      limit: limit,
      offset: offset,
    );
    if (originalPage.items.isNotEmpty || offset > 0) {
      return originalPage;
    }
  } catch (error) {
    originalError = error;
  }

  final canonicalDiscipline = await tryFindCanonicalDisciplineName(discipline);
  final effectiveDiscipline = canonicalDiscipline ?? discipline;
  final canonicalSubcategory = await tryFindCanonicalSubcategoryName(
    discipline: effectiveDiscipline,
    subcategory: subcategory,
  );
  final effectiveSubcategory = canonicalSubcategory ?? subcategory;

  if (effectiveDiscipline != discipline || effectiveSubcategory != subcategory) {
    try {
      final canonicalPage = await requestQuestionsPage(
        discipline: effectiveDiscipline,
        subcategory: effectiveSubcategory,
        limit: limit,
        offset: offset,
      );
      if (canonicalPage.items.isNotEmpty || offset > 0) {
        return canonicalPage;
      }
      originalPage ??= canonicalPage;
    } catch (error) {
      originalError ??= error;
    }
  }

  if (offset == 0) {
    try {
      final subcategoryOnlyPage = await requestQuestionsPage(
        discipline: null,
        subcategory: effectiveSubcategory,
        limit: limit,
        offset: offset,
      );
      if (subcategoryOnlyPage.items.isNotEmpty) {
        return subcategoryOnlyPage;
      }
      originalPage ??= subcategoryOnlyPage;
    } catch (error) {
      originalError ??= error;
    }
  }

  if (originalPage != null) {
    return originalPage;
  }
  if (originalError != null) {
    throw originalError;
  }

  return QuestionsPage(
    items: const [],
    limit: limit,
    offset: offset,
    total: 0,
  );
}

Future<void> saveTrainingSession({
  required String discipline,
  required String subcategory,
  required Map<String, dynamic> state,
}) async {
  await postJson(
    Uri.parse('${apiBaseUrl()}/sessions'),
    body: {
      'discipline': discipline,
      'subcategory': subcategory,
      'state': state,
    },
    errorMessage: 'Erro ao salvar sessão',
  );
}

Future<TrainingSessionState?> fetchTrainingSession({
  required String discipline,
  required String subcategory,
}) async {
  final payload = await getJsonOrNullOn404(
    Uri.parse('${apiBaseUrl()}/sessions').replace(
      queryParameters: {
        'discipline': discipline,
        'subcategory': subcategory,
      },
    ),
    errorMessage: 'Erro ao carregar sessão',
  );

  if (payload == null) {
    return null;
  }
  return parseTrainingSessionState(payload);
}

Future<void> clearTrainingSession({
  required String discipline,
  required String subcategory,
}) async {
  await deleteJson(
    Uri.parse('${apiBaseUrl()}/sessions').replace(
      queryParameters: {
        'discipline': discipline,
        'subcategory': subcategory,
      },
    ),
    errorMessage: 'Erro ao limpar sessão',
  );
}

Future<TrainingSessionsOverview> fetchTrainingSessionsOverview() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/sessions/overview'),
    errorMessage: 'Erro ao carregar overview de sessões',
  );
  return parseTrainingSessionsOverview(payload);
}
