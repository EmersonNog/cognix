import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingPromptCard extends StatelessWidget {
  const TrainingPromptCard({
    super.key,
    required this.surfaceContainer,
    required this.onSurface,
  });

  final Color surfaceContainer;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        'Identifique o princípio fundamental que explica a amplitude de '
        'probabilidade não nula dentro das regiões de barreira.',
        style: GoogleFonts.manrope(
          color: onSurface,
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
