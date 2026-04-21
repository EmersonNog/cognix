import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'training_tab_body/training_mode_selector_card.dart';

class TrainingTabBody extends StatelessWidget {
  const TrainingTabBody({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onRefresh,
    required this.onOpenAreas,
    required this.onOpenMultiplayer,
    required this.onOpenFlashcards,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback onRefresh;
  final VoidCallback onOpenAreas;
  final VoidCallback onOpenMultiplayer;
  final VoidCallback onOpenFlashcards;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: primary,
      backgroundColor: surfaceContainer,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: [
          Text(
            'Treino',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Escolha o modo de treino que faz mais sentido para este momento.',
            style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 13),
          ),
          const SizedBox(height: 22),
          Text(
            'MODOS DISPONIVEIS',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          TrainingModeSelectorCard(
            title: 'Banco de questões',
            subtitle:
                'Explore questões para estudar com mais foco e consistência.',
            icon: Icons.dashboard_customize_rounded,
            accent: const Color(0xFF7C9BFF),
            highlights: const ['+2700 questões', 'ENEM', 'Disciplinas'],
            selected: false,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            onTap: onOpenAreas,
          ),
          const SizedBox(height: 12),
          TrainingModeSelectorCard(
            title: 'Multiplayer',
            subtitle:
                'Crie salas, entre por PIN e dispute partidas com outros jogadores.',
            icon: Icons.groups_rounded,
            accent: const Color(0xFFC28BFF),
            highlights: const ['Ao vivo', 'Ranking', 'Competição'],
            selected: false,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            onTap: onOpenMultiplayer,
          ),
          const SizedBox(height: 12),
          TrainingModeSelectorCard(
            title: 'Flashcards',
            subtitle:
                'Revise rápido, fixe conceitos e retome os pontos mais frágeis.',
            icon: Icons.style_rounded,
            accent: const Color(0xFF4ED7A6),
            highlights: const ['Revisão', 'Memória', 'Ágil'],
            selected: false,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            trailingLabel: 'Em breve',
            onTap: onOpenFlashcards,
          ),
        ],
      ),
    );
  }
}
