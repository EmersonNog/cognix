class WritingTheme {
  const WritingTheme({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.keywords,
    this.difficulty = 'médio',
    this.exam = 'ENEM',
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> keywords;
  final String difficulty;
  final String exam;
}

class WritingThemesData {
  const WritingThemesData({
    required this.items,
    required this.categories,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
    this.monthlyTheme,
  });

  const WritingThemesData.empty()
    : items = const [],
      categories = const [],
      total = 0,
      limit = 0,
      offset = 0,
      hasMore = false,
      monthlyTheme = null;

  final List<WritingTheme> items;
  final List<String> categories;
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;
  final WritingTheme? monthlyTheme;
}

class WritingDraft {
  const WritingDraft({
    required this.theme,
    required this.thesis,
    required this.repertoire,
    required this.argumentOne,
    required this.argumentTwo,
    required this.intervention,
    required this.finalText,
  });

  final WritingTheme theme;
  final String thesis;
  final String repertoire;
  final String argumentOne;
  final String argumentTwo;
  final String intervention;
  final String finalText;

  int get wordCount => finalText
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.trim().isNotEmpty)
      .length;

  int get paragraphCount => finalText
      .split(RegExp(r'\n\s*\n'))
      .where((paragraph) => paragraph.trim().isNotEmpty)
      .length;
}

class WritingChecklistItem {
  const WritingChecklistItem({
    required this.label,
    required this.completed,
    required this.helper,
  });

  final String label;
  final bool completed;
  final String helper;
}

class WritingCompetencyFeedback {
  const WritingCompetencyFeedback({
    required this.title,
    required this.score,
    required this.comment,
  });

  final String title;
  final int score;
  final String comment;
}

class WritingRewriteSuggestion {
  const WritingRewriteSuggestion({
    required this.section,
    required this.issue,
    required this.suggestion,
    required this.example,
  });

  final String section;
  final String issue;
  final String suggestion;
  final String example;
}

class WritingFeedback {
  const WritingFeedback({
    required this.estimatedScore,
    required this.summary,
    required this.competencies,
    required this.rewriteSuggestions,
    required this.checklist,
  });

  final int estimatedScore;
  final String summary;
  final List<WritingCompetencyFeedback> competencies;
  final List<WritingRewriteSuggestion> rewriteSuggestions;
  final List<WritingChecklistItem> checklist;
}
