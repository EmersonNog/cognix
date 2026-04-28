part of '../training_areas_screen.dart';

const _previewAreaTotals = <SubjectsArea, int>{
  SubjectsArea.natureza: 681,
  SubjectsArea.humanas: 701,
  SubjectsArea.linguagens: 690,
  SubjectsArea.matematica: 650,
};

Widget _buildScreenForState(_TrainingAreasScreenState state) {
  final pageBackgroundColor = Theme.of(state.context).scaffoldBackgroundColor;

  return Scaffold(
    backgroundColor: pageBackgroundColor,
    appBar: AppBar(
      backgroundColor: pageBackgroundColor,
      surfaceTintColor: pageBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: BackButton(color: state.widget.onSurface),
      title: Text(
        'Questões',
        style: GoogleFonts.manrope(
          color: state.widget.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    body: RefreshIndicator(
      onRefresh: state._refresh,
      color: state.widget.primary,
      backgroundColor: state.widget.surfaceContainer,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
        children: [
          Text(
            'Escolha uma área para começar seu treino e explorar os temas disponíveis.',
            style: GoogleFonts.inter(
              color: state.widget.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          FutureBuilder<Map<SubjectsArea, int>>(
            future: state._areaTotalsFuture,
            builder: (context, snapshot) {
              return _buildAreaTotalsSectionForState(state, snapshot);
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildAreaTotalsSectionForState(
  _TrainingAreasScreenState state,
  AsyncSnapshot<Map<SubjectsArea, int>> snapshot,
) {
  final previewMode =
      snapshot.hasError && isSubscriptionRequiredError(snapshot.error);
  final totals = previewMode ? _previewAreaTotals : snapshot.data ?? const {};
  final totalQuestions = totals.values.fold<int>(
    0,
    (sum, value) => sum + value,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _TrainingAreasSectionHeader(
        surfaceContainer: state.widget.surfaceContainer,
        surfaceContainerHigh: state.widget.surfaceContainerHigh,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        totalQuestions: totalQuestions,
        previewMode: previewMode,
      ),
      const SizedBox(height: 14),
      for (final area in trainingAreas) ...[
        TrainingAreaCard(
          item: area,
          totalQuestions: totals[area.area] ?? 0,
          surfaceContainer: state.widget.surfaceContainer,
          surfaceContainerHigh: state.widget.surfaceContainerHigh,
          onSurface: state.widget.onSurface,
          onSurfaceMuted: state.widget.onSurfaceMuted,
          locked: previewMode,
          onTap: previewMode ? null : () => state._openArea(area),
        ),
        const SizedBox(height: 14),
      ],
    ],
  );
}

class _TrainingAreasSectionHeader extends StatelessWidget {
  const _TrainingAreasSectionHeader({
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.totalQuestions,
    required this.previewMode,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final int totalQuestions;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Áreas disponíveis',
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                previewMode
                    ? 'Prévia do acervo liberado com assinatura'
                    : 'Selecione uma trilha para praticar agora',
                style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 11.5),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: surfaceContainerHigh),
          ),
          child: Text(
            previewMode
                ? '$totalQuestions questões'
                : '$totalQuestions questões',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
