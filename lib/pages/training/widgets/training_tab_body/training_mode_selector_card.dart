import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingModeSelectorCard extends StatelessWidget {
  const TrainingModeSelectorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.highlights,
    required this.selected,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
    this.trailingLabel,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> highlights;
  final bool selected;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback onTap;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? accent.withValues(alpha: 0.36)
        : surfaceContainerHigh;
    final cardGradient = LinearGradient(
      colors: [
        Color.alphaBlend(accent.withValues(alpha: selected ? 0.14 : 0.08), surfaceContainer),
        Color.alphaBlend(accent.withValues(alpha: selected ? 0.06 : 0.03), surfaceContainerHigh),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 178),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: selected ? 0.16 : 0.08),
                blurRadius: selected ? 24 : 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -18,
                right: -12,
                child: Icon(
                  icon,
                  size: 112,
                  color: accent.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                top: -30,
                right: -10,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Icon(icon, color: accent, size: 25),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Modo de treino',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: accent,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                if (trailingLabel != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.16),
                                      ),
                                    ),
                                    child: Text(
                                      trailingLabel!,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: accent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              title,
                              style: GoogleFonts.manrope(
                                color: onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: surfaceContainerHigh.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.arrow_forward_rounded,
                          color: selected ? accent : onSurfaceMuted,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 220,
                    child: Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final item in highlights)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceContainerHigh.withValues(alpha: 0.68),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            item,
                            style: GoogleFonts.plusJakartaSans(
                              color: onSurface,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
