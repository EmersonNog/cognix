part of '../writing_theme_screen.dart';

class _MonthlyThemeCard extends StatelessWidget {
  const _MonthlyThemeCard({
    required this.theme,
    required this.onOpenTheme,
    this.previewMode = false,
  });

  final WritingTheme? theme;
  final ValueChanged<WritingTheme> onOpenTheme;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final colorScheme = Theme.of(context).colorScheme;
    final currentTheme = theme;
    if (currentTheme == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primaryDim, colors.surfaceLow],
          ),
          border: Border.all(color: colors.accent.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.auto_awesome_rounded, color: colors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REDAÇÃO DO MÊS',
                        style: GoogleFonts.plusJakartaSans(
                          color: colors.accent,
                          fontSize: 9.6,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Destaque especial para sua próxima escrita.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: colors.onSurfaceMuted,
                          fontSize: 11.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InlineTag(
                  label: currentTheme.category,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  foregroundColor: colors.onSurface,
                ),
                if (previewMode)
                  _InlineTag(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Premium',
                    backgroundColor: colors.accent.withValues(alpha: 0.16),
                    foregroundColor: colors.accent,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currentTheme.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentTheme.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted,
                fontSize: 12.8,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onOpenTheme(currentTheme),
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.22),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        previewMode
                            ? Icons.lock_outline_rounded
                            : Icons.bolt_rounded,
                        size: 18,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        previewMode
                            ? 'Desbloquear proposta'
                            : 'Abrir destaque do mês',
                        style: GoogleFonts.manrope(
                          color: colorScheme.onPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
