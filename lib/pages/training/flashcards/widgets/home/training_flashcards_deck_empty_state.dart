import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardsDeckEmptyState extends StatelessWidget {
  const TrainingFlashcardsDeckEmptyState({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: surfaceContainerHigh.withValues(alpha: 0.85)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: surfaceContainerHigh.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.search_off_rounded,
              color: onSurfaceMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhum deck encontrado com esses filtros.',
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
