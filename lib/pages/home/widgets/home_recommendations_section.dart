import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRecommendationsSection extends StatelessWidget {
  const HomeRecommendationsSection({
    super.key,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.surfaceContainerHigh,
  });

  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recomendado para\nHoje',
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ver Tudo',
                style: GoogleFonts.plusJakartaSans(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Text(
          'Priorizando topicos de peso para seu exame',
          style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
        ),
        const SizedBox(height: 14),
        _RecommendedCard(
          title: 'Calculo Avancado',
          description:
              'Aplicacoes de derivadas e integrais em sistemas fisicos.',
          badgeLabel: 'Critico',
          badgeColor: const Color(0xFFA3A6FF),
          icon: Icons.functions_rounded,
          primary: primary,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          surfaceContainerHigh: surfaceContainerHigh,
          countLabel: '12 licoes',
        ),
        const SizedBox(height: 12),
        _RecommendedCard(
          title: 'Revolucoes Modernas',
          description: 'Impacto dos movimentos sociais na governanca global.',
          badgeLabel: 'Moderado',
          badgeColor: const Color(0xFF7ED6C5),
          icon: Icons.public_rounded,
          primary: primary,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          surfaceContainerHigh: surfaceContainerHigh,
          countLabel: '8 licoes',
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.icon,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    required this.countLabel,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final IconData icon;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.manrope(
                          color: onSurface,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeLabel.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: badgeColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.2,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: onSurfaceMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      countLabel,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: primary, size: 22),
        ],
      ),
    );
  }
}
