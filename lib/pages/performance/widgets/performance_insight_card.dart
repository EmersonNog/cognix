import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';
import 'performance_insight_card/performance_insight_action_card.dart';
import 'performance_insight_card/performance_insight_header.dart';
import 'performance_insight_card/performance_insight_helpers.dart';
import 'performance_insight_card/performance_insight_metrics.dart';

class PerformanceInsightCard extends StatelessWidget {
  const PerformanceInsightCard({
    required this.title,
    required this.description,
    this.priority,
    this.riskLevel,
    this.nextAction,
    this.confidence,
    this.generatedAtLabel,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    super.key,
  });

  final String title;
  final String description;
  final String? priority;
  final String? riskLevel;
  final String? nextAction;
  final double? confidence;
  final String? generatedAtLabel;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceContainer, surfaceContainerHigh],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PerformanceInsightHeader(
            title: title,
            metadataText: buildInsightMetadataText(generatedAtLabel),
            primary: primary,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.onSurfaceMuted.withValues(alpha: 0.12),
              ),
            ),
            child: Text(
              description,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 12.6,
                height: 1.55,
              ),
            ),
          ),
          if (priority != null || riskLevel != null || confidence != null) ...[
            const SizedBox(height: 12),
            PerformanceInsightMetrics(
              priority: priority,
              riskLevel: riskLevel,
              onSurface: onSurface,
            ),
          ],
          if (nextAction != null) ...[
            const SizedBox(height: 12),
            PerformanceInsightActionCard(
              nextAction: nextAction!,
              primary: primary,
              onSurface: onSurface,
            ),
          ],
          if (confidence != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Confiança da leitura: ${(confidence! * 100).round()}%',
                style: GoogleFonts.inter(
                  color: onSurfaceMuted.withValues(alpha: 0.92),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
