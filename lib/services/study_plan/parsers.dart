import '../../utils/api_datetime.dart';
import 'models.dart';

StudyPlanData parseStudyPlanData(Map<String, dynamic> payload) {
  return StudyPlanData(
    configured: payload['configured'] == true,
    studyDaysPerWeek: int.tryParse('${payload['study_days_per_week']}') ?? 5,
    minutesPerDay: int.tryParse('${payload['minutes_per_day']}') ?? 60,
    weeklyQuestionsGoal:
        int.tryParse('${payload['weekly_questions_goal']}') ?? 80,
    focusMode: payload['focus_mode']?.toString() ?? 'constancia',
    preferredPeriod: payload['preferred_period']?.toString() ?? 'flexivel',
    priorityDisciplines: _parseStringList(payload['priority_disciplines']),
    weekStart: parseApiDateTime(payload['week_start']?.toString()),
    weekEnd: parseApiDateTime(payload['week_end']?.toString()),
    activeDaysThisWeek: int.tryParse('${payload['active_days_this_week']}') ?? 0,
    completedMinutesThisWeek:
        int.tryParse('${payload['completed_minutes_this_week']}') ?? 0,
    answeredQuestionsThisWeek:
        int.tryParse('${payload['answered_questions_this_week']}') ?? 0,
    activeDaysGoal: int.tryParse('${payload['active_days_goal']}') ?? 5,
    activeDaysPercent: int.tryParse('${payload['active_days_percent']}') ?? 0,
    weeklyMinutesTarget:
        int.tryParse('${payload['weekly_minutes_target']}') ?? 300,
    minutesPercent: int.tryParse('${payload['minutes_percent']}') ?? 0,
    questionsPercent: int.tryParse('${payload['questions_percent']}') ?? 0,
    weeklyCompletionPercent:
        int.tryParse('${payload['weekly_completion_percent']}') ?? 0,
    updatedAt: parseApiDateTime(payload['updated_at']?.toString()),
  );
}

List<String> _parseStringList(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();
}
