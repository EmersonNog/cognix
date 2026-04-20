part of '../parsers.dart';

WritingSubmissionsData parseWritingSubmissionsData(
  Map<String, dynamic> payload,
) {
  return WritingSubmissionsData(
    items: _parseList(payload['items'], parseWritingSubmissionSummary),
    total: _parseInt(payload['total']),
    limit: _parseInt(payload['limit']),
    offset: _parseInt(payload['offset']),
    hasMore: payload['has_more'] == true,
  );
}

WritingSubmissionSummary parseWritingSubmissionSummary(
  Map<String, dynamic> payload,
) {
  final themePayload = Map<String, dynamic>.from(
    payload['theme'] as Map? ?? {},
  );
  return WritingSubmissionSummary(
    id: _parseInt(payload['id']),
    theme: parseWritingTheme(themePayload),
    status: payload['status']?.toString() ?? 'active',
    currentVersion: _parseInt(payload['current_version']),
    latestScore: _parseNullableInt(payload['latest_score']),
    latestSummary: payload['latest_summary']?.toString() ?? '',
    lastAnalyzedAt: parseApiDateTime(payload['last_analyzed_at']?.toString()),
    createdAt: parseApiDateTime(payload['created_at']?.toString()),
    updatedAt: parseApiDateTime(payload['updated_at']?.toString()),
  );
}

WritingSubmissionDetail parseWritingSubmissionDetail(
  Map<String, dynamic> payload,
) {
  final summary = parseWritingSubmissionSummary(payload);
  final versions = _parseList(
    payload['versions'],
    parseWritingSubmissionVersion,
  );
  final versionsTotal = payload.containsKey('versions_total')
      ? _parseInt(payload['versions_total'])
      : versions.length;
  return WritingSubmissionDetail(
    id: summary.id,
    theme: summary.theme,
    status: summary.status,
    currentVersion: summary.currentVersion,
    latestScore: summary.latestScore,
    latestSummary: summary.latestSummary,
    lastAnalyzedAt: summary.lastAnalyzedAt,
    createdAt: summary.createdAt,
    updatedAt: summary.updatedAt,
    versions: versions,
    versionsTotal: versionsTotal,
    versionsLimit: _parseInt(payload['versions_limit']),
    versionsOffset: _parseInt(payload['versions_offset']),
    versionsHasMore:
        payload['versions_has_more'] == true || versions.length < versionsTotal,
  );
}

WritingSubmissionVersion parseWritingSubmissionVersion(
  Map<String, dynamic> payload,
) {
  return WritingSubmissionVersion(
    id: _parseInt(payload['id']),
    versionNumber: _parseInt(payload['version_number']),
    thesis: payload['thesis']?.toString() ?? '',
    repertoire: payload['repertoire']?.toString() ?? '',
    argumentOne: payload['argument_one']?.toString() ?? '',
    argumentTwo: payload['argument_two']?.toString() ?? '',
    intervention: payload['intervention']?.toString() ?? '',
    finalText: payload['final_text']?.toString() ?? '',
    estimatedScore: _parseInt(payload['estimated_score']).clamp(0, 1000),
    summary: payload['summary']?.toString() ?? '',
    checklist: _parseChecklist(payload['checklist']),
    competencies: _parseCompetencies(payload['competencies']),
    rewriteSuggestions: _parseRewriteSuggestions(
      payload['rewrite_suggestions'],
    ),
    analyzedAt: parseApiDateTime(payload['analyzed_at']?.toString()),
    createdAt: parseApiDateTime(payload['created_at']?.toString()),
  );
}
