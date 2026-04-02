import '../../utils/api_datetime.dart';
import 'models.dart';

ProfileScoreData parseProfileScoreData(Map<String, dynamic> payload) {
  return ProfileScoreData(
    score: int.tryParse('${payload['score']}') ?? 0,
    exactScore: double.tryParse('${payload['exact_score']}') ?? 0.0,
    level: payload['level']?.toString().trim().isNotEmpty == true
        ? payload['level'].toString().trim()
        : 'Iniciante',
    questionsAnswered: int.tryParse('${payload['questions_answered']}') ?? 0,
    totalCorrect: int.tryParse('${payload['total_correct']}') ?? 0,
    accuracyPercent: double.tryParse('${payload['accuracy_percent']}') ?? 0.0,
    completedSessions: int.tryParse('${payload['completed_sessions']}') ?? 0,
    totalStudySeconds: int.tryParse('${payload['total_study_seconds']}') ?? 0,
    activeDaysLast30: int.tryParse('${payload['active_days_last_30']}') ?? 0,
    consistencyWindowDays:
        int.tryParse('${payload['consistency_window_days']}') ?? 30,
    lastActivityAt: parseApiDateTime(payload['last_activity_at']?.toString()),
    nextLevel: payload['next_level']?.toString(),
    pointsToNextLevel: int.tryParse('${payload['points_to_next_level']}') ?? 0,
    questionsByDiscipline: parseProfileDisciplineStats(
      payload['questions_by_discipline'],
    ),
    strongestSubcategory: parseProfileSubcategoryInsight(
      payload['strongest_subcategory'],
    ),
    weakestSubcategory: parseProfileSubcategoryInsight(
      payload['weakest_subcategory'],
    ),
    attentionSubcategoriesCount:
        int.tryParse('${payload['attention_subcategories_count']}') ?? 0,
    attentionAccuracyThreshold:
        double.tryParse('${payload['attention_accuracy_threshold']}') ?? 60.0,
  );
}

List<ProfileDisciplineStat> parseProfileDisciplineStats(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw.whereType<Map>().map((item) {
    return ProfileDisciplineStat(
      discipline: item['discipline']?.toString() ?? '',
      count: int.tryParse('${item['count']}') ?? 0,
    );
  }).where((item) => item.discipline.trim().isNotEmpty).toList();
}

ProfileSubcategoryInsight? parseProfileSubcategoryInsight(dynamic raw) {
  if (raw is! Map) {
    return null;
  }

  final discipline = raw['discipline']?.toString().trim() ?? '';
  final subcategory = raw['subcategory']?.toString().trim() ?? '';

  if (discipline.isEmpty || subcategory.isEmpty) {
    return null;
  }

  return ProfileSubcategoryInsight(
    discipline: discipline,
    subcategory: subcategory,
    accuracyPercent: double.tryParse('${raw['accuracy_percent']}') ?? 0.0,
    totalAttempts: int.tryParse('${raw['total_attempts']}') ?? 0,
    totalCorrect: int.tryParse('${raw['total_correct']}') ?? 0,
  );
}
