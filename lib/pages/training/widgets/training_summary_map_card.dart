import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingSummaryMapCard extends StatelessWidget {
  const TrainingSummaryMapCard({
    super.key,
    required this.isCompact,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.isLocked = false,
    this.lockedMessage,
  });

  final bool isCompact;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool isLocked;
  final String? lockedMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.account_tree_rounded, color: primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mapa mental',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLocked
                      ? (lockedMessage ??
                            'Conclua o simulado para liberar seu mapa mental personalizado.')
                      : isCompact
                      ? 'Começa focado no tema principal. Arraste e aproxime para explorar.'
                      : 'Mapa mental interativo para revisar pontos-chave com zoom e arraste.',
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
