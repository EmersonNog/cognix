import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/summaries/summaries_api.dart';
import '../../../utils/api_datetime.dart';

class TrainingSummaryStatsCard extends StatelessWidget {
  const TrainingSummaryStatsCard({
    super.key,
    required this.stats,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.isLocked = false,
  });

  final SummaryStats stats;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final accuracy = '${stats.accuracyPercent.toStringAsFixed(1)}%';
    final total = stats.totalAttempts.toString();
    final correct = stats.totalCorrect.toString();
    final lastAttempt = formatShortDateTime(stats.lastAttemptAt);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLocked
                ? 'Estatísticas liberadas ao concluir o simulado.'
                : 'Dados do seu histórico nesta disciplina.',
            style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 11.5),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryStatBadge(
                label: 'Aproveitamento',
                value: accuracy,
                accent: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                isLocked: isLocked,
              ),
              _SummaryStatBadge(
                label: 'Acertos',
                value: correct,
                accent: primary.withValues(alpha: 0.8),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                isLocked: isLocked,
              ),
              _SummaryStatBadge(
                label: 'Tentativas',
                value: total,
                accent: primary.withValues(alpha: 0.65),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                isLocked: isLocked,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: isLocked
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: onSurfaceMuted,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Atividade recente bloqueada',
                        style: GoogleFonts.inter(
                          color: onSurfaceMuted,
                          fontSize: 11.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                : Text(
                    'Atividade recente: $lastAttempt',
                    style: GoogleFonts.inter(
                      color: onSurfaceMuted,
                      fontSize: 11.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatBadge extends StatelessWidget {
  const _SummaryStatBadge({
    required this.label,
    required this.value,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.isLocked,
  });

  final String label;
  final String value;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          if (isLocked)
            Icon(Icons.lock_outline_rounded, color: onSurface, size: 15)
          else
            Text(
              value,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
