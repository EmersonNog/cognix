part of '../writing_history_detail_screen.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.pillLabel,
  });

  final String title;
  final String subtitle;
  final String pillLabel;

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
                  color: _WritingHistoryDetailScreenState._onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: _WritingHistoryDetailScreenState._onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: _WritingHistoryDetailScreenState._surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            pillLabel,
            style: GoogleFonts.inter(
              color: _WritingHistoryDetailScreenState._onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({
    required this.detail,
    required this.version,
    required this.isLatest,
    required this.onContinue,
    required this.onOpenDiagnosis,
  });

  final WritingSubmissionDetail detail;
  final WritingSubmissionVersion version;
  final bool isLatest;
  final VoidCallback onContinue;
  final VoidCallback onOpenDiagnosis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _WritingHistoryDetailScreenState._surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isLatest
              ? _WritingHistoryDetailScreenState._accent.withValues(alpha: 0.22)
              : _WritingHistoryDetailScreenState._primary.withValues(
                  alpha: 0.12,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                icon: Icons.layers_rounded,
                label: 'Versão ${version.versionNumber}',
                accent: isLatest
                    ? _WritingHistoryDetailScreenState._accent
                    : _WritingHistoryDetailScreenState._primary,
              ),
              if (isLatest) ...[
                const SizedBox(width: 8),
                _Pill(
                  icon: Icons.star_rounded,
                  label: 'Atual',
                  accent: _WritingHistoryDetailScreenState._success,
                ),
              ],
              const Spacer(),
              Text(
                '${version.estimatedScore}',
                style: GoogleFonts.manrope(
                  color: _WritingHistoryDetailScreenState._onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            version.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: _WritingHistoryDetailScreenState._onSurfaceMuted,
              fontSize: 12.5,
              height: 1.34,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TinyMetric(
                icon: Icons.schedule_rounded,
                label: _shortDate(version.analyzedAt),
              ),
              _TinyMetric(
                icon: Icons.notes_rounded,
                label:
                    '${version.toDraft(theme: detail.theme, submissionId: detail.id).wordCount} palavras',
              ),
              _TinyMetric(
                icon: Icons.task_alt_rounded,
                label:
                    '${version.checklist.where((item) => item.completed).length}/${version.checklist.length} itens',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpenDiagnosis,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _WritingHistoryDetailScreenState._accent,
                    side: BorderSide(
                      color: _WritingHistoryDetailScreenState._accent
                          .withValues(alpha: 0.22),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Diagnóstico'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _WritingHistoryDetailScreenState._primary,
                    foregroundColor: const Color(0xFF060E20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Usar versão'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.accent});

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyMetric extends StatelessWidget {
  const _TinyMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _WritingHistoryDetailScreenState._surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: _WritingHistoryDetailScreenState._onSurfaceMuted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _WritingHistoryDetailScreenState._onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({
    required this.remainingCount,
    required this.isLoading,
    required this.onTap,
  });

  final int remainingCount;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = remainingCount > _WritingHistoryDetailScreenState._pageSize
        ? _WritingHistoryDetailScreenState._pageSize
        : remainingCount;
    final label = count == 1 ? 'versão' : 'versões';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: _WritingHistoryDetailScreenState._surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _WritingHistoryDetailScreenState._accent.withValues(
                alpha: 0.18,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                isLoading ? 'Carregando...' : 'Carregar mais $count $label',
                style: GoogleFonts.inter(
                  color: _WritingHistoryDetailScreenState._accent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
