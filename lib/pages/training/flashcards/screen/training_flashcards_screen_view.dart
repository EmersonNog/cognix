part of '../training_flashcards_screen.dart';

Widget _buildScreenForState(_TrainingFlashcardsScreenState state) {
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
        'Flashcards',
        style: GoogleFonts.manrope(
          color: state.widget.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    body: _buildBodyForState(state),
  );
}

Widget _buildBodyForState(_TrainingFlashcardsScreenState state) {
  if (state._isLoading) {
    return Center(
      child: CircularProgressIndicator(color: state.widget.primary),
    );
  }

  if (state._isSubscriptionRequired) {
    return _buildSubscriptionRequiredBodyForState(state);
  }

  return _buildDecksBodyForState(state, deckEntries: state._buildDeckEntries());
}

Widget _buildSubscriptionRequiredBodyForState(
  _TrainingFlashcardsScreenState state,
) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
    children: [
      TrainingFlashcardsCreateActionCard(
        surfaceContainer: state.widget.surfaceContainer,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
        totalFlashcards: 0,
        previewMode: true,
        onCreateFlashcard: state._openSubscription,
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: state.widget.surfaceContainer,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: state.widget.surfaceContainerHigh.withValues(alpha: 0.85),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: state.widget.surfaceContainerHigh.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: state.widget.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seus decks ficam aqui',
                    style: GoogleFonts.manrope(
                      color: state.widget.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Liberando a assinatura, você pode criar decks por matéria, revisar respostas e continuar de onde parou.',
                    style: GoogleFonts.inter(
                      color: state.widget.onSurfaceMuted,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDecksBodyForState(
  _TrainingFlashcardsScreenState state, {
  required List<MapEntry<String, List<TrainingFlashcardDraft>>> deckEntries,
}) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
    children: [
      if (state._recoveredImagePaths.isNotEmpty) ...[
        TrainingFlashcardsRecoveredImageBanner(
          count: state._recoveredImagePaths.length,
          surfaceContainer: state.widget.surfaceContainer,
          surfaceContainerHigh: state.widget.surfaceContainerHigh,
          onSurface: state.widget.onSurface,
          onSurfaceMuted: state.widget.onSurfaceMuted,
        ),
        const SizedBox(height: 16),
      ],
      TrainingFlashcardsCreateActionCard(
        surfaceContainer: state.widget.surfaceContainer,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
        primary: state.widget.primary,
        totalFlashcards: state._flashcards.length,
        onCreateFlashcard: state._openCreateFlashcardSheet,
      ),
      const SizedBox(height: 18),
      Text(
        'Seus flashcards',
        style: GoogleFonts.manrope(
          color: state.widget.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 12),
      TrainingFlashcardsDeckSearchField(
        controller: state._searchController,
        surfaceContainer: state.widget.surfaceContainer,
        surfaceContainerHigh: state.widget.surfaceContainerHigh,
        onSurface: state.widget.onSurface,
        onSurfaceMuted: state.widget.onSurfaceMuted,
      ),
      const SizedBox(height: 12),
      _buildDeckFiltersForState(state),
      const SizedBox(height: 14),
      if (deckEntries.isEmpty)
        TrainingFlashcardsDeckEmptyState(
          surfaceContainer: state.widget.surfaceContainer,
          surfaceContainerHigh: state.widget.surfaceContainerHigh,
          onSurface: state.widget.onSurface,
          onSurfaceMuted: state.widget.onSurfaceMuted,
        )
      else
        for (final entry in deckEntries) ...[
          _buildDeckTileForState(state, entry),
          const SizedBox(height: 12),
        ],
    ],
  );
}

Widget _buildDeckFiltersForState(_TrainingFlashcardsScreenState state) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: TrainingFlashcardDeckFilter.values.map((filter) {
        final isSelected = filter == state._selectedFilter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(trainingFlashcardDeckFilterLabel(filter)),
            selected: isSelected,
            onSelected: (_) {
              state._applyState(() => state._selectedFilter = filter);
            },
            labelStyle: GoogleFonts.plusJakartaSans(
              color: isSelected ? Colors.white : state.widget.onSurfaceMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: state.widget.surfaceContainer,
            selectedColor: state.widget.primary,
            side: BorderSide(
              color: isSelected
                  ? state.widget.primary
                  : state.widget.surfaceContainerHigh.withValues(alpha: 0.9),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            visualDensity: VisualDensity.compact,
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildDeckTileForState(
  _TrainingFlashcardsScreenState state,
  MapEntry<String, List<TrainingFlashcardDraft>> entry,
) {
  return Dismissible(
    key: ValueKey('deck-${entry.key}'),
    direction: DismissDirection.endToStart,
    background: TrainingFlashcardsDeckDeleteBackground(
      surfaceContainerHigh: state.widget.surfaceContainerHigh,
    ),
    confirmDismiss: (_) => state._confirmDeleteDeck(entry),
    onDismissed: (_) => state._handleDeckDismissed(entry),
    child: TrainingFlashcardsDeckTile(
      subject: entry.key,
      flashcards: entry.value,
      reviewedCount:
          state._deckReviewedCounts[entry.key]?.clamp(0, entry.value.length) ??
          0,
      surfaceContainer: state.widget.surfaceContainer,
      surfaceContainerHigh: state.widget.surfaceContainerHigh,
      onSurface: state.widget.onSurface,
      primary: state.widget.primary,
      onTap: () => state._openDeck(entry),
    ),
  );
}
