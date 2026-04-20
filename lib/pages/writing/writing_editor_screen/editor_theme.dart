part of '../writing_editor_screen.dart';

class _ThemeHero extends StatelessWidget {
  const _ThemeHero({required this.theme});

  final WritingTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2341), Color(0xFF101B32)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _editorAccent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeroPill(
                icon: Icons.label_rounded,
                label: theme.category.toUpperCase(),
                accent: _editorAccent,
              ),
              const SizedBox(width: 8),
              _HeroPill(
                icon: Icons.bar_chart_rounded,
                label: _formatDifficultyLabel(theme.difficulty),
                accent: _difficultyAccent(theme.difficulty),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            theme.title,
            style: GoogleFonts.manrope(
              color: _editorOnSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            theme.description,
            style: GoogleFonts.inter(
              color: _editorOnSurfaceMuted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
    required this.accent,
  });

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
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: _editorAccent,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: _editorOnSurface,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: _editorOnSurfaceMuted,
            fontSize: 12.8,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _editorSurfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _editorPrimary.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
