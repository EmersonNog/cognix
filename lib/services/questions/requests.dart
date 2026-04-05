import 'core.dart';
import 'models.dart';
import 'parsers.dart';
import 'request_helpers.dart';

Future<List<String>> fetchDisciplines() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/disciplines'),
    errorMessage: 'Erro ao carregar disciplinas',
  );

  final items = payload['items'];
  if (items is! List) {
    return const [];
  }

  return items
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();
}

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
    isCorrect: payload['is_correct'] is bool
        ? payload['is_correct'] as bool
        : null,
    correctLetter: payload['correct_letter']?.toString(),
  );
}

Future<List<SubcategoryItem>> fetchSubcategories(String discipline) async {
  return loadSubcategoriesWithFallback(discipline);
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
    Uri.parse(
      '${apiBaseUrl()}/questions/by_ids',
    ).replace(queryParameters: {'ids': ids.join(',')}),
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
  return loadQuestionsPageWithFallback(
    discipline: discipline,
    subcategory: subcategory,
    limit: limit,
    offset: offset,
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
      queryParameters: {'discipline': discipline, 'subcategory': subcategory},
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
      queryParameters: {'discipline': discipline, 'subcategory': subcategory},
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
