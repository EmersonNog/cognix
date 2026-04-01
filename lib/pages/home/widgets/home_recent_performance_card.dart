import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRecentPerformanceCard extends StatelessWidget {
  const HomeRecentPerformanceCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desempenho Recente',
          style: GoogleFonts.manrope(
            color: onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _PerformanceRow(
                title: 'Química Orgânica I',
                subtitle: 'Concluído há 2h',
                percent: 92,
                correctLabel: '18/20 corretas',
                accent: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              ),
              const SizedBox(height: 12),
              _PerformanceRow(
                title: 'Gravitação Universal',
                subtitle: 'Concluído ontem',
                percent: 75,
                correctLabel: '15/20 corretas',
                accent: const Color(0xFF7ED6C5),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              ),
              const SizedBox(height: 12),
              _PerformanceRow(
                title: 'Literatura: O Iluminismo',
                subtitle: 'Concluído há 2 dias',
                percent: 58,
                correctLabel: '7/12 corretas',
                accent: const Color(0xFFEF6A6A),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                surfaceContainerHigh: surfaceContainerHigh,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.correctLabel,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final String title;
  final String subtitle;
  final int percent;
  final String correctLabel;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.quiz_rounded, color: accent, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 9.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percent%',
              style: GoogleFonts.manrope(
                color: accent,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              correctLabel,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
