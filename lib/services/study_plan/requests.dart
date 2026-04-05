import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;
import 'models.dart';
import 'parsers.dart';

Future<StudyPlanData> fetchStudyPlan() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/study-plan'),
    errorMessage: 'Erro ao carregar plano de estudos',
  );
  return parseStudyPlanData(payload);
}

Future<StudyPlanData> saveStudyPlan({
  required int studyDaysPerWeek,
  required int minutesPerDay,
  required int weeklyQuestionsGoal,
  required String focusMode,
  required String preferredPeriod,
  required List<String> priorityDisciplines,
}) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/study-plan'),
    body: {
      'study_days_per_week': studyDaysPerWeek,
      'minutes_per_day': minutesPerDay,
      'weekly_questions_goal': weeklyQuestionsGoal,
      'focus_mode': focusMode,
      'preferred_period': preferredPeriod,
      'priority_disciplines': priorityDisciplines,
    },
    errorMessage: 'Erro ao salvar plano de estudos',
  );
  return parseStudyPlanData(payload);
}
