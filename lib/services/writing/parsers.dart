import 'models.dart';

WritingTheme parseWritingTheme(Map<String, dynamic> payload) {
  return WritingTheme(
    id: payload['id']?.toString() ?? '',
    title: payload['title']?.toString() ?? '',
    category: payload['category']?.toString() ?? '',
    description: payload['description']?.toString() ?? '',
    keywords: (payload['keywords'] is List)
        ? (payload['keywords'] as List).map((item) => item.toString()).toList()
        : const [],
    difficulty: payload['difficulty']?.toString() ?? 'médio',
    exam: payload['exam']?.toString() ?? 'ENEM',
  );
}

WritingThemesData parseWritingThemesData(Map<String, dynamic> payload) {
  final monthlyPayload = payload['monthly_theme'];
  return WritingThemesData(
    items: _parseList(payload['items'], parseWritingTheme),
    categories: (payload['categories'] is List)
        ? (payload['categories'] as List)
              .map((item) => item.toString())
              .toList()
        : const [],
    total: _parseInt(payload['total']),
    limit: _parseInt(payload['limit']),
    offset: _parseInt(payload['offset']),
    hasMore: payload['has_more'] == true,
    monthlyTheme: monthlyPayload is Map
        ? parseWritingTheme(Map<String, dynamic>.from(monthlyPayload))
        : null,
  );
}

WritingFeedback parseWritingFeedback(Map<String, dynamic> payload) {
  return WritingFeedback(
    estimatedScore: _parseInt(payload['estimated_score']).clamp(0, 1000),
    summary: payload['summary']?.toString() ?? '',
    checklist: _parseList(
      payload['checklist'],
      (item) => WritingChecklistItem(
        label: item['label']?.toString() ?? '',
        completed: item['completed'] == true,
        helper: item['helper']?.toString() ?? '',
      ),
    ),
    competencies: _parseList(
      payload['competencies'],
      (item) => WritingCompetencyFeedback(
        title: item['title']?.toString() ?? '',
        score: _parseInt(item['score']).clamp(0, 200),
        comment: item['comment']?.toString() ?? '',
      ),
    ),
    rewriteSuggestions: _parseList(
      payload['rewrite_suggestions'],
      (item) => WritingRewriteSuggestion(
        section: item['section']?.toString() ?? '',
        issue: item['issue']?.toString() ?? '',
        suggestion: item['suggestion']?.toString() ?? '',
        example: item['example']?.toString() ?? '',
      ),
    ),
  );
}

List<T> _parseList<T>(
  Object? value,
  T Function(Map<String, dynamic> item) mapper,
) {
  if (value is! List) {
    return const [];
  }
  return value
      .whereType<Map>()
      .map((item) => mapper(Map<String, dynamic>.from(item)))
      .toList();
}

int _parseInt(Object? value) {
  if (value is int) return value;
  return int.tryParse('$value') ?? 0;
}
