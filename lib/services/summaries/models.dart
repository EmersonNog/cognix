class SummaryNode {
  const SummaryNode({required this.title, required this.items});

  final String title;
  final List<String> items;
}

class SummaryData {
  const SummaryData({
    required this.title,
    required this.discipline,
    required this.subcategory,
    required this.nodes,
    required this.stats,
    required this.lockedUntilComplete,
    required this.lockedMessage,
  });

  final String title;
  final String discipline;
  final String subcategory;
  final List<SummaryNode> nodes;
  final SummaryStats stats;
  final bool lockedUntilComplete;
  final String? lockedMessage;
}

class SummaryStats {
  const SummaryStats({
    required this.totalAttempts,
    required this.totalCorrect,
    required this.accuracyPercent,
    required this.lastAttemptAt,
  });

  final int totalAttempts;
  final int totalCorrect;
  final double accuracyPercent;
  final DateTime? lastAttemptAt;
}

class TrainingProgressData {
  const TrainingProgressData({
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.progress,
    required this.hasCompletedSession,
  });

  final int answeredQuestions;
  final int totalQuestions;
  final double progress;
  final bool hasCompletedSession;
}
