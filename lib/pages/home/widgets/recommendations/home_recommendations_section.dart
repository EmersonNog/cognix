import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/recommendations/home_recommendations_api.dart';
import '../../../../theme/cognix_theme_colors.dart';
import '../../../subjects/subjects_data.dart';
import '../../../training/detail/training_detail_screen.dart';
part 'home_recommendations_section_actions.dart';
part 'home_recommendations_section_cards.dart';

class HomeRecommendationsSection extends StatelessWidget {
  const HomeRecommendationsSection({
    super.key,
    required this.recommendationsFuture,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.success,
    required this.danger,
    required this.surfaceContainerHigh,
  });

  final Future<HomeRecommendationsData> recommendationsFuture;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color success;
  final Color danger;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeRecommendationsData>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        final data = snapshot.data ?? const HomeRecommendationsData.empty();
        final visibleItems = data.items.take(2).toList();
        final canOpenAll = data.items.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.title,
                    style: GoogleFonts.manrope(
                      color: onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: canOpenAll
                      ? () => _showAllRecommendationsSheet(
                          context: context,
                          items: data.items,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                          primary: primary,
                          success: success,
                          danger: danger,
                          surfaceContainerHigh: surfaceContainerHigh,
                        )
                      : null,
                  child: Text(
                    'Ver Tudo',
                    style: GoogleFonts.plusJakartaSans(
                      color: canOpenAll ? primary : onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              data.subtitle,
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            if (snapshot.connectionState == ConnectionState.waiting)
              _RecommendationsPlaceholder(
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
                primary: primary,
              )
            else if (snapshot.hasError)
              _RecommendationsMessageCard(
                title: 'Não foi possível carregar as recomendações agora.',
                subtitle: 'Atualize a tela para tentar novamente.',
                icon: Icons.auto_awesome_rounded,
                iconColor: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              )
            else if (visibleItems.isEmpty)
              _RecommendationsMessageCard(
                title:
                    'As recomendações vão aparecer conforme seu ritmo evoluir.',
                subtitle:
                    'Defina prioridades no plano ou avance em algumas disciplinas.',
                icon: Icons.explore_rounded,
                iconColor: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              )
            else
              ...visibleItems.map((item) {
                final badgeColor = _badgeColorForTone(
                  item.badgeTone,
                  success: success,
                  danger: danger,
                );
                final icon = _iconForRecommendation(item.discipline);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecommendedCard(
                    item: item,
                    badgeColor: badgeColor,
                    icon: icon,
                    primary: primary,
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                    surfaceContainerHigh: surfaceContainerHigh,
                    onTap: () => _openRecommendation(
                      context,
                      item,
                      surfaceContainerHigh: surfaceContainerHigh,
                      onSurface: onSurface,
                      onSurfaceMuted: onSurfaceMuted,
                      primary: primary,
                      success: success,
                      danger: danger,
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
