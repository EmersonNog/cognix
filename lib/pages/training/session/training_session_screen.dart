import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/cognix/cognix_messages.dart';
import '../../../services/questions/questions_api.dart';
import 'training_session_question_loader.dart';
import '../results/training_results_screen.dart';
import 'training_session_models.dart';
import 'training_session_state_codec.dart';
import 'training_session_storage.dart';
import 'training_session_body.dart';
import 'training_session_feedback.dart';

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
  int? _totalAvailable;
  int _offset = 0;
  final int _pageSize = 20;
  bool _loadingMore = false;
  int _currentIndex = 0;
  final Map<int, int> _selections = {};
  final Map<int, String> _lastSubmittedLetterByQuestionId = {};
  final Map<int, bool?> _isCorrectByQuestionId = {};
  bool _submitting = false;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  bool _paused = false;
  Duration _elapsedOffset = Duration.zero;
  int _lastSavedSecond = -1;
  DateTime? _lastRemoteSyncAt;
  bool _restoringSession = false;
  bool _restoredNoticeShown = false;
  TrainingCompletedSessionResult? _completedSessionResult;
  bool _sessionCompleted = false;

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

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        backgroundColor: const Color(0xFF060E20),
        appBar: AppBar(
          backgroundColor: widget.surfaceContainerHigh,
          elevation: 0,
          iconTheme: IconThemeData(color: widget.onSurface),
          leading: BackButton(
            color: widget.onSurface,
            onPressed: () async {
              final shouldPop = await _handleBackNavigation();
              if (!mounted || !shouldPop) return;
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.title,
            style: GoogleFonts.manrope(
              color: widget.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
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

          final questions = _questions;
          if (questions.isEmpty) {
            return TrainingSessionMessageState(
              message: 'Nenhuma questão encontrada para esta subcategoria.',
              onSurfaceMuted: widget.onSurfaceMuted,
            );
          }

          final index = _currentIndex.clamp(0, questions.length - 1);
          final question = questions[index];
          final selectedIndex = _selections[question.id];
          return TrainingSessionBody(
            subcategory: widget.subcategory,
            discipline: widget.discipline,
            question: question,
            currentIndex: index,
            totalQuestions: _totalAvailable ?? questions.length,
            selectedIndex: selectedIndex,
            hasMore: _hasMoreQuestions(),
            isLoadingMore: _loadingMore,
            isSubmitting: _submitting,
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
              visibleQuestionsCount: questions.length,
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

  Future<void> _loadInitialQuestions() async {
    final batch = await loadInitialTrainingQuestions(
      discipline: widget.discipline,
      subcategory: widget.subcategory,
      pageSize: _pageSize,
    );
    _totalAvailable = batch.total;
    _offset = batch.nextOffset;
    _questions
      ..clear()
      ..addAll(batch.items);
    _loadedIds
      ..clear()
      ..addAll(batch.items.map((e) => e.id));
  }

  Future<void> _loadMoreQuestions() async {
    if (_loadingMore) return;
    if (!_hasMoreQuestions()) return;
    setState(() => _loadingMore = true);
    try {
      final batch = await loadMoreTrainingQuestions(
        discipline: widget.discipline,
        subcategory: widget.subcategory,
        pageSize: _pageSize,
        offset: _offset,
        loadedIds: _loadedIds,
      );
      _totalAvailable ??= batch.total;
      _offset = batch.nextOffset;

      if (batch.items.isNotEmpty) {
        setState(() {
          _questions.addAll(batch.items);
          _loadedIds.addAll(batch.items.map((e) => e.id));
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loadingMore = false);
      }
    }
  }

  bool _hasMoreQuestions() {
    if (_totalAvailable == null) {
      return false;
    }
    return _questions.length < _totalAvailable!;
  }

  void _maybePrefetch() {
    if (_loadingMore) return;
    if (!_hasMoreQuestions()) return;
    final triggerIndex = _questions.length - 3;
    if (_currentIndex >= triggerIndex) {
      _loadMoreQuestions().catchError((_) {});
    }
  }

  void _startTimer() {
    if (!_paused) {
      _stopwatch.start();
    }
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (!_stopwatch.isRunning) return;
      final seconds = _currentElapsed().inSeconds;
      if (seconds != _lastSavedSecond && seconds % 5 == 0) {
        _lastSavedSecond = seconds;
        _saveSessionState();
      }
      setState(() {});
    });
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
      if (_paused) {
        _elapsedOffset += _stopwatch.elapsed;
        _stopwatch
          ..stop()
          ..reset();
      } else {
        _stopwatch.start();
      }
    });
    _saveSessionState();
  }

  String _formatElapsed(Duration elapsed) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = elapsed.inHours;
    if (hours > 0) {
      final hh = hours.toString().padLeft(2, '0');
      return '$hh:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _finishSession({required int totalQuestionsLoaded}) async {
    _stopwatch.stop();
    _ticker?.cancel();
    _sessionCompleted = true;

    final answered = _isCorrectByQuestionId.values
        .where((v) => v != null)
        .length;
    final correct = _isCorrectByQuestionId.values
        .where((v) => v == true)
        .length;
    final wrong = _isCorrectByQuestionId.values.where((v) => v == false).length;
    final totalQuestions = _totalAvailable ?? totalQuestionsLoaded;
    final elapsed = _currentElapsed();
    final result = buildCompletedTrainingSessionResult(
      totalQuestions: totalQuestions,
      answeredQuestions: answered,
      correctAnswers: correct,
      wrongAnswers: wrong,
      elapsedSeconds: elapsed.inSeconds,
    );

    await _saveCompletedSessionState(result);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TrainingResultsScreen(
          discipline: widget.discipline,
          subcategory: widget.subcategory,
          totalQuestions: result.totalQuestions,
          answeredQuestions: result.answeredQuestions,
          correctAnswers: result.correctAnswers,
          wrongAnswers: result.wrongAnswers,
          elapsed: Duration(seconds: result.elapsedSeconds),
        ),
      ),
    );
  }

  Duration _currentElapsed() {
    return _elapsedOffset + _stopwatch.elapsed;
  }

  Future<void> _restoreOrLoad() async {
    try {
      final restored = await _restoreSessionState();
      if (_completedSessionResult != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _completedSessionResult == null) return;
          final result = _completedSessionResult!;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => TrainingResultsScreen(
                discipline: widget.discipline,
                subcategory: widget.subcategory,
                totalQuestions: result.totalQuestions,
                answeredQuestions: result.answeredQuestions,
                correctAnswers: result.correctAnswers,
                wrongAnswers: result.wrongAnswers,
                elapsed: Duration(seconds: result.elapsedSeconds),
              ),
            ),
          );
        });
        return;
      }
      if (!restored) {
        await _loadInitialQuestions();
      }
      _startTimer();
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCognixMessage(
          context,
          error.toString(),
          type: CognixMessageType.error,
        );
      });
      rethrow;
    }
  }

  Map<String, dynamic> _buildSessionPayload({required bool includeQuestions}) {
    return buildTrainingSessionPayload(
      discipline: widget.discipline,
      subcategory: widget.subcategory,
      currentIndex: _currentIndex,
      questions: _questions,
      selections: _selections,
      lastSubmittedByQuestionId: _lastSubmittedLetterByQuestionId,
      isCorrectByQuestionId: _isCorrectByQuestionId,
      elapsedSeconds: _currentElapsed().inSeconds,
      paused: _paused,
      totalAvailable: _totalAvailable,
      offset: _offset,
      includeQuestions: includeQuestions,
    );
  }

  Future<void> _saveSessionState() async {
    if (!mounted) return;
    if (_questions.isEmpty) return;
    if (_sessionCompleted) return;
    final payload = _buildSessionPayload(includeQuestions: true);
    await writeLocalTrainingSessionState(_sessionStateKey, payload);
    _maybeSyncRemote();
  }

  Future<bool> _handleBackNavigation() async {
    await _persistSessionImmediately();
    return true;
  }

  Future<void> _persistSessionImmediately() async {
    if (_questions.isEmpty || _completedSessionResult != null || _sessionCompleted) {
      return;
    }
    final payload = _buildSessionPayload(includeQuestions: true);
    await writeLocalTrainingSessionState(_sessionStateKey, payload);
    try {
      await saveRemoteTrainingSessionState(
        discipline: widget.discipline,
        subcategory: widget.subcategory,
        payload: _buildSessionPayload(includeQuestions: false),
      );
      _lastRemoteSyncAt = DateTime.now();
    } catch (_) {}
  }

  Future<void> _saveCompletedSessionState(
    TrainingCompletedSessionResult result,
  ) async {
    final payload = buildCompletedTrainingSessionPayload(
      discipline: widget.discipline,
      subcategory: widget.subcategory,
      result: result,
    );
    await writeLocalTrainingSessionState(_sessionStateKey, payload);
    try {
      await saveRemoteTrainingSessionState(
        discipline: widget.discipline,
        subcategory: widget.subcategory,
        payload: payload,
      );
    } catch (_) {}
  }

  Future<bool> _restoreSessionState() async {
    TrainingSessionRestoreOutcome? outcome;
    try {
      if (mounted) {
        setState(() => _restoringSession = true);
      }
      outcome = await restoreTrainingSessionSnapshot(
        sessionKey: _sessionStateKey,
        discipline: widget.discipline,
        subcategory: widget.subcategory,
      );
    } finally {
      if (mounted) {
        setState(() => _restoringSession = false);
      }
    }

    if (outcome == null) {
      return false;
    }

    if (outcome.completedResult != null) {
      _completedSessionResult = outcome.completedResult;
      return true;
    }

    final restoredState = outcome.restoredState;
    if (restoredState == null) {
      return false;
    }

    final applied = _applySessionState(restoredState);
    if (applied) {
      await _saveSessionState();
      _restoredNoticeShown = true;
    }
    return applied;
  }

  bool _applySessionState(Map<String, dynamic> decoded) {
    final restored = parseTrainingRestoredSessionData(
      decoded,
      fallbackSubcategory: widget.subcategory,
      fallbackDiscipline: widget.discipline,
    );
    if (restored == null) {
      return false;
    }

    _questions
      ..clear()
      ..addAll(restored.questions);
    _loadedIds
      ..clear()
      ..addAll(restored.questions.map((e) => e.id));

    _currentIndex = restored.currentIndex;
    _totalAvailable = restored.totalAvailable;
    _offset = restored.offset;

    _selections
      ..clear()
      ..addAll(restored.selections);

    _lastSubmittedLetterByQuestionId
      ..clear()
      ..addAll(restored.lastSubmittedByQuestionId);

    _isCorrectByQuestionId
      ..clear()
      ..addAll(restored.isCorrectByQuestionId);

    _paused = restored.paused;
    _elapsedOffset = Duration(seconds: restored.elapsedSeconds);
    _stopwatch
      ..stop()
      ..reset();
    if (_paused) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }

    return true;
  }

  Future<void> _maybeSyncRemote() async {
    final now = DateTime.now();
    if (_lastRemoteSyncAt != null &&
        now.difference(_lastRemoteSyncAt!).inSeconds < 15) {
      return;
    }
    _lastRemoteSyncAt = now;
    try {
      await saveRemoteTrainingSessionState(
        discipline: widget.discipline,
        subcategory: widget.subcategory,
        payload: _buildSessionPayload(includeQuestions: false),
      );
    } catch (_) {}
  }

  Future<void> _handleNextQuestion({
    required QuestionItem question,
    required int visibleQuestionsCount,
  }) async {
    final selectedOptionIndex = _selections[question.id];
    if (selectedOptionIndex == null) return;

    final letter = _optionLetter(selectedOptionIndex);
    final lastSubmitted = _lastSubmittedLetterByQuestionId[question.id];

    if (lastSubmitted == letter) {
      await _advanceAfterAnswer(visibleQuestionsCount);
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await submitAttempt(
        questionId: question.id,
        selectedLetter: letter,
        discipline: widget.discipline,
        subcategory: widget.subcategory,
      );
      _isCorrectByQuestionId[question.id] = result.isCorrect;
      _lastSubmittedLetterByQuestionId[question.id] = letter;
      await _advanceAfterAnswer(visibleQuestionsCount);
      if (!_sessionCompleted) {
        _saveSessionState();
      }
    } catch (_) {
      if (!mounted) return;
      showCognixMessage(
        context,
        'Não foi possível salvar sua resposta. Tente novamente.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _advanceAfterAnswer(int visibleQuestionsCount) async {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex += 1);
      _maybePrefetch();
      _saveSessionState();
      return;
    }

    if (_hasMoreQuestions()) {
      try {
        await _loadMoreQuestions();
      } catch (_) {
        if (!mounted) return;
        showCognixMessage(
          context,
          'Não foi possível carregar mais questões.',
          type: CognixMessageType.error,
        );
        return;
      }

      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() => _currentIndex += 1);
        _maybePrefetch();
        _saveSessionState();
        return;
      }
    }

    if (mounted) {
      await _finishSession(totalQuestionsLoaded: visibleQuestionsCount);
    }
  }

  String _optionLetter(int index) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    if (index >= 0 && index < letters.length) {
      return letters[index];
    }
    return '${index + 1}';
  }
}
