part of '../writing_theme_screen.dart';

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.onTap,
    this.previewMode = false,
  });

  final WritingTheme theme;
  final VoidCallback onTap;
  final bool previewMode;

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
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: previewMode
                          ? colors.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      previewMode
                          ? Icons.lock_outline_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: previewMode
                          ? colors.primary
                          : colors.onSurfaceMuted,
                    ),
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
              if (previewMode) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Disponível com assinatura',
                      style: GoogleFonts.inter(
                        color: colors.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: foregroundColor ?? colors.accent,
              fontSize: 9.4,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
