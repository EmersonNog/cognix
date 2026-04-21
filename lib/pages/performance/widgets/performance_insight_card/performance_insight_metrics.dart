import 'package:flutter/material.dart';

import '../../../../theme/cognix_theme_colors.dart';
import 'performance_insight_helpers.dart';

class PerformanceInsightMetrics extends StatelessWidget {
  const PerformanceInsightMetrics({
    super.key,
    required this.priority,
    required this.riskLevel,
    required this.onSurface,
  });

  final String? priority;
  final String? riskLevel;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 8) / 2;
        return Row(
          children: [
            if (priority != null)
              SizedBox(
                width: itemWidth,
                child: PerformanceInsightBadge(
                  label: 'Prioridade',
                  value: priority!,
                  color: colors.primary,
                  textColor: onSurface,
                ),
              )
            else
              SizedBox(width: itemWidth),
            const SizedBox(width: 8),
            if (riskLevel != null)
              SizedBox(
                width: itemWidth,
                child: PerformanceInsightBadge(
                  label: 'Risco',
                  value: capitalizeInsightLabel(riskLevel!),
                  color: resolveInsightRiskColor(colors, riskLevel!),
                  textColor: onSurface,
                ),
              )
            else
              SizedBox(width: itemWidth),
          ],
        );
      },
    );
  }
}

class PerformanceInsightBadge extends StatelessWidget {
  const PerformanceInsightBadge({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.78),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
