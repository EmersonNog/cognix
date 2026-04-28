part of '../writing_theme_screen.dart';

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveSearch,
    this.previewMode = false,
  });

  final int visibleCount;
  final int totalCount;
  final bool hasActiveSearch;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final label = hasActiveSearch
        ? 'Resultados encontrados'
        : 'Temas disponíveis';
    final detail = visibleCount >= totalCount
        ? '$totalCount temas'
        : '$visibleCount de $totalCount temas';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: colors.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                previewMode
                    ? 'Explore alguns temas antes de desbloquear o acervo completo.'
                    : 'Navegue pelos temas disponíveis sem sair da tela.',
                style: GoogleFonts.inter(
                  color: colors.onSurfaceMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            previewMode ? '$detail • premium' : detail,
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({
    required this.remainingCount,
    required this.isLoading,
    required this.onTap,
    this.previewMode = false,
  });

  final int remainingCount;
  final bool isLoading;
  final VoidCallback onTap;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final count = remainingCount > _WritingThemeScreenState._pageSize
        ? _WritingThemeScreenState._pageSize
        : remainingCount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.accent.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                isLoading
                    ? 'Carregando...'
                    : previewMode
                    ? 'Explorar mais $count temas'
                    : 'Carregar mais $count temas',
                style: GoogleFonts.inter(
                  color: colors.accent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (!isLoading) ...[
                const SizedBox(width: 8),
                Icon(Icons.expand_more_rounded, color: colors.accent),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
