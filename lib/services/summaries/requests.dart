import '../questions/questions_api.dart'
    show TrainingSessionState, fetchTrainingSession;
import '../core/api_client.dart' show apiBaseUrl, getJson;
import 'models.dart';
import 'parsers.dart';

Future<SummaryData> fetchSummary({
  required String discipline,
  required String subcategory,
}) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/summaries').replace(
      queryParameters: {
        'discipline': discipline,
        'subcategory': subcategory,
      },
    ),
    errorMessage: 'Erro ao carregar resumo',
  );

  return parseSummaryData(
    payload,
    fallbackDiscipline: discipline,
    fallbackSubcategory: subcategory,
  );
}

Future<SummaryData> fetchPersonalSummary({
  required String discipline,
  required String subcategory,
}) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/summaries/personal').replace(
      queryParameters: {
        'discipline': discipline,
        'subcategory': subcategory,
        'auto_generate': 'true',
      },
    ),
    errorMessage: 'Erro ao carregar resumo',
  );

  return parseSummaryData(
    payload,
    fallbackDiscipline: discipline,
    fallbackSubcategory: subcategory,
  );
}

Future<TrainingProgressData> fetchTrainingProgress({
  required String discipline,
  required String subcategory,
}) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/summaries/progress').replace(
      queryParameters: {
        'discipline': discipline,
        'subcategory': subcategory,
      },
    ),
    errorMessage: 'Erro ao carregar progresso',
  );

  TrainingSessionState? sessionState;
  try {
    sessionState = await fetchTrainingSession(
      discipline: discipline,
      subcategory: subcategory,
    );
  } catch (_) {}

  return parseTrainingProgressData(payload, sessionState: sessionState);
}
