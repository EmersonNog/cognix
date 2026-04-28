part of '../training_flashcards_screen.dart';

extension _TrainingFlashcardsScreenActions on _TrainingFlashcardsScreenState {
  void _syncSavedSubjects() {
    final nextSubjects = <String>[];
    for (final flashcard in _flashcards) {
      final subject = flashcard.subject.trim();
      if (subject.isEmpty || subject == 'Sem materia') continue;
      final alreadyExists = nextSubjects.any(
        (saved) => saved.toLowerCase() == subject.toLowerCase(),
      );
      if (!alreadyExists) {
        nextSubjects.add(subject);
      }
    }
    _savedSubjects
      ..clear()
      ..addAll(nextSubjects);
  }

  Future<void> _loadFlashcards() async {
    try {
      final payload = await fetchFlashcards();
      _applyState(() {
        _flashcards
          ..clear()
          ..addAll(payload.items.map(TrainingFlashcardDraft.fromApi));
        _deckReviewedCounts
          ..clear()
          ..addEntries(
            payload.progressBySubject.entries.map(
              (entry) => MapEntry(entry.key, entry.value.currentIndex),
            ),
          );
        _deckSessionStates
          ..clear()
          ..addEntries(
            payload.progressBySubject.entries.map(
              (entry) => MapEntry(
                entry.key,
                TrainingFlashcardDeckSessionState(
                  currentIndex: entry.value.currentIndex,
                  correctCount: entry.value.correctCount,
                  wrongCount: entry.value.wrongCount,
                ),
              ),
            ),
          );
        _syncSavedSubjects();
        _isLoading = false;
        _isSubscriptionRequired = false;
      });
    } catch (error) {
      if (!mounted) return;
      if (isSubscriptionRequiredError(error)) {
        _applyState(() {
          _isLoading = false;
          _isSubscriptionRequired = true;
        });
        return;
      }

      _applyState(() => _isLoading = false);
      showCognixMessage(
        context,
        readableApiErrorMessage(error),
        type: CognixMessageType.error,
      );
    }
  }

  void _deleteDeck(String subject) {
    _applyState(() {
      _flashcards.removeWhere((flashcard) {
        final flashcardSubject = normalizeTrainingFlashcardSubject(
          flashcard.subject,
        );
        return flashcardSubject == subject;
      });
      _deckReviewedCounts.remove(subject);
      _deckSessionStates.remove(subject);
      if (subject != 'Sem materia') {
        _savedSubjects.removeWhere(
          (saved) => saved.toLowerCase() == subject.toLowerCase(),
        );
      }
    });
  }

  Future<void> _openCreateFlashcardSheet() async {
    final created = await showModalBottomSheet<TrainingFlashcardDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TrainingFlashcardCreateSheet(
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
          recoveredImagePaths: List<String>.from(_recoveredImagePaths),
          savedSubjects: List<String>.from(_savedSubjects),
        );
      },
    );

    if (created == null || !mounted) return;
    try {
      final saved = await createFlashcard(
        subject: created.subject.trim(),
        frontText: created.frontText,
        backText: created.backText,
        frontImageBase64: created.frontImage,
        backImageBase64: created.backImage,
      );
      await FlashcardsTutorialStorage.registerFlashcardCreation();
      if (!mounted) return;
      _applyState(() {
        _flashcards.insert(0, TrainingFlashcardDraft.fromApi(saved));
        _recoveredImagePaths.clear();
        _syncSavedSubjects();
      });
    } catch (error) {
      if (!mounted) return;
      if (isSubscriptionRequiredError(error)) {
        _applyState(() => _isSubscriptionRequired = true);
        return;
      }

      showCognixMessage(
        context,
        readableApiErrorMessage(error),
        type: CognixMessageType.error,
      );
    }
  }

  List<MapEntry<String, List<TrainingFlashcardDraft>>> _buildDeckEntries() {
    final searchQuery = _searchController.text.trim().toLowerCase();
    final flashcardsBySubject = <String, List<TrainingFlashcardDraft>>{};

    for (final flashcard in _flashcards) {
      final subject = normalizeTrainingFlashcardSubject(flashcard.subject);
      flashcardsBySubject
          .putIfAbsent(subject, () => <TrainingFlashcardDraft>[])
          .add(flashcard);
    }

    final deckEntries = flashcardsBySubject.entries.where((entry) {
      final matchesSearch =
          searchQuery.isEmpty || entry.key.toLowerCase().contains(searchQuery);
      if (!matchesSearch) return false;

      switch (_selectedFilter) {
        case TrainingFlashcardDeckFilter.todos:
          return true;
        case TrainingFlashcardDeckFilter.comImagem:
          return entry.value.any(
            (flashcard) =>
                flashcard.frontImage.trim().isNotEmpty ||
                flashcard.backImage.trim().isNotEmpty,
          );
        case TrainingFlashcardDeckFilter.semImagem:
          return entry.value.every(
            (flashcard) =>
                flashcard.frontImage.trim().isEmpty &&
                flashcard.backImage.trim().isEmpty,
          );
        case TrainingFlashcardDeckFilter.recentes:
          return _flashcards
              .take(6)
              .any(
                (flashcard) =>
                    normalizeTrainingFlashcardSubject(flashcard.subject) ==
                    entry.key,
              );
      }
    }).toList()..sort((a, b) => b.value.length.compareTo(a.value.length));

    return deckEntries;
  }

  Future<void> _openDeck(
    MapEntry<String, List<TrainingFlashcardDraft>> entry,
  ) async {
    final result = await Navigator.of(context)
        .push<TrainingFlashcardDeckSessionResult>(
          MaterialPageRoute(
            builder: (_) => TrainingFlashcardDeckScreen(
              subject: entry.key,
              flashcards: entry.value,
              initialSessionState: _deckSessionStates[entry.key],
              surfaceContainer: widget.surfaceContainer,
              surfaceContainerHigh: widget.surfaceContainerHigh,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
          ),
        );
    if (result == null || !mounted) return;
    _applyState(() {
      _deckReviewedCounts[result.subject] = result.reviewedCount;
      _deckSessionStates[result.subject] = TrainingFlashcardDeckSessionState(
        currentIndex: result.currentIndex,
        correctCount: result.correctCount,
        wrongCount: result.wrongCount,
      );
    });
  }

  Future<bool> _confirmDeleteDeck(
    MapEntry<String, List<TrainingFlashcardDraft>> entry,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Apagar deck?'),
              content: Text(
                entry.value.length == 1
                    ? 'Este flashcard de ${entry.key} será removido.'
                    : 'Todos os ${entry.value.length} flashcards de ${entry.key} serão removidos.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text('Apagar'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmed) return false;
    try {
      await deleteFlashcardDeck(entry.key);
      return true;
    } catch (error) {
      if (!mounted) return false;
      if (isSubscriptionRequiredError(error)) {
        _applyState(() => _isSubscriptionRequired = true);
        return false;
      }

      showCognixMessage(
        context,
        readableApiErrorMessage(error),
        type: CognixMessageType.error,
      );
      return false;
    }
  }

  void _handleDeckDismissed(
    MapEntry<String, List<TrainingFlashcardDraft>> entry,
  ) {
    final deckSubject = entry.key;
    final removedCount = entry.value.length;
    _deleteDeck(deckSubject);
    showCognixMessage(
      context,
      removedCount == 1
          ? '1 flashcard de $deckSubject removido.'
          : '$removedCount flashcards de $deckSubject removidos.',
      type: CognixMessageType.success,
    );
  }

  void _openSubscription() {
    Navigator.of(context).pushNamed('subscription');
  }
}
