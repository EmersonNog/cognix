import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMasterStreakCard extends StatelessWidget {
  const HomeMasterStreakCard({
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.military_tech_rounded, color: primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Sequência de Mestre',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Você dominou 12 conceitos esta semana.\nContinue assim!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 10,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                final active = index < 4;
                return Container(
                  width: 6,
                  height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: active ? primary : surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: primary.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
