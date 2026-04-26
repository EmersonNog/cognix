part of '../parsers.dart';

WritingTheme parseWritingTheme(Map<String, dynamic> payload) {
  return WritingTheme(
    id: payload['id']?.toString() ?? '',
    title: payload['title']?.toString() ?? '',
    category: payload['category']?.toString() ?? '',
    description: payload['description']?.toString() ?? '',
    keywords: _parseStringList(payload['keywords']),
    difficulty: payload['difficulty']?.toString() ?? 'médio',
    exam: payload['exam']?.toString() ?? 'ENEM',
  );
}

WritingThemesData parseWritingThemesData(Map<String, dynamic> payload) {
  final monthlyPayload = payload['monthly_theme'];
  return WritingThemesData(
    items: _parseList(payload['items'], parseWritingTheme),
    categories: _parseStringList(payload['categories']),
    total: _parseInt(payload['total']),
    limit: _parseInt(payload['limit']),
    offset: _parseInt(payload['offset']),
    hasMore: payload['has_more'] == true,
    monthlyTheme: monthlyPayload is Map
        ? parseWritingTheme(Map<String, dynamic>.from(monthlyPayload))
        : null,
  );
}
