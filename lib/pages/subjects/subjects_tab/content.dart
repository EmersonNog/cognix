part of '../subjects_tab.dart';

Widget _buildSubjectsTabForState(_SubjectsTabState state) {
  final title = subjectsAreaTitle(state.widget.area);

  return FutureBuilder<List<_SubjectCardData>>(
    future: state._subcategoriesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _LoadingState(
          surfaceContainer: state.widget.surfaceContainer,
          onSurfaceMuted: state.widget.onSurfaceMuted,
          primary: state.widget.primary,
        );
      }

      if (snapshot.hasError) {
        if (isSubscriptionRequiredError(snapshot.error)) {
          return _buildSubscriptionPreviewForState(state, title: title);
        }

        return _ErrorState(
          message: 'Não foi possível carregar as disciplinas.',
          onSurfaceMuted: state.widget.onSurfaceMuted,
        );
      }

      final items = snapshot.data ?? [];
      return _buildLoadedSubjectsForState(state, title: title, items: items);
    },
  );
}

Widget _buildSubscriptionPreviewForState(
  _SubjectsTabState state, {
  required String title,
}) {
  final previewItems = _previewDisciplinesFor(state.widget.area);

  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
    children: [
      SubjectsHeroCard(
        surfaceContainer: state.widget.surfaceContainer,
        surfaceContainerHigh: state.widget.surfaceContainerHigh,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
      ),
      const SizedBox(height: 16),
      const SubscriptionRequiredCard(
        title: 'Disciplinas premium',
        message:
            'Está é uma prévia. Ative seu acesso para abrir as listas de questões.',
        compact: true,
      ),
      const SizedBox(height: 20),
      SubjectCategoryHeader(
        title: title,
        subtitle: '${previewItems.length} Matérias Disponíveis',
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
      ),
      const SizedBox(height: 14),
      for (final discipline in previewItems) ...[
        SubjectCard(
          title: discipline,
          description: _descriptionFor(discipline),
          footerText: 'Prévia premium',
          icon: _iconFor(discipline),
          statusLabel: 'Premium',
          statusColor: state.widget.primary,
          statusBackgroundColor: state.widget.primary.withValues(alpha: 0.14),
          surfaceContainer: state.widget.surfaceContainer,
          surfaceContainerHigh: state.widget.surfaceContainerHigh,
          onSurface: state.widget.onSurface,
          onSurfaceMuted: state.widget.onSurfaceMuted,
          primary: state.widget.primary,
          onTap: () => Navigator.of(state.context).pushNamed('subscription'),
        ),
        const SizedBox(height: 12),
      ],
    ],
  );
}

Widget _buildLoadedSubjectsForState(
  _SubjectsTabState state, {
  required String title,
  required List<_SubjectCardData> items,
}) {
  final totalQuestionsInArea = items.fold<int>(
    0,
    (sum, item) => sum + item.item.total,
  );

  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
    children: [
      SubjectsHeroCard(
        surfaceContainer: state.widget.surfaceContainer,
        surfaceContainerHigh: state.widget.surfaceContainerHigh,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
      ),
      const SizedBox(height: 20),
      SubjectCategoryHeader(
        title: title,
        subtitle: '${items.length} Matérias Disponíveis',
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
      ),
      const SizedBox(height: 14),
      if (items.isEmpty)
        _EmptyState(onSurfaceMuted: state.widget.onSurfaceMuted)
      else
        for (final subcategory in items) ...[
          SubjectCard(
            title: subcategory.item.name,
            description: _descriptionFor(subcategory.item.name),
            footerText: '${subcategory.item.total} questões',
            icon: _iconFor(subcategory.item.name),
            statusLabel: subcategory.status.label,
            statusColor: subcategory.status.foregroundColor,
            statusBackgroundColor: subcategory.status.backgroundColor,
            onTap: () async {
              await Navigator.of(state.context).push(
                MaterialPageRoute(
                  builder: (_) => TrainingDetailScreen(
                    title: subcategory.item.name,
                    discipline: title,
                    area: state.widget.area,
                    description: 'Disciplina de $title',
                    badgeLabel: 'Disciplina',
                    badgeColor: state.widget.primary,
                    countLabel:
                        '${subcategory.item.total} questões disponíveis',
                    areaTotalQuestions: totalQuestionsInArea,
                    surfaceContainerHigh: state.widget.surfaceContainerHigh,
                    onSurface: state.widget.onSurface,
                    onSurfaceMuted: state.widget.onSurfaceMuted,
                    primary: state.widget.primary,
                  ),
                ),
              );
              state._refreshSubjectCards();
            },
            surfaceContainer: state.widget.surfaceContainer,
            surfaceContainerHigh: state.widget.surfaceContainerHigh,
            onSurface: state.widget.onSurface,
            onSurfaceMuted: state.widget.onSurfaceMuted,
            primary: state.widget.primary,
          ),
          const SizedBox(height: 12),
        ],
    ],
  );
}
