part of '../parsers.dart';

WritingFeedback parseWritingFeedback(Map<String, dynamic> payload) {
  return WritingFeedback(
    estimatedScore: _parseInt(payload['estimated_score']).clamp(0, 1000),
    summary: payload['summary']?.toString() ?? '',
    submissionId: _parseNullableInt(payload['submission_id']),
    versionId: _parseNullableInt(payload['version_id']),
    versionNumber: _parseNullableInt(payload['version_number']),
    checklist: _parseChecklist(payload['checklist']),
    competencies: _parseCompetencies(payload['competencies']),
    rewriteSuggestions: _parseRewriteSuggestions(
      payload['rewrite_suggestions'],
    ),
  );
}

List<WritingChecklistItem> _parseChecklist(Object? value) {
  return _parseList(
    value,
    (item) => WritingChecklistItem(
      label: item['label']?.toString() ?? '',
      completed: item['completed'] == true,
      helper: item['helper']?.toString() ?? '',
    ),
  );
}

List<WritingCompetencyFeedback> _parseCompetencies(Object? value) {
  return _parseList(
    value,
    (item) => WritingCompetencyFeedback(
      title: item['title']?.toString() ?? '',
      score: _parseInt(item['score']).clamp(0, 200),
      comment: item['comment']?.toString() ?? '',
    ),
  );
}

List<WritingRewriteSuggestion> _parseRewriteSuggestions(Object? value) {
  return _parseList(
    value,
    (item) => WritingRewriteSuggestion(
      section: item['section']?.toString() ?? '',
      issue: item['issue']?.toString() ?? '',
      suggestion: item['suggestion']?.toString() ?? '',
      example: item['example']?.toString() ?? '',
    ),
  );
}
