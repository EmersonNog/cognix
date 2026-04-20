part of '../writing_history_screen.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.totalCount, required this.latest});

  final int totalCount;
  final WritingSubmissionSummary? latest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07142A), Color(0xFF0A1931)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _WritingHistoryScreenState._primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'HISTÓRICO',
              style: GoogleFonts.plusJakartaSans(
                color: _WritingHistoryScreenState._accent,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Suas versões em um só lugar.',
            style: GoogleFonts.manrope(
              color: _WritingHistoryScreenState._onSurface,
              fontSize: 18.5,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                icon: Icons.folder_copy_rounded,
                label:
                    '$totalCount ${totalCount == 1 ? 'redação' : 'redações'}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _WritingHistoryScreenState._accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _WritingHistoryScreenState._accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _WritingHistoryScreenState._accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: _WritingHistoryScreenState._onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: _WritingHistoryScreenState._onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onTap});

  final WritingSubmissionSummary item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final categoryAccent = _categoryAccent(item.theme.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _WritingHistoryScreenState._surfaceContainer,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _WritingHistoryScreenState._primary.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Badge(
                    label: item.theme.category,
                    background: categoryAccent.withValues(alpha: 0.12),
                    foreground: categoryAccent,
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    label: 'V${item.currentVersion}',
                    background: _WritingHistoryScreenState._primary.withValues(
                      alpha: 0.12,
                    ),
                    foreground: _WritingHistoryScreenState._primary,
                  ),
                  const Spacer(),
                  if (item.latestScore != null)
                    Text(
                      '${item.latestScore}',
                      style: GoogleFonts.manrope(
                        color: _WritingHistoryScreenState._onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.theme.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  color: _WritingHistoryScreenState._onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.latestSummary.isEmpty
                    ? 'Sem resumo salvo para esta redação.'
                    : item.latestSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: _WritingHistoryScreenState._onSurfaceMuted,
                  fontSize: 12.7,
                  height: 1.42,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: _WritingHistoryScreenState._onSurfaceMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      formatShortDateTime(item.lastAnalyzedAt),
                      style: GoogleFonts.inter(
                        color: _WritingHistoryScreenState._onSurfaceMuted,
                        fontSize: 11.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Abrir histórico',
                    style: GoogleFonts.plusJakartaSans(
                      color: _WritingHistoryScreenState._accent,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: _WritingHistoryScreenState._accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: foreground,
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}
