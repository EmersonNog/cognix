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

class ProfileScoreData {
  const ProfileScoreData({
    required this.score,
    required this.exactScore,
    required this.level,
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
    required this.consistencyWindowDays,
    required this.lastActivityAt,
    required this.nextLevel,
    required this.pointsToNextLevel,
    required this.questionsByDiscipline,
    required this.strongestSubcategory,
    required this.weakestSubcategory,
    required this.attentionSubcategoriesCount,
    required this.attentionAccuracyThreshold,
  });

  const ProfileScoreData.empty()
    : score = 0,
      exactScore = 0.0,
      level = 'Iniciante',
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
      consistencyWindowDays = 30,
      lastActivityAt = null,
      nextLevel = 'Em Evolucao',
      pointsToNextLevel = 20,
      questionsByDiscipline = const [],
      strongestSubcategory = null,
      weakestSubcategory = null,
      attentionSubcategoriesCount = 0,
      attentionAccuracyThreshold = 60.0;

  final int score;
  final double exactScore;
  final String level;
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
  final int consistencyWindowDays;
  final DateTime? lastActivityAt;
  final String? nextLevel;
  final int pointsToNextLevel;
  final List<ProfileDisciplineStat> questionsByDiscipline;
  final ProfileSubcategoryInsight? strongestSubcategory;
  final ProfileSubcategoryInsight? weakestSubcategory;
  final int attentionSubcategoriesCount;
  final double attentionAccuracyThreshold;
}
