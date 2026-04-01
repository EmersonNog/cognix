import 'core.dart';
import 'models.dart';
import 'parsers.dart';

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

  final parsed = _parseSubcategoryItems(payload);
  if (parsed.isNotEmpty) {
    return parsed;
  }

  final canonicalDiscipline = await _findCanonicalDisciplineName(discipline);
  if (canonicalDiscipline == null || canonicalDiscipline == discipline) {
    return parsed;
  }

  final fallbackPayload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/subcategories').replace(
      queryParameters: {'discipline': canonicalDiscipline},
    ),
    errorMessage: 'Erro ao carregar subcategorias',
  );
  return _parseSubcategoryItems(fallbackPayload);
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
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions').replace(
      queryParameters: {
        'subject': discipline,
        'subcategory': subcategory,
        'limit': '$limit',
        'offset': '$offset',
        'include_total': 'true',
      },
    ),
    errorMessage: 'Erro ao carregar questões',
  );

  return parseQuestionsPage(
    payload,
    fallbackLimit: limit,
    fallbackOffset: offset,
    fallbackDiscipline: discipline,
    fallbackSubcategory: subcategory,
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

List<SubcategoryItem> _parseSubcategoryItems(Map<String, dynamic> payload) {
  final items = payload['items'];
  if (items is! List) {
    return [];
  }

  return items
      .whereType<Map>()
      .map(parseSubcategoryItem)
      .where((item) => item.name.trim().isNotEmpty)
      .toList();
}

Future<String?> _findCanonicalDisciplineName(String discipline) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/questions/disciplines'),
    errorMessage: 'Erro ao carregar disciplinas',
  );

  final items = payload['items'];
  if (items is! List) {
    return null;
  }

  final expected = _normalizeDiscipline(discipline);
  for (final item in items) {
    final value = item?.toString().trim();
    if (value == null || value.isEmpty) {
      continue;
    }
    if (_normalizeDiscipline(value) == expected) {
      return value;
    }
  }
  return null;
}

String _normalizeDiscipline(String value) {
  const replacements = {
    'á': 'a',
    'à': 'a',
    'ã': 'a',
    'â': 'a',
    'ä': 'a',
    'Á': 'a',
    'À': 'a',
    'Ã': 'a',
    'Â': 'a',
    'Ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'É': 'e',
    'È': 'e',
    'Ê': 'e',
    'Ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'Í': 'i',
    'Ì': 'i',
    'Î': 'i',
    'Ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'õ': 'o',
    'ô': 'o',
    'ö': 'o',
    'Ó': 'o',
    'Ò': 'o',
    'Õ': 'o',
    'Ô': 'o',
    'Ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'Ú': 'u',
    'Ù': 'u',
    'Û': 'u',
    'Ü': 'u',
    'ç': 'c',
    'Ç': 'c',
  };

  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(replacements[char] ?? char.toLowerCase());
  }
  return buffer.toString().trim();
}
