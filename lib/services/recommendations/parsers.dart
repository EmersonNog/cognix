import 'models.dart';

HomeRecommendationsData parseHomeRecommendationsData(
  Map<String, dynamic> payload,
) {
  return HomeRecommendationsData(
    title: payload['title']?.toString().trim().isNotEmpty == true
        ? payload['title'].toString().trim()
        : 'Recomendado para Hoje',
    subtitle: payload['subtitle']?.toString().trim().isNotEmpty == true
        ? payload['subtitle'].toString().trim()
        : 'Sem recomendações disponíveis por enquanto.',
    items: parseHomeRecommendationItems(payload['items']),
  );
}

List<HomeRecommendationItem> parseHomeRecommendationItems(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) {
        return HomeRecommendationItem(
          title: item['title']?.toString().trim() ?? '',
          discipline: item['discipline']?.toString().trim() ?? '',
          subcategory: item['subcategory']?.toString().trim() ?? '',
          description: item['description']?.toString().trim() ?? '',
          badgeLabel: item['badge_label']?.toString().trim() ?? 'Moderado',
          badgeTone: item['badge_tone']?.toString().trim() ?? 'moderate',
          countLabel: item['count_label']?.toString().trim() ?? '',
          reasonLabel: item['reason_label']?.toString().trim() ?? '',
          source: item['source']?.toString().trim() ?? '',
          accuracyPercent: double.tryParse('${item['accuracy_percent']}'),
          totalAttempts: int.tryParse('${item['total_attempts']}') ?? 0,
          totalQuestions: int.tryParse('${item['total_questions']}') ?? 0,
        );
      })
      .where((item) => item.title.isNotEmpty && item.discipline.isNotEmpty)
      .toList();
}
