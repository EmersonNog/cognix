part of 'home_recent_performance_card.dart';

class _RecentPerformanceContainer extends StatelessWidget {
  const _RecentPerformanceContainer({
    required this.surfaceContainer,
    required this.child,
  });

  final Color surfaceContainer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _RecentPerformanceEmptyState extends StatelessWidget {
  const _RecentPerformanceEmptyState({
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.insights_rounded, color: onSurfaceMuted, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sem simulados recentes',
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Conclua um simulado para acompanhar seus últimos resultados aqui.',
                style: GoogleFonts.inter(
                  color: onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentPerformanceLoadingState extends StatelessWidget {
  const _RecentPerformanceLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _PerformancePlaceholderRow(),
        SizedBox(height: 12),
        _PerformancePlaceholderRow(),
        SizedBox(height: 12),
        _PerformancePlaceholderRow(),
      ],
    );
  }
}

class _PerformancePlaceholderRow extends StatelessWidget {
  const _PerformancePlaceholderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2541),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2541),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 96,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF16213B),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 44,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2541),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 70,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF16213B),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({
    required this.item,
    required this.now,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final ProfileRecentCompletedSession item;
  final DateTime now;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    final percent = item.accuracyPercent.round();
    final denominator = item.answeredQuestions > 0
        ? item.answeredQuestions
        : item.totalQuestions;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.quiz_rounded, color: accent, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.subcategory,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _buildRelativeCompletionLabel(
                  item.completedAt,
                  now,
                ).toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 9.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percent%',
              style: GoogleFonts.manrope(
                color: accent,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.correctAnswers}/$denominator corretas',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 10.5),
            ),
          ],
        ),
      ],
    );
  }
}
