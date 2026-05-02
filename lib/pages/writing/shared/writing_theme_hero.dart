import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/cognix_theme_colors.dart';

class WritingThemeHero extends StatelessWidget {
  const WritingThemeHero({super.key, required this.theme});

  final WritingTheme theme;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryDim, colors.surfaceLow],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              _WritingThemeHeroPill(
                icon: Icons.label_rounded,
                label: theme.category.toUpperCase(),
                accent: colors.accent,
              ),
              const SizedBox(width: 8),
              _WritingThemeHeroPill(
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
              color: colors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            theme.description,
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _WritingThemeHeroPill extends StatelessWidget {
  const _WritingThemeHeroPill({
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

Color _difficultyAccent(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const Color(0xFF65E6A5);
    case 'dificil':
    case 'difícil':
      return const Color(0xFFFF8E9D);
    default:
      return AppTheme.darkColors.accent;
  }
}

String _formatDifficultyLabel(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return 'Fácil';
    case 'medio':
    case 'médio':
      return 'Médio';
    case 'dificil':
    case 'difícil':
      return 'Difícil';
    default:
      return value.trim().isEmpty ? 'Médio' : value.trim();
  }
}
