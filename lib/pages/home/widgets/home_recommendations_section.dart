import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/home_recommendations/home_recommendations_api.dart';
import '../../subjects/subjects_data.dart';
import '../../training/training_detail_screen.dart';

class HomeRecommendationsSection extends StatelessWidget {
  const HomeRecommendationsSection({
    super.key,
    required this.recommendationsFuture,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.surfaceContainerHigh,
  });

  final Future<HomeRecommendationsData> recommendationsFuture;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
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
                      ? () => _showAllRecommendations(context, data.items)
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
                title: 'Nao foi possivel carregar as recomendacoes agora.',
                subtitle: 'Atualize a Home para tentar novamente.',
                icon: Icons.auto_awesome_rounded,
                iconColor: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              )
            else if (visibleItems.isEmpty)
              _RecommendationsMessageCard(
                title:
                    'As recomendacoes vao aparecer conforme seu ritmo evoluir.',
                subtitle:
                    'Defina prioridades no plano ou avance em algumas subcategorias.',
                icon: Icons.explore_rounded,
                iconColor: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              )
            else
              ...visibleItems.map((item) {
                final badgeColor = _badgeColorForTone(item.badgeTone);
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
                    onTap: () => _openRecommendation(context, item),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Future<void> _showAllRecommendations(
    BuildContext parentContext,
    List<HomeRecommendationItem> items,
  ) async {
    await showModalBottomSheet<void>(
      context: parentContext,
      backgroundColor: const Color(0xFF0B1328),
      isScrollControlled: true,
      builder: (context) {
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, color: onSurfaceMuted),
                    ),
                  ],
                ),
                Text(
                  'Escolha a frente que faz mais sentido para hoje.',
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.4,
                  ),
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
                          Navigator.of(context).pop();
                          _openRecommendation(parentContext, item);
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

  void _openRecommendation(BuildContext context, HomeRecommendationItem item) {
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
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.item,
    required this.badgeColor,
    required this.icon,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    required this.onTap,
  });

  final HomeRecommendationItem item;
  final Color badgeColor;
  final IconData icon;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.manrope(
                            color: onSurface,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.badgeLabel.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: badgeColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: GoogleFonts.inter(
                      color: onSurfaceMuted,
                      fontSize: 12.2,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.quiz_rounded, size: 14, color: onSurfaceMuted),
                      const SizedBox(width: 6),
                      Text(
                        item.countLabel,
                        style: GoogleFonts.inter(
                          color: onSurfaceMuted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsPlaceholder extends StatelessWidget {
  const _RecommendationsPlaceholder({
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    required this.primary,
  });

  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Montando recomendacoes personalizadas para hoje...',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsMessageCard extends StatelessWidget {
  const _RecommendationsMessageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
