part of 'home_recommendations_section.dart';

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
