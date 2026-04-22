part of 'writing_theme_screen.dart';

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveSearch,
  });

  final int visibleCount;
  final int totalCount;
  final bool hasActiveSearch;

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
                'Navegue pelos temas disponíveis sem sair da tela.',
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
            detail,
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

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.theme, required this.onTap});

  final WritingTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final categoryAccent = _categoryAccent(theme.category);
    final difficultyStyle = _difficultyStyle(theme.difficulty);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThemeBadge(
                    label: theme.category,
                    backgroundColor: categoryAccent.withValues(alpha: 0.12),
                    foregroundColor: categoryAccent,
                  ),
                  const SizedBox(width: 8),
                  _ThemeBadge(
                    label: _formatDifficultyLabel(theme.difficulty),
                    backgroundColor: difficultyStyle.background,
                    foregroundColor: difficultyStyle.foreground,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: colors.onSurfaceMuted,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                theme.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  color: colors.onSurface,
                  fontSize: 14.8,
                  fontWeight: FontWeight.w900,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                theme.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: colors.onSurfaceMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              if (theme.keywords.isNotEmpty) ...[
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final keyword in theme.keywords.take(3))
                      _KeywordPill(label: keyword),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _KeywordPill extends StatelessWidget {
  const _KeywordPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: colors.onSurfaceMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
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
                isLoading ? 'Carregando...' : 'Carregar mais $count temas',
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

class _ThemeBadge extends StatelessWidget {
  const _ThemeBadge({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: foregroundColor ?? colors.accent,
          fontSize: 9.4,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
