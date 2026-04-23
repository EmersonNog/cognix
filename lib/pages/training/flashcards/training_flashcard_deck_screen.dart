import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../services/flashcards/flashcards_api.dart';
import '../../../services/local/flashcards_tutorial_storage.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import 'training_flashcards_models.dart';
import 'widgets/deck/training_flashcard_deck_progress_header.dart';
import 'widgets/deck/training_flashcard_finished_card.dart';
import 'widgets/deck/training_flashcard_review_swipe_card.dart';
import 'widgets/deck/training_flashcard_swipe_feedback_background.dart';
import 'widgets/deck/training_flashcard_tutorial_card.dart';
import 'widgets/training_flashcard_preview_card.dart';

class TrainingFlashcardDeckScreen extends StatefulWidget {
  const TrainingFlashcardDeckScreen({
    super.key,
    required this.subject,
    required this.flashcards,
    this.initialSessionState,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String subject;
  final List<TrainingFlashcardDraft> flashcards;
  final TrainingFlashcardDeckSessionState? initialSessionState;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingFlashcardDeckScreen> createState() =>
      _TrainingFlashcardDeckScreenState();
}

class _TrainingFlashcardDeckScreenState
    extends State<TrainingFlashcardDeckScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  final GlobalKey _reviewCardKey = GlobalKey();
  final GlobalKey _reviewTapTargetKey = GlobalKey();
  final GlobalKey _correctSwipeTargetKey = GlobalKey();
  final GlobalKey _wrongSwipeTargetKey = GlobalKey();
  TutorialCoachMark? _tutorialCoachMark;
  bool _tutorialChecked = false;
  _SwipeTutorialPreview _tutorialPreview = _SwipeTutorialPreview.none;

  bool get _isFinished => _currentIndex >= widget.flashcards.length;

  double get _progress {
    if (widget.flashcards.isEmpty) return 0.0;
    return _isFinished ? 1.0 : (_currentIndex + 1) / widget.flashcards.length;
  }

  String get _progressLabel {
    if (widget.flashcards.isEmpty) return '0/0';
    final currentValue = _isFinished
        ? widget.flashcards.length
        : _currentIndex + 1;
    return '$currentValue/${widget.flashcards.length}';
  }

  DismissDirection? get _previewDirection {
    return switch (_tutorialPreview) {
      _SwipeTutorialPreview.correct => DismissDirection.startToEnd,
      _SwipeTutorialPreview.wrong => DismissDirection.endToStart,
      _SwipeTutorialPreview.none => null,
    };
  }

  @override
  void initState() {
    super.initState();
    final initialSessionState = widget.initialSessionState;
    if (initialSessionState == null) return;

    _currentIndex = initialSessionState.currentIndex.clamp(
      0,
      widget.flashcards.length,
    );
    _correctCount = initialSessionState.correctCount.clamp(
      0,
      widget.flashcards.length,
    );
    _wrongCount = initialSessionState.wrongCount.clamp(
      0,
      widget.flashcards.length,
    );
  }

  Future<void> _persistDeckState({bool silent = true}) async {
    try {
      await saveFlashcardDeckProgress(
        subject: widget.subject,
        currentIndex: _currentIndex.clamp(0, widget.flashcards.length),
        correctCount: _correctCount,
        wrongCount: _wrongCount,
      );
    } catch (error) {
      if (!mounted || silent) return;
      showCognixMessage(
        context,
        error.toString(),
        type: CognixMessageType.error,
      );
    }
  }

  void _closeDeck() {
    unawaited(_persistDeckState());
    Navigator.of(context).pop(
      TrainingFlashcardDeckSessionResult(
        subject: widget.subject,
        reviewedCount: _currentIndex.clamp(0, widget.flashcards.length),
        currentIndex: _currentIndex.clamp(0, widget.flashcards.length),
        correctCount: _correctCount,
        wrongCount: _wrongCount,
      ),
    );
  }

  void _handleSwipe(DismissDirection direction) {
    setState(() {
      if (direction == DismissDirection.startToEnd) {
        _correctCount += 1;
      } else {
        _wrongCount += 1;
      }
      _currentIndex += 1;
    });
    unawaited(_persistDeckState());
  }

  void _restartSession() {
    setState(() {
      _currentIndex = 0;
      _correctCount = 0;
      _wrongCount = 0;
      _tutorialPreview = _SwipeTutorialPreview.none;
    });
    unawaited(_persistDeckState());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tutorialChecked) return;
    _tutorialChecked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowTutorial();
    });
  }

  Future<void> _maybeShowTutorial() async {
    if (!mounted || widget.flashcards.isEmpty) return;
    final shouldShow =
        await FlashcardsTutorialStorage.shouldShowReviewTutorial();
    final hasSeen = await FlashcardsTutorialStorage.hasSeen();
    if (!mounted || !shouldShow || hasSeen) return;

    _tutorialCoachMark = TutorialCoachMark(
      targets: _buildTutorialTargets(),
      colorShadow: Colors.black,
      opacityShadow: 0.78,
      useSafeArea: true,
      hideSkip: false,
      textSkip: 'Pular',
      paddingFocus: 14,
      beforeFocus: (target) async {
        if (!mounted) return;
        setState(() {
          switch (target.identify) {
            case 'swipe-correct':
              _tutorialPreview = _SwipeTutorialPreview.correct;
              break;
            case 'swipe-wrong':
              _tutorialPreview = _SwipeTutorialPreview.wrong;
              break;
            default:
              _tutorialPreview = _SwipeTutorialPreview.none;
          }
        });
      },
      onFinish: _finishTutorial,
      onSkip: () {
        _finishTutorial();
        return true;
      },
    )..show(context: context);
  }

  List<TargetFocus> _buildTutorialTargets() {
    return <TargetFocus>[
      TargetFocus(
        identify: 'tap-card',
        keyTarget: _reviewTapTargetKey,
        shape: ShapeLightFocus.RRect,
        radius: 18,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const TrainingFlashcardTutorialCard(
                title: 'Clique para ver a resposta',
                description:
                    'Toque no centro do card para virar e visualizar o outro lado.',
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'swipe-correct',
        keyTarget: _correctSwipeTargetKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const TrainingFlashcardTutorialCard(
                title: 'Deslize para a direita',
                description:
                    'Quando acertar, arraste o card para a direita para seguir para o próximo.',
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'swipe-wrong',
        keyTarget: _wrongSwipeTargetKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const TrainingFlashcardTutorialCard(
                title: 'Deslize para a esquerda',
                description:
                    'Quando errar, arraste o card para a esquerda para marcar a resposta e continuar.',
              );
            },
          ),
        ],
      ),
    ];
  }

  void _finishTutorial() {
    if (mounted) {
      setState(() => _tutorialPreview = _SwipeTutorialPreview.none);
    }
    FlashcardsTutorialStorage.markSeen();
  }

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final screenBackgroundColor = isLightMode
        ? Color.alphaBlend(
            widget.primary.withValues(alpha: 0.05),
            Theme.of(context).scaffoldBackgroundColor,
          )
        : Theme.of(context).scaffoldBackgroundColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _closeDeck();
      },
      child: Scaffold(
        backgroundColor: screenBackgroundColor,
        appBar: AppBar(
          backgroundColor: screenBackgroundColor,
          surfaceTintColor: screenBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: _closeDeck,
            icon: Icon(Icons.arrow_back, color: widget.onSurface),
          ),
          title: Text(
            widget.subject,
            style: GoogleFonts.manrope(
              color: widget.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              TrainingFlashcardDeckProgressHeader(
                progressLabel: _progressLabel,
                progress: _progress,
                primary: widget.primary,
                surfaceContainerHigh: widget.surfaceContainerHigh,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: _isFinished
                      ? TrainingFlashcardFinishedCard(
                          correctCount: _correctCount,
                          wrongCount: _wrongCount,
                          surfaceContainer: widget.surfaceContainer,
                          surfaceContainerHigh: widget.surfaceContainerHigh,
                          onSurface: widget.onSurface,
                          onSurfaceMuted: widget.onSurfaceMuted,
                          primary: widget.primary,
                          onReviewAgain: _restartSession,
                        )
                      : TrainingFlashcardReviewSwipeCard(
                          key: ValueKey(
                            'review-${widget.subject}-$_currentIndex',
                          ),
                          onSwiped: _handleSwipe,
                          previewDirection: _previewDirection,
                          leftBackground:
                              TrainingFlashcardSwipeFeedbackBackground(
                                alignment: Alignment.centerLeft,
                                color: const Color(0xFF2FB36D),
                                icon: Icons.check_rounded,
                                label: 'Acertou',
                                focusKey: _correctSwipeTargetKey,
                              ),
                          rightBackground:
                              TrainingFlashcardSwipeFeedbackBackground(
                                alignment: Alignment.centerRight,
                                color: const Color(0xFFE05A5A),
                                icon: Icons.close_rounded,
                                label: 'Errou',
                                focusKey: _wrongSwipeTargetKey,
                              ),
                          child: TrainingFlashcardPreviewCard(
                            key: _reviewCardKey,
                            tapTargetKey: _reviewTapTargetKey,
                            flashcard: widget.flashcards[_currentIndex],
                            surfaceContainer: widget.surfaceContainer,
                            surfaceContainerHigh: widget.surfaceContainerHigh,
                            onSurface: widget.onSurface,
                            onSurfaceMuted: widget.onSurfaceMuted,
                            primary: widget.primary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SwipeTutorialPreview { none, correct, wrong }
