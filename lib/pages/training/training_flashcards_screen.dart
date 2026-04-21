import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/training_tab_body/training_flashcards_panel.dart';

class TrainingFlashcardsScreen extends StatelessWidget {
  const TrainingFlashcardsScreen({
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: onSurface),
        title: Text(
          'Flashcards',
          style: GoogleFonts.manrope(
            color: onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        children: [
          TrainingFlashcardsPanel(
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Quando essa frente entrar, a ideia e abrir decks por disciplina, revisao por dificuldade e retomada dos erros mais recentes.',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
