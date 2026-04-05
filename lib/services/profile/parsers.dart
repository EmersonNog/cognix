import '../../utils/api_datetime.dart';
import 'models.dart';

ProfileScoreData parseProfileScoreData(Map<String, dynamic> payload) {
  final score = int.tryParse('${payload['score']}') ?? 0;
  final exactScore = double.tryParse('${payload['exact_score']}') ?? 0.0;
  final level = payload['level']?.toString().trim().isNotEmpty == true
      ? payload['level'].toString().trim()
      : 'Iniciante';
  final coinsBalance = double.tryParse('${payload['coins_balance']}') ?? 0.0;
  final coinsHalfUnits =
      int.tryParse('${payload['coins_half_units']}') ??
      (coinsBalance * 2).round();
  final equippedAvatarSeed =
      payload['equipped_avatar_seed']?.toString().trim().isNotEmpty == true
      ? payload['equipped_avatar_seed'].toString().trim()
      : 'avatar_1';
  final ownedAvatarSeeds = parseOwnedAvatarSeeds(payload['owned_avatar_seeds']);
  final avatarStore = parseProfileAvatarStoreItems(payload['avatar_store']);
  final questionsAnswered =
      int.tryParse('${payload['questions_answered']}') ?? 0;
  final completedSessions =
      int.tryParse('${payload['completed_sessions']}') ?? 0;
  final exactRecentIndex =
      double.tryParse('${payload['exact_recent_index']}') ?? 0.0;
  final recentIndex =
      int.tryParse('${payload['recent_index']}') ?? exactRecentIndex.round();
  final recentIndexReady = payload['recent_index_ready'] is bool
      ? payload['recent_index_ready'] as bool
      : questionsAnswered > 0 || completedSessions > 0;

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
    uniqueQuestionsAnswered:
        int.tryParse('${payload['unique_questions_answered']}') ?? 0,
    questionBankTotal: int.tryParse('${payload['question_bank_total']}') ?? 0,
    disciplinesCovered: int.tryParse('${payload['disciplines_covered']}') ?? 0,
    totalCorrect: int.tryParse('${payload['total_correct']}') ?? 0,
    accuracyPercent: double.tryParse('${payload['accuracy_percent']}') ?? 0.0,
    completedSessions: completedSessions,
    totalStudySeconds: int.tryParse('${payload['total_study_seconds']}') ?? 0,
    activeDaysLast30: int.tryParse('${payload['active_days_last_30']}') ?? 0,
    currentStreakDays: int.tryParse('${payload['current_streak_days']}') ?? 0,
    recentActivityWindow: parseProfileRecentActivityWindow(
      payload['recent_activity_window'],
    ),
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

ProfileAvatarSelectionResult parseProfileAvatarSelectionResult(
  Map<String, dynamic> payload,
) {
  final status = payload['status']?.toString().trim().isNotEmpty == true
      ? payload['status'].toString().trim()
      : 'error';
  final action = payload['action']?.toString().trim().isNotEmpty == true
      ? payload['action'].toString().trim()
      : status;
  final coinsBalance = double.tryParse('${payload['coins_balance']}') ?? 0.0;
  final coinsHalfUnits =
      int.tryParse('${payload['coins_half_units']}') ??
      (coinsBalance * 2).round();
  final equippedAvatarSeed =
      payload['equipped_avatar_seed']?.toString().trim().isNotEmpty == true
      ? payload['equipped_avatar_seed'].toString().trim()
      : 'avatar_1';

  return ProfileAvatarSelectionResult(
    status: status,
    action: action,
    coinsBalance: coinsBalance,
    coinsHalfUnits: coinsHalfUnits,
    equippedAvatarSeed: equippedAvatarSeed,
    ownedAvatarSeeds: parseOwnedAvatarSeeds(payload['owned_avatar_seeds']),
    avatarStore: parseProfileAvatarStoreItems(payload['avatar_store']),
    requiredCoins: double.tryParse('${payload['required_coins']}'),
    missingCoins: double.tryParse('${payload['missing_coins']}'),
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
          seed: item['seed']?.toString() ?? '',
          title: item['title']?.toString() ?? '',
          theme: item['theme']?.toString() ?? '',
          rarity: item['rarity']?.toString() ?? 'comum',
          costCoins: double.tryParse('${item['cost_coins']}') ?? 0.0,
          costHalfUnits: int.tryParse('${item['cost_half_units']}') ?? 0,
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
          discipline: item['discipline']?.toString() ?? '',
          count: int.tryParse('${item['count']}') ?? 0,
        );
      })
      .where((item) => item.discipline.trim().isNotEmpty)
      .toList();
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
