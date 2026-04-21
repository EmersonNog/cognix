part of '../parsers.dart';

ProfileScoreData parseProfileScoreData(Map<String, dynamic> payload) {
  final score = parseIntValue(payload['score']);
  final exactScore = parseDoubleValue(payload['exact_score']);
  final level = parseTrimmedString(payload['level'], fallback: 'Iniciante');
  final coinsBalance = parseDoubleValue(payload['coins_balance']);
  final coinsHalfUnits = parseIntValue(
    payload['coins_half_units'],
    fallback: (coinsBalance * 2).round(),
  );
  final equippedAvatarSeed = parseTrimmedString(
    payload['equipped_avatar_seed'],
    fallback: 'avatar_1',
  );
  final ownedAvatarSeeds = parseOwnedAvatarSeeds(payload['owned_avatar_seeds']);
  final avatarStore = parseProfileAvatarStoreItems(payload['avatar_store']);
  final questionsAnswered = parseIntValue(payload['questions_answered']);
  final completedSessions = parseIntValue(payload['completed_sessions']);
  final exactRecentIndex = parseDoubleValue(payload['exact_recent_index']);
  final recentIndex = parseIntValue(
    payload['recent_index'],
    fallback: exactRecentIndex.round(),
  );
  final recentIndexReady = parseBoolValue(
    payload['recent_index_ready'],
    fallback: questionsAnswered > 0 || completedSessions > 0,
  );

  return ProfileScoreData(
    score: score,
    exactScore: exactScore,
    level: level,
    coinsBalance: coinsBalance,
    coinsHalfUnits: coinsHalfUnits,
    equippedAvatarSeed: equippedAvatarSeed,
    ownedAvatarSeeds: ownedAvatarSeeds.isEmpty
        ? const ['avatar_1']
        : ownedAvatarSeeds,
    avatarStore: avatarStore,
    recentIndex: recentIndex,
    exactRecentIndex: exactRecentIndex,
    recentIndexReady: recentIndexReady,
    questionsAnswered: questionsAnswered,
    uniqueQuestionsAnswered: parseIntValue(
      payload['unique_questions_answered'],
    ),
    questionBankTotal: parseIntValue(payload['question_bank_total']),
    disciplinesCovered: parseIntValue(payload['disciplines_covered']),
    totalCorrect: parseIntValue(payload['total_correct']),
    accuracyPercent: parseDoubleValue(payload['accuracy_percent']),
    completedSessions: completedSessions,
    totalStudySeconds: parseIntValue(payload['total_study_seconds']),
    activeDaysLast30: parseIntValue(payload['active_days_last_30']),
    currentStreakDays: parseIntValue(payload['current_streak_days']),
    recentActivityWindow: parseProfileRecentActivityWindow(
      payload['recent_activity_window'],
    ),
    recentCompletedSessionsPreview: parseProfileRecentCompletedSessionsPreview(
      payload['recent_completed_sessions_preview'],
    ),
    consistencyWindowDays: parseIntValue(
      payload['consistency_window_days'],
      fallback: 30,
    ),
    lastActivityAt: parseApiDateTime(payload['last_activity_at']?.toString()),
    nextLevel: parseOptionalTrimmedString(payload['next_level']),
    pointsToNextLevel: parseIntValue(payload['points_to_next_level']),
    questionsByDiscipline: parseProfileDisciplineStats(
      payload['questions_by_discipline'],
    ),
    strongestSubcategory: parseProfileSubcategoryInsight(
      payload['strongest_subcategory'],
    ),
    weakestSubcategory: parseProfileSubcategoryInsight(
      payload['weakest_subcategory'],
    ),
    attentionSubcategoriesCount: parseIntValue(
      payload['attention_subcategories_count'],
    ),
    attentionAccuracyThreshold: parseDoubleValue(
      payload['attention_accuracy_threshold'],
      fallback: 60.0,
    ),
    aiInsight: parseProfilePerformanceInsight(payload['ai_insight']),
  );
}

List<ProfileDisciplineStat> parseProfileDisciplineStats(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) {
        return ProfileDisciplineStat(
          discipline: parseTrimmedString(item['discipline']),
          count: parseIntValue(item['count']),
        );
      })
      .where((item) => item.discipline.trim().isNotEmpty)
      .toList();
}

ProfileSubcategoryInsight? parseProfileSubcategoryInsight(dynamic raw) {
  if (raw is! Map) {
    return null;
  }

  final discipline = parseTrimmedString(raw['discipline']);
  final subcategory = parseTrimmedString(raw['subcategory']);

  if (discipline.isEmpty || subcategory.isEmpty) {
    return null;
  }

  return ProfileSubcategoryInsight(
    discipline: discipline,
    subcategory: subcategory,
    accuracyPercent: parseDoubleValue(raw['accuracy_percent']),
    totalAttempts: parseIntValue(raw['total_attempts']),
    totalCorrect: parseIntValue(raw['total_correct']),
  );
}
