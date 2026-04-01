class SubcategoryItem {
  const SubcategoryItem({required this.name, required this.total});

  final String name;
  final int total;
}

class QuestionItem {
  const QuestionItem({
    required this.id,
    required this.statement,
    required this.alternatives,
    required this.subcategory,
    required this.discipline,
    required this.year,
  });

  final int id;
  final String statement;
  final List<String> alternatives;
  final String subcategory;
  final String discipline;
  final int? year;
}

class QuestionsPage {
  const QuestionsPage({
    required this.items,
    required this.limit,
    required this.offset,
    required this.total,
  });

  final List<QuestionItem> items;
  final int limit;
  final int offset;
  final int? total;
}

class TrainingSessionState {
  const TrainingSessionState({required this.state, required this.updatedAt});

  final Map<String, dynamic> state;
  final DateTime? updatedAt;
}

class TrainingSessionOverviewItem {
  const TrainingSessionOverviewItem({
    required this.discipline,
    required this.subcategory,
    required this.completed,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.progress,
    required this.updatedAt,
  });

  final String discipline;
  final String subcategory;
  final bool completed;
  final int answeredQuestions;
  final int totalQuestions;
  final double progress;
  final DateTime? updatedAt;
}

class TrainingSessionsOverview {
  const TrainingSessionsOverview({
    required this.completedSessions,
    required this.inProgressSessions,
    required this.latestSession,
  });

  final int completedSessions;
  final int inProgressSessions;
  final TrainingSessionOverviewItem? latestSession;
}

class AttemptResult {
  const AttemptResult({
    required this.questionId,
    required this.selectedLetter,
    required this.isCorrect,
  });

  final int questionId;
  final String selectedLetter;
  final bool? isCorrect;
}
