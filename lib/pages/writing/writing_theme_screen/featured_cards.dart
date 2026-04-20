part of '../writing_theme_screen.dart';

class _MonthlyThemeCard extends StatelessWidget {
  const _MonthlyThemeCard({required this.theme, required this.onOpenTheme});

  final WritingTheme? theme;
  final ValueChanged<WritingTheme> onOpenTheme;

  @override
  Widget build(BuildContext context) {
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D2142), Color(0xFF121C34)],
          ),
          border: Border.all(
            color: _WritingThemeScreenState._accent.withValues(alpha: 0.28),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.18),
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
                    color: _WritingThemeScreenState._accent.withValues(
                      alpha: 0.14,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: _WritingThemeScreenState._accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REDAÃ‡ÃƒO DO MÃŠS',
                        style: GoogleFonts.plusJakartaSans(
                          color: _WritingThemeScreenState._accent,
                          fontSize: 9.6,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Destaque especial para sua prÃ³xima escrita.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: _WritingThemeScreenState._onSurfaceMuted,
                          fontSize: 11.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    currentTheme.category,
                    style: GoogleFonts.inter(
                      color: _WritingThemeScreenState._onSurface,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currentTheme.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: _WritingThemeScreenState._onSurface,
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
                color: _WritingThemeScreenState._onSurfaceMuted,
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
                    color: _WritingThemeScreenState._accent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _WritingThemeScreenState._accent.withValues(
                          alpha: 0.22,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 18,
                        color: _WritingThemeScreenState._surface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Abrir destaque do mês',
                        style: GoogleFonts.manrope(
                          color: _WritingThemeScreenState._surface,
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

class _HistoryShortcutCard extends StatelessWidget {
  const _HistoryShortcutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _WritingThemeScreenState._primary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _WritingThemeScreenState._primary.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.history_edu_rounded,
                  color: _WritingThemeScreenState._primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seu histórico de redações',
                      style: GoogleFonts.manrope(
                        color: _WritingThemeScreenState._onSurface,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Revise versões, compare avanços e retome qualquer texto.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: _WritingThemeScreenState._onSurfaceMuted,
                        fontSize: 12.2,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _WritingThemeScreenState._primary.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Abrir',
                  style: GoogleFonts.inter(
                    color: _WritingThemeScreenState._primary,
                    fontSize: 12.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
