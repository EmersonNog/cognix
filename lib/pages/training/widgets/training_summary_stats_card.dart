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
  });

  final SummaryStats stats;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

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
              ),
              _SummaryStatBadge(
                label: 'Acertos',
                value: correct,
                accent: primary.withOpacity(0.8),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
              _SummaryStatBadge(
                label: 'Tentativas',
                value: total,
                accent: primary.withOpacity(0.65),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Ultima tentativa: $lastAttempt',
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 11.5,
              ),
              textAlign: TextAlign.right,
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
  });

  final String label;
  final String value;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.35)),
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
