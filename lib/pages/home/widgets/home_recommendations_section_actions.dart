part of 'home_recommendations_section.dart';

Future<void> _showAllRecommendationsSheet({
  required BuildContext context,
  required List<HomeRecommendationItem> items,
  required Color onSurface,
  required Color onSurfaceMuted,
  required Color primary,
  required Color surfaceContainerHigh,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF0B1328),
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Todas as recomendacoes',
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: Icon(Icons.close_rounded, color: onSurfaceMuted),
                  ),
                ],
              ),
              Text(
                'Escolha a frente que faz mais sentido para hoje.',
                style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.4),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _RecommendedCard(
                      item: item,
                      badgeColor: _badgeColorForTone(item.badgeTone),
                      icon: _iconForRecommendation(item.discipline),
                      primary: primary,
                      onSurface: onSurface,
                      onSurfaceMuted: onSurfaceMuted,
                      surfaceContainerHigh: surfaceContainerHigh,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _openRecommendation(
                          context,
                          item,
                          surfaceContainerHigh: surfaceContainerHigh,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                          primary: primary,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _openRecommendation(
  BuildContext context,
  HomeRecommendationItem item, {
  required Color surfaceContainerHigh,
  required Color onSurface,
  required Color onSurfaceMuted,
  required Color primary,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TrainingDetailScreen(
        title: item.subcategory,
        discipline: item.discipline,
        area: subjectsAreaFromTitle(item.discipline),
        description: item.description,
        badgeLabel: item.badgeLabel,
        badgeColor: _badgeColorForTone(item.badgeTone),
        countLabel: item.countLabel,
        areaTotalQuestions: null,
        surfaceContainerHigh: surfaceContainerHigh,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
      ),
    ),
  );
}

Color _badgeColorForTone(String tone) {
  if (tone == 'critical') {
    return const Color(0xFFFF6B78);
  }
  return const Color(0xFF7ED6C5);
}

IconData _iconForRecommendation(String discipline) {
  final text = discipline.toLowerCase();
  if (text.contains('matem')) return Icons.functions_rounded;
  if (text.contains('natureza')) return Icons.science_rounded;
  if (text.contains('humanas')) return Icons.public_rounded;
  if (text.contains('linguagens')) return Icons.menu_book_rounded;
  return Icons.auto_awesome_rounded;
}
