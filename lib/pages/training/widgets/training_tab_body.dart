import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../subjects/subjects_data.dart';
import '../models/training_tab_models.dart';
import 'training_area_card.dart';
import 'training_rhythm_card.dart';

class TrainingTabBody extends StatelessWidget {
  const TrainingTabBody({
    super.key,
    required this.rhythmFuture,
    required this.areaTotalsFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onRefresh,
    required this.onOpenArea,
  });

  final Future<TrainingRhythmData> rhythmFuture;
  final Future<Map<SubjectsArea, int>> areaTotalsFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback onRefresh;
  final ValueChanged<TrainingAreaItem> onOpenArea;

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
            'Áreas de Conhecimento',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Escolha uma área para iniciar seu treino personalizado.',
            style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          FutureBuilder<TrainingRhythmData>(
            future: rhythmFuture,
            builder: (context, snapshot) {
              final rhythm =
                  snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData
                  ? const TrainingRhythmData.loading()
                  : snapshot.data ??
                        (snapshot.hasError
                            ? const TrainingRhythmData.error()
                            : const TrainingRhythmData.empty());

              return TrainingRhythmCard(
                data: rhythm,
                surfaceContainerHigh: surfaceContainerHigh,
                primary: primary,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'LISTA DE AREAS',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Map<SubjectsArea, int>>(
            future: areaTotalsFuture,
            builder: (context, snapshot) {
              final totals = snapshot.data ?? const <SubjectsArea, int>{};

              return Column(
                children: [
                  for (final area in trainingAreas) ...[
                    TrainingAreaCard(
                      item: area,
                      totalQuestions: totals[area.area] ?? 0,
                      surfaceContainer: surfaceContainer,
                      surfaceContainerHigh: surfaceContainerHigh,
                      onSurface: onSurface,
                      onSurfaceMuted: onSurfaceMuted,
                      onTap: () => onOpenArea(area),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
