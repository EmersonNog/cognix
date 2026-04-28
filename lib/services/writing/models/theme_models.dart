part of '../models.dart';

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

class WritingThemesAccessResult {
  const WritingThemesAccessResult({
    required this.data,
    required this.requiresSubscription,
  });

  const WritingThemesAccessResult.available(WritingThemesData data)
    : this(data: data, requiresSubscription: false);

  const WritingThemesAccessResult.locked(WritingThemesData data)
    : this(data: data, requiresSubscription: true);

  final WritingThemesData data;
  final bool requiresSubscription;
}
