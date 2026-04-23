import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/flashcards/flashcards_api.dart';
import '../../../services/local/flashcards_tutorial_storage.dart';
import '../../../services/media/image_picker_recovery.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import 'training_flashcard_deck_screen.dart';
import 'training_flashcards_models.dart';
import 'widgets/home/training_flashcards_create_action_card.dart';
import 'widgets/home/training_flashcards_deck_delete_background.dart';
import 'widgets/home/training_flashcards_deck_empty_state.dart';
import 'widgets/home/training_flashcards_deck_search_field.dart';
import 'widgets/home/training_flashcards_deck_tile.dart';
import 'widgets/home/training_flashcards_recovered_image_banner.dart';
import 'widgets/training_flashcard_create_sheet.dart';

class TrainingFlashcardsScreen extends StatefulWidget {
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
  State<TrainingFlashcardsScreen> createState() =>
      _TrainingFlashcardsScreenState();
}

class _TrainingFlashcardsScreenState extends State<TrainingFlashcardsScreen> {
  final List<TrainingFlashcardDraft> _flashcards = <TrainingFlashcardDraft>[];
  final List<String> _recoveredImagePaths = <String>[];
  final List<String> _savedSubjects = <String>[];
  final Map<String, int> _deckReviewedCounts = <String, int>{};
  final Map<String, TrainingFlashcardDeckSessionState> _deckSessionStates =
      <String, TrainingFlashcardDeckSessionState>{};
  late final TextEditingController _searchController;

  TrainingFlashcardDeckFilter _selectedFilter =
      TrainingFlashcardDeckFilter.todos;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_refresh);
    _recoveredImagePaths.addAll(
      ImagePickerRecovery.instance.takeRecoveredImagePaths(),
    );
    unawaited(_loadFlashcards());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

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
      if (!mounted) return;
      setState(() {
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
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showCognixMessage(
        context,
        error.toString(),
        type: CognixMessageType.error,
      );
    }
  }

  void _deleteDeck(String subject) {
    setState(() {
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
      setState(() {
        _flashcards.insert(0, TrainingFlashcardDraft.fromApi(saved));
        _recoveredImagePaths.clear();
        _syncSavedSubjects();
      });
    } catch (error) {
      if (!mounted) return;
      showCognixMessage(
        context,
        error.toString(),
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
          return _flashcards.take(6).any(
            (flashcard) =>
                normalizeTrainingFlashcardSubject(flashcard.subject) ==
                entry.key,
          );
      }
    }).toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

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
    setState(() {
      _deckReviewedCounts[result.subject] = result.reviewedCount;
      _deckSessionStates[result.subject] = TrainingFlashcardDeckSessionState(
        currentIndex: result.currentIndex,
        correctCount: result.correctCount,
        wrongCount: result.wrongCount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final deckEntries = _buildDeckEntries();
    final pageBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        surfaceTintColor: pageBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(color: widget.onSurface),
        title: Text(
          'Flashcards',
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: widget.primary))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              children: [
                if (_recoveredImagePaths.isNotEmpty) ...[
                  TrainingFlashcardsRecoveredImageBanner(
                    count: _recoveredImagePaths.length,
                    surfaceContainer: widget.surfaceContainer,
                    surfaceContainerHigh: widget.surfaceContainerHigh,
                    onSurface: widget.onSurface,
                    onSurfaceMuted: widget.onSurfaceMuted,
                  ),
                  const SizedBox(height: 16),
                ],
                TrainingFlashcardsCreateActionCard(
                  surfaceContainer: widget.surfaceContainer,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  primary: widget.primary,
                  totalFlashcards: _flashcards.length,
                  onCreateFlashcard: _openCreateFlashcardSheet,
                ),
                const SizedBox(height: 18),
                Text(
                  'Seus flashcards',
                  style: GoogleFonts.manrope(
                    color: widget.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                TrainingFlashcardsDeckSearchField(
                  controller: _searchController,
                  surfaceContainer: widget.surfaceContainer,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TrainingFlashcardDeckFilter.values.map((filter) {
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(trainingFlashcardDeckFilterLabel(filter)),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedFilter = filter);
                          },
                          labelStyle: GoogleFonts.plusJakartaSans(
                            color: isSelected
                                ? Colors.white
                                : widget.onSurfaceMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          backgroundColor: widget.surfaceContainer,
                          selectedColor: widget.primary,
                          side: BorderSide(
                            color: isSelected
                                ? widget.primary
                                : widget.surfaceContainerHigh.withValues(
                                    alpha: 0.9,
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                if (deckEntries.isEmpty)
                  TrainingFlashcardsDeckEmptyState(
                    surfaceContainer: widget.surfaceContainer,
                    surfaceContainerHigh: widget.surfaceContainerHigh,
                    onSurface: widget.onSurface,
                    onSurfaceMuted: widget.onSurfaceMuted,
                  )
                else
                  for (final entry in deckEntries) ...[
                    Dismissible(
                      key: ValueKey('deck-${entry.key}'),
                      direction: DismissDirection.endToStart,
                      background: TrainingFlashcardsDeckDeleteBackground(
                        surfaceContainerHigh: widget.surfaceContainerHigh,
                      ),
                      confirmDismiss: (_) async {
                        final confirmed =
                            await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text('Apagar deck?'),
                                  content: Text(
                                    entry.value.length == 1
                                        ? 'Este flashcard de ${entry.key} sera removido.'
                                        : 'Todos os ${entry.value.length} flashcards de ${entry.key} serao removidos.',
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
                          showCognixMessage(
                            this.context,
                            error.toString(),
                            type: CognixMessageType.error,
                          );
                          return false;
                        }
                      },
                      onDismissed: (_) {
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
                      },
                      child: TrainingFlashcardsDeckTile(
                        subject: entry.key,
                        flashcards: entry.value,
                        reviewedCount:
                            _deckReviewedCounts[entry.key]?.clamp(
                              0,
                              entry.value.length,
                            ) ??
                            0,
                        surfaceContainer: widget.surfaceContainer,
                        surfaceContainerHigh: widget.surfaceContainerHigh,
                        onSurface: widget.onSurface,
                        primary: widget.primary,
                        onTap: () => _openDeck(entry),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
    );
  }
}
