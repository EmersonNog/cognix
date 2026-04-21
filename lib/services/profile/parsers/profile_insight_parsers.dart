part of '../parsers.dart';

ProfilePerformanceInsight? parseProfilePerformanceInsight(dynamic raw) {
  if (raw is! Map) {
    return null;
  }

  final title = parseTrimmedString(raw['title']);
  final summary = parseTrimmedString(raw['summary']);
  final priority = parseTrimmedString(raw['priority']);
  final riskLevel = parseTrimmedString(raw['risk_level']);
  final nextAction = parseTrimmedString(raw['next_action']);
  final confidence = parseDoubleValue(raw['confidence']);
  final generatedAt = parseApiDateTime(raw['generated_at']?.toString());
  final ttlMinutes = parseIntValue(raw['ttl_minutes']);
  final usesTtl = parseBoolValue(raw['uses_ttl']);
  final cacheHit = parseBoolValue(raw['cache_hit']);

  if (title.isEmpty ||
      summary.isEmpty ||
      priority.isEmpty ||
      riskLevel.isEmpty ||
      nextAction.isEmpty) {
    return null;
  }

  return ProfilePerformanceInsight(
    title: title,
    summary: summary,
    priority: priority,
    riskLevel: riskLevel,
    nextAction: nextAction,
    confidence: confidence,
    generatedAt: generatedAt,
    ttlMinutes: ttlMinutes,
    usesTtl: usesTtl,
    cacheHit: cacheHit,
  );
}
