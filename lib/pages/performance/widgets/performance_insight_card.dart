import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';

class PerformanceInsightCard extends StatelessWidget {
  const PerformanceInsightCard({
    required this.title,
    required this.description,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    super.key,
  });

  final String title;
  final String description;
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.insights_rounded, color: primary, size: 20),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Resumo editorial do seu momento atual',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted.withValues(alpha: 0.9),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}
