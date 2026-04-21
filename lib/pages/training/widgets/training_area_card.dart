import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/training_tab_models.dart';

class TrainingAreaCard extends StatelessWidget {
  const TrainingAreaCard({
    super.key,
    required this.item,
    required this.totalQuestions,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final TrainingAreaItem item;
  final int totalQuestions;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final backgroundIconColor = isLightTheme
        ? onSurfaceMuted.withValues(alpha: 0.10)
        : item.accent.withValues(alpha: 0.06);
    final cardGradient = LinearGradient(
      colors: [
        Color.alphaBlend(
          item.accent.withValues(alpha: isLightTheme ? 0.06 : 0.12),
          surfaceContainer,
        ),
        Color.alphaBlend(
          item.accent.withValues(alpha: isLightTheme ? 0.02 : 0.04),
          surfaceContainer,
        ),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: item.accent.withValues(alpha: isLightTheme ? 0.10 : 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: item.accent.withValues(alpha: isLightTheme ? 0.05 : 0.12),
                blurRadius: isLightTheme ? 14 : 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -34,
                right: -22,
                child: isLightTheme
                    ? const SizedBox.shrink()
                    : Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              item.accent.withValues(alpha: 0.14),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
              ),
              Positioned(
                bottom: -18,
                right: -14,
                child: Icon(
                  item.icon,
                  size: 84,
                  color: backgroundIconColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: item.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: item.accent.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(item.icon, color: item.accent, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: item.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Area de treino',
                              style: GoogleFonts.plusJakartaSans(
                                color: item.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.title,
                            style: GoogleFonts.manrope(
                              color: onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.subtitle,
                            style: GoogleFonts.inter(
                              color: onSurfaceMuted,
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceContainerHigh.withValues(
                                    alpha: 0.82,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: item.accent.withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  '$totalQuestions questões',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: onSurface,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Entrar agora',
                                style: GoogleFonts.plusJakartaSans(
                                  color: item.accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isLightTheme
                            ? surfaceContainerHigh.withValues(alpha: 0.92)
                            : surfaceContainerHigh.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: item.accent.withValues(
                            alpha: isLightTheme ? 0.10 : 0.06,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: isLightTheme
                            ? item.accent.withValues(alpha: 0.72)
                            : onSurface,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
