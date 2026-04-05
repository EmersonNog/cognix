import '../../utils/api_datetime.dart';
import 'models/profile_avatar_models.dart';
import 'models/profile_score_models.dart';
import 'parser_helpers.dart';

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
    uniqueQuestionsAnswered: parseIntValue(payload['unique_questions_answered']),
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
    consistencyWindowDays:
        parseIntValue(payload['consistency_window_days'], fallback: 30),
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
  );
}

ProfileAvatarSelectionResult parseProfileAvatarSelectionResult(
  Map<String, dynamic> payload,
) {
  final status = parseTrimmedString(payload['status'], fallback: 'error');
  final action = parseTrimmedString(payload['action'], fallback: status);
  final coinsBalance = parseDoubleValue(payload['coins_balance']);
  final coinsHalfUnits = parseIntValue(
    payload['coins_half_units'],
    fallback: (coinsBalance * 2).round(),
  );
  final equippedAvatarSeed = parseTrimmedString(
    payload['equipped_avatar_seed'],
    fallback: 'avatar_1',
  );

  return ProfileAvatarSelectionResult(
    status: status,
    action: action,
    coinsBalance: coinsBalance,
    coinsHalfUnits: coinsHalfUnits,
    equippedAvatarSeed: equippedAvatarSeed,
    ownedAvatarSeeds: parseOwnedAvatarSeeds(payload['owned_avatar_seeds']),
    avatarStore: parseProfileAvatarStoreItems(payload['avatar_store']),
    requiredCoins: _parseOptionalDouble(payload['required_coins']),
    missingCoins: _parseOptionalDouble(payload['missing_coins']),
  );
}

List<String> parseOwnedAvatarSeeds(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();
}

List<ProfileAvatarStoreItem> parseProfileAvatarStoreItems(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) {
        return ProfileAvatarStoreItem(
          seed: parseTrimmedString(item['seed']),
          title: parseTrimmedString(item['title']),
          theme: parseTrimmedString(item['theme']),
          rarity: parseTrimmedString(item['rarity'], fallback: 'comum'),
          costCoins: parseDoubleValue(item['cost_coins']),
          costHalfUnits: parseIntValue(item['cost_half_units']),
          owned: item['owned'] == true,
          equipped: item['equipped'] == true,
          affordable: item['affordable'] == true,
          isDefault: item['is_default'] == true,
        );
      })
      .where((item) => item.seed.trim().isNotEmpty)
      .toList();
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

List<ProfileRecentActivityDay> parseProfileRecentActivityWindow(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  final items = <ProfileRecentActivityDay>[];
  for (final item in raw.whereType<Map>()) {
    final date = _parseCalendarDate(item['date']?.toString());
    if (date == null) {
      continue;
    }
    items.add(
      ProfileRecentActivityDay(
        date: date,
        active: item['active'] == true,
        isToday: item['is_today'] == true,
      ),
    );
  }

  return items;
}

List<ProfileRecentCompletedSession> parseProfileRecentCompletedSessionsPreview(
  dynamic raw,
) {
  if (raw is! List) {
    return const [];
  }

  return raw.whereType<Map>().map((item) {
    return ProfileRecentCompletedSession(
      discipline: parseTrimmedString(item['discipline']),
      subcategory: parseTrimmedString(item['subcategory']),
      answeredQuestions: parseIntValue(item['answered_questions']),
      totalQuestions: parseIntValue(item['total_questions']),
      correctAnswers: parseIntValue(item['correct_answers']),
      accuracyPercent: parseDoubleValue(item['accuracy_percent']),
      completedAt: parseApiDateTime(item['completed_at']?.toString()),
    );
  }).where((item) {
    return item.discipline.isNotEmpty && item.subcategory.isNotEmpty;
  }).toList();
}

double? _parseOptionalDouble(Object? rawValue) {
  final normalized = '$rawValue';
  return normalized == 'null' ? null : double.tryParse(normalized);
}

DateTime? _parseCalendarDate(String? rawValue) {
  final normalized = rawValue?.trim() ?? '';
  if (normalized.isEmpty) {
    return null;
  }

  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(normalized);
  if (match == null) {
    return null;
  }

  final year = int.tryParse(match.group(1) ?? '');
  final month = int.tryParse(match.group(2) ?? '');
  final day = int.tryParse(match.group(3) ?? '');
  if (year == null || month == null || day == null) {
    return null;
  }

  return DateTime(year, month, day);
}
