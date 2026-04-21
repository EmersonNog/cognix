import 'profile_avatar_models.dart';

class ProfileDisciplineStat {
  const ProfileDisciplineStat({required this.discipline, required this.count});

  final String discipline;
  final int count;
}

class ProfileSubcategoryInsight {
  const ProfileSubcategoryInsight({
    required this.discipline,
    required this.subcategory,
    required this.accuracyPercent,
    required this.totalAttempts,
    required this.totalCorrect,
  });

  final String discipline;
  final String subcategory;
  final double accuracyPercent;
  final int totalAttempts;
  final int totalCorrect;
}

class ProfileRecentActivityDay {
  const ProfileRecentActivityDay({
    required this.date,
    required this.active,
    required this.isToday,
  });

  final DateTime date;
  final bool active;
  final bool isToday;
}

class ProfileRecentCompletedSession {
  const ProfileRecentCompletedSession({
    required this.discipline,
    required this.subcategory,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracyPercent,
    required this.completedAt,
  });

  final String discipline;
  final String subcategory;
  final int answeredQuestions;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracyPercent;
  final DateTime? completedAt;
}

class ProfilePerformanceInsight {
  const ProfilePerformanceInsight({
    required this.title,
    required this.summary,
    required this.priority,
    required this.riskLevel,
    required this.nextAction,
    required this.confidence,
    required this.generatedAt,
    required this.ttlMinutes,
    required this.usesTtl,
    required this.cacheHit,
  });

  final String title;
  final String summary;
  final String priority;
  final String riskLevel;
  final String nextAction;
  final double confidence;
  final DateTime? generatedAt;
  final int ttlMinutes;
  final bool usesTtl;
  final bool cacheHit;
}

class ProfileScoreData {
  const ProfileScoreData({
    required this.score,
    required this.exactScore,
    required this.level,
    required this.coinsBalance,
    required this.coinsHalfUnits,
    required this.equippedAvatarSeed,
    required this.ownedAvatarSeeds,
    required this.avatarStore,
    required this.recentIndex,
    required this.exactRecentIndex,
    required this.recentIndexReady,
    required this.questionsAnswered,
    required this.uniqueQuestionsAnswered,
    required this.questionBankTotal,
    required this.disciplinesCovered,
    required this.totalCorrect,
    required this.accuracyPercent,
    required this.completedSessions,
    required this.totalStudySeconds,
    required this.activeDaysLast30,
    required this.currentStreakDays,
    required this.recentActivityWindow,
    required this.recentCompletedSessionsPreview,
    required this.consistencyWindowDays,
    required this.lastActivityAt,
    required this.nextLevel,
    required this.pointsToNextLevel,
    required this.questionsByDiscipline,
    required this.strongestSubcategory,
    required this.weakestSubcategory,
    required this.attentionSubcategoriesCount,
    required this.attentionAccuracyThreshold,
    required this.aiInsight,
  });

  const ProfileScoreData.empty()
    : score = 0,
      exactScore = 0.0,
      level = 'Iniciante',
      coinsBalance = 0.0,
      coinsHalfUnits = 0,
      equippedAvatarSeed = 'avatar_1',
      ownedAvatarSeeds = const ['avatar_1'],
      avatarStore = const [],
      recentIndex = 0,
      exactRecentIndex = 0.0,
      recentIndexReady = false,
      questionsAnswered = 0,
      uniqueQuestionsAnswered = 0,
      questionBankTotal = 0,
      disciplinesCovered = 0,
      totalCorrect = 0,
      accuracyPercent = 0.0,
      completedSessions = 0,
      totalStudySeconds = 0,
      activeDaysLast30 = 0,
      currentStreakDays = 0,
      recentActivityWindow = const [],
      recentCompletedSessionsPreview = const [],
      consistencyWindowDays = 30,
      lastActivityAt = null,
      nextLevel = 'Em Evolucao',
      pointsToNextLevel = 20,
      questionsByDiscipline = const [],
      strongestSubcategory = null,
      weakestSubcategory = null,
      attentionSubcategoriesCount = 0,
      attentionAccuracyThreshold = 60.0,
      aiInsight = null;

  final int score;
  final double exactScore;
  final String level;
  final double coinsBalance;
  final int coinsHalfUnits;
  final String equippedAvatarSeed;
  final List<String> ownedAvatarSeeds;
  final List<ProfileAvatarStoreItem> avatarStore;
  final int recentIndex;
  final double exactRecentIndex;
  final bool recentIndexReady;
  final int questionsAnswered;
  final int uniqueQuestionsAnswered;
  final int questionBankTotal;
  final int disciplinesCovered;
  final int totalCorrect;
  final double accuracyPercent;
  final int completedSessions;
  final int totalStudySeconds;
  final int activeDaysLast30;
  final int currentStreakDays;
  final List<ProfileRecentActivityDay> recentActivityWindow;
  final List<ProfileRecentCompletedSession> recentCompletedSessionsPreview;
  final int consistencyWindowDays;
  final DateTime? lastActivityAt;
  final String? nextLevel;
  final int pointsToNextLevel;
  final List<ProfileDisciplineStat> questionsByDiscipline;
  final ProfileSubcategoryInsight? strongestSubcategory;
  final ProfileSubcategoryInsight? weakestSubcategory;
  final int attentionSubcategoriesCount;
  final double attentionAccuracyThreshold;
  final ProfilePerformanceInsight? aiInsight;
}
