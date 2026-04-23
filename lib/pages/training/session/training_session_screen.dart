import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/profile/profile_refresh_notifier.dart';
import '../../../services/questions/questions_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import '../results/training_results_screen.dart';
import 'data/training_session_question_loader.dart';
import 'data/training_session_state_codec.dart';
import 'data/training_session_storage.dart';
import 'dialogs/training_question_report_dialog.dart';
import 'models/training_session_models.dart';
import 'widgets/training_session_body.dart';
import 'widgets/training_session_feedback.dart';

part 'state/training_session_screen_loading.dart';
part 'state/training_session_screen_persistence.dart';
part 'state/training_session_screen_progression.dart';
part 'state/training_session_screen_timer.dart';

class TrainingSessionScreen extends StatefulWidget {
  const TrainingSessionScreen({
    super.key,
    required this.title,
    required this.discipline,
    required this.subcategory,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String discipline;
  final String subcategory;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen>
    with WidgetsBindingObserver {
  static const _sessionStateKey = 'training_session_state';

  late final Future<void> _initialLoadFuture;
  final List<QuestionItem> _questions = [];
  final Set<int> _loadedIds = {};
  final Map<int, int> _selections = {};
  final Map<int, String> _lastSubmittedLetterByQuestionId = {};
  final Map<int, bool?> _isCorrectByQuestionId = {};
  final Map<int, int> _correctOptionIndexByQuestionId = {};
  final Stopwatch _stopwatch = Stopwatch();

  int? _totalAvailable;
  int _offset = 0;
  int _currentIndex = 0;
  final int _pageSize = 20;
  int _lastSavedSecond = -1;
  int? _feedbackQuestionId;
  int? _correctOptionIndex;

  bool _loadingMore = false;
  bool _showingAnswerFeedback = false;
  bool? _lastAnswerWasCorrect;
  bool _submitting = false;
  bool _reportingQuestion = false;
  bool _paused = false;
  bool _restoringSession = false;
  bool _restoredNoticeShown = false;
  bool _sessionCompleted = false;

  Timer? _ticker;
  Duration _elapsedOffset = Duration.zero;
  DateTime? _lastRemoteSyncAt;
  TrainingCompletedSessionResult? _completedSessionResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialLoadFuture = _restoreOrLoad();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveSessionState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final pageBackgroundColor = colors.surface;

    if (_restoredNoticeShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCognixMessage(
          context,
          'Simulado restaurado. Continue de onde parou.',
          type: CognixMessageType.success,
        );
        setState(() => _restoredNoticeShown = false);
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _handleBackNavigation();
        if (!mounted || !shouldPop) return;
        navigator.pop();
      },
      child: Scaffold(
        backgroundColor: pageBackgroundColor,
        appBar: AppBar(
          backgroundColor: pageBackgroundColor,
          surfaceTintColor: pageBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: widget.onSurface),
          leading: BackButton(
            color: widget.onSurface,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final shouldPop = await _handleBackNavigation();
              if (!mounted || !shouldPop) return;
              navigator.pop();
            },
          ),
          title: Text(
            widget.title,
            style: GoogleFonts.manrope(
              color: widget.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            if (_currentQuestionForReport() != null)
              IconButton(
                tooltip: 'Reportar questão',
                icon: Icon(Icons.flag_outlined, color: widget.onSurface),
                onPressed: _reportingQuestion
                    ? null
                    : () {
                        final question = _currentQuestionForReport();
                        if (question == null) return;
                        _showReportQuestionDialog(question);
                      },
              ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _initialLoadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const TrainingSessionLoadingState();
            }

            if (_restoringSession) {
              return TrainingSessionRestoringState(
                onSurfaceMuted: widget.onSurfaceMuted,
              );
            }

            if (_completedSessionResult != null) {
              return const TrainingSessionLoadingState();
            }

            if (snapshot.hasError) {
              return TrainingSessionMessageState(
                message: 'Não foi possível carregar as questões.',
                onSurfaceMuted: widget.onSurfaceMuted,
              );
            }

            if (_questions.isEmpty) {
              return TrainingSessionMessageState(
                message: 'Nenhuma questão encontrada para esta disciplina.',
                onSurfaceMuted: widget.onSurfaceMuted,
              );
            }

            final index = _currentIndex.clamp(0, _questions.length - 1);
            final question = _questions[index];
            final selectedIndex = _selections[question.id];
            final isSubmitted =
                selectedIndex != null &&
                _lastSubmittedLetterByQuestionId[question.id] ==
                    _letterForQuestionAlternative(question, selectedIndex);
            final isFreshAnswerFeedback =
                _showingAnswerFeedback && _feedbackQuestionId == question.id;

            return TrainingSessionBody(
              subcategory: widget.subcategory,
              discipline: widget.discipline,
              question: question,
              currentIndex: index,
              totalQuestions: _totalAvailable ?? _questions.length,
              selectedIndex: selectedIndex,
              hasMore: _hasMoreQuestions(),
              isLoadingMore: _loadingMore,
              isSubmitting: _submitting,
              isShowingAnswerFeedback: isFreshAnswerFeedback || isSubmitted,
              isFreshAnswerFeedback: isFreshAnswerFeedback,
              correctOptionIndex: isFreshAnswerFeedback
                  ? _correctOptionIndex
                  : _correctOptionIndexByQuestionId[question.id],
              lastAnswerWasCorrect: isFreshAnswerFeedback
                  ? _lastAnswerWasCorrect
                  : _isCorrectByQuestionId[question.id],
              isPaused: _paused,
              timeLabel: _formatElapsed(_currentElapsed()),
              surfaceContainer: widget.surfaceContainer,
              surfaceContainerHigh: widget.surfaceContainerHigh,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
              onPauseToggle: _togglePause,
              onSelectOption: (selectedOptionIndex) {
                setState(() => _selections[question.id] = selectedOptionIndex);
                _saveSessionState();
              },
              onNext: () => _handleNextQuestion(
                question: question,
                visibleQuestionsCount: _questions.length,
              ),
              onPrevious: () {
                setState(() => _currentIndex -= 1);
                _saveSessionState();
              },
            );
          },
        ),
      ),
    );
  }

  bool _hasMoreQuestions() => _hasMoreQuestionsForState(this);

  void _togglePause() => _togglePauseForState(this);

  String _formatElapsed(Duration elapsed) => _formatElapsedForDuration(elapsed);

  Duration _currentElapsed() => _currentElapsedForState(this);

  Future<void> _restoreOrLoad() => _restoreOrLoadForState(this);

  Future<void> _saveSessionState() => _saveSessionStateForState(this);

  Future<bool> _handleBackNavigation() => _handleBackNavigationForState(this);

  Future<void> _handleNextQuestion({
    required QuestionItem question,
    required int visibleQuestionsCount,
  }) {
    return _handleNextQuestionForState(
      this,
      question: question,
      visibleQuestionsCount: visibleQuestionsCount,
    );
  }

  QuestionItem? _currentQuestionForReport() {
    if (_questions.isEmpty ||
        _restoringSession ||
        _completedSessionResult != null) {
      return null;
    }

    final index = _currentIndex.clamp(0, _questions.length - 1);
    return _questions[index];
  }

  Future<void> _showReportQuestionDialog(QuestionItem question) async {
    if (_reportingQuestion) return;

    final draft = await showTrainingQuestionReportDialog(
      context,
      surfaceContainer: widget.surfaceContainer,
      surfaceContainerHigh: widget.surfaceContainerHigh,
      onSurface: widget.onSurface,
      onSurfaceMuted: widget.onSurfaceMuted,
      primary: widget.primary,
    );
    if (draft == null || !mounted) return;

    setState(() => _reportingQuestion = true);
    try {
      await reportQuestion(
        questionId: question.id,
        reasons: draft.reasons,
        discipline: widget.discipline,
        subcategory: widget.subcategory,
        details: draft.details,
      );
      if (!mounted) return;
      showCognixMessage(
        context,
        'Reporte enviado. Obrigado por ajudar a revisar essa questão.',
        type: CognixMessageType.success,
      );
    } catch (_) {
      if (!mounted) return;
      showCognixMessage(
        context,
        'Não foi possível enviar o reporte agora.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _reportingQuestion = false);
      }
    }
  }

  void _update(VoidCallback action) => setState(action);
}
