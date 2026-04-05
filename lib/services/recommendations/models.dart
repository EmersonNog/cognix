class HomeRecommendationItem {
  const HomeRecommendationItem({
    required this.title,
    required this.discipline,
    required this.subcategory,
    required this.description,
    required this.badgeLabel,
    required this.badgeTone,
    required this.countLabel,
    required this.reasonLabel,
    required this.source,
    required this.accuracyPercent,
    required this.totalAttempts,
    required this.totalQuestions,
  });

  final String title;
  final String discipline;
  final String subcategory;
  final String description;
  final String badgeLabel;
  final String badgeTone;
  final String countLabel;
  final String reasonLabel;
  final String source;
  final double? accuracyPercent;
  final int totalAttempts;
  final int totalQuestions;
}

class HomeRecommendationsData {
  const HomeRecommendationsData({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  const HomeRecommendationsData.empty()
    : title = 'Recomendado para Hoje',
      subtitle = 'Sem recomendacoes disponiveis por enquanto.',
      items = const [];

  final String title;
  final String subtitle;
  final List<HomeRecommendationItem> items;
}
