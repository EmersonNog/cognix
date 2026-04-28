import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/core/api_client.dart'
    show isSubscriptionRequiredError, readableApiErrorMessage;
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
import 'widgets/home/deck_tile/training_flashcards_deck_tile.dart';
import 'widgets/home/training_flashcards_recovered_image_banner.dart';
import 'widgets/training_flashcard_create_sheet.dart';

part 'screen/training_flashcards_screen_actions.dart';
part 'screen/training_flashcards_screen_view.dart';

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
  bool _isSubscriptionRequired = false;

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

  void _applyState(VoidCallback update) {
    if (!mounted) {
      return;
    }
    setState(update);
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return _buildScreenForState(this);
  }
}
