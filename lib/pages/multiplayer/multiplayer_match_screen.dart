import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/multiplayer/multiplayer_api.dart';
import '../../services/questions/questions_api.dart';
import '../training/session/training_session_question_card.dart';
import '../training/widgets/training_answer_option.dart';
import 'widgets/multiplayer_dialogs.dart';
import 'widgets/multiplayer_lobby_widgets.dart';
import 'widgets/multiplayer_palette.dart';
import 'widgets/multiplayer_scaffold.dart';

class MultiplayerMatchScreen extends StatefulWidget {
  const MultiplayerMatchScreen({super.key, this.room});

  final MultiplayerRoom? room;

  @override
  State<MultiplayerMatchScreen> createState() => _MultiplayerMatchScreenState();
}

class _MultiplayerMatchScreenState extends State<MultiplayerMatchScreen> {
  Timer? _refreshTimer;
  Timer? _roundTimer;
  MultiplayerRoom? _room;
  final List<QuestionItem> _questions = <QuestionItem>[];
  int? _selectedAnswerIndex;
  int _questionIndex = 0;
  int _remainingSeconds = 60;
  int _score = 0;
  bool _isRefreshing = false;
  bool _isLeaving = false;
  bool _isLoadingQuestions = true;
  bool _isSubmittingAnswer = false;
  bool _hasSubmittedAnswer = false;
  bool _handledRoomClosedRedirect = false;
  bool _handledRemovalRedirect = false;
  String? _questionsErrorMessage;
  String? _loadedQuestionIdsKey;
  bool? _lastAnswerWasCorrect;
  String? _lastCorrectLetter;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _remainingSeconds = _remainingSecondsForRoom(widget.room);
    if (_room != null) {
      _startPolling();
    }
    _startRoundTimer();
    _loadQuestions();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _roundTimer?.cancel();
    super.dispose();
  }

  bool get _isCurrentUserHost {
    final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
    return _room?.isHostFirebaseUid(firebaseUid) ?? false;
  }

  QuestionItem? get _currentQuestion {
    if (_questions.isEmpty || _questionIndex >= _questions.length) {
      return null;
    }
    return _questions[_questionIndex];
  }

  void _startPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _refreshRoom(),
    );
  }

  void _startRoundTimer() {
    _roundTimer?.cancel();
    _roundTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted ||
          _remainingSeconds <= 0 ||
          _hasSubmittedAnswer ||
          (_room?.isFinished ?? false)) {
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  Future<void> _refreshRoom() async {
    final room = _room;
    if (room == null || _isRefreshing || _isLeaving) {
      return;
    }

    _isRefreshing = true;
    try {
      final updatedRoom = await fetchMultiplayerRoom(room.id);
      if (!mounted) return;

      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final wasRemoved =
          currentUid != null &&
          !updatedRoom.hasParticipantFirebaseUid(currentUid);
      final hostLeft = !updatedRoom.hasParticipantFirebaseUid(
        updatedRoom.hostFirebaseUid,
      );
      final shouldReloadQuestions =
          _questionIdsKey(updatedRoom.questionIds) != _loadedQuestionIdsKey;
      final shouldSyncQuestionIndex =
          updatedRoom.hasMatchQuestions &&
          !updatedRoom.isFinished &&
          updatedRoom.currentQuestionIndex != _questionIndex &&
          updatedRoom.currentQuestionIndex >= 0 &&
          updatedRoom.currentQuestionIndex < _questions.length;

      setState(() {
        _room = updatedRoom;
        _score = _scoreFromRoom(updatedRoom) ?? _score;
        if (updatedRoom.isFinished) {
          _remainingSeconds = 0;
          _hasSubmittedAnswer = true;
        }
        if (shouldSyncQuestionIndex) {
          _questionIndex = updatedRoom.currentQuestionIndex;
          _selectedAnswerIndex = null;
          _hasSubmittedAnswer = false;
          _lastAnswerWasCorrect = null;
          _lastCorrectLetter = null;
          _remainingSeconds = _remainingSecondsForRoom(updatedRoom);
        }
      });
      if (wasRemoved) {
        _handleRemovedFromRoom();
        return;
      }
      if (hostLeft && !updatedRoom.isHostFirebaseUid(currentUid)) {
        _handleRoomClosedByHost();
      }
      if (shouldReloadQuestions) {
        _loadQuestions(roomOverride: updatedRoom);
      }
    } catch (error) {
      if (isMultiplayerNotFoundError(error)) {
        _handleRoomClosedByHost();
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _goHome() async {
    if (_isLeaving) {
      return;
    }

    final shouldLeave = await _confirmLeaveMatch();
    if (!shouldLeave || !mounted) {
      return;
    }

    final room = _room;
    setState(() => _isLeaving = true);

    try {
      if (room != null && !room.isFinished) {
        await leaveMultiplayerRoom(room.id);
      }
    } catch (error) {
      if (!isMultiplayerNotFoundError(error)) {
        _showError(error);
        if (mounted) {
          setState(() => _isLeaving = false);
        }
        return;
      }
    }

    if (!mounted) return;
    _refreshTimer?.cancel();
    Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
  }

  Future<bool> _confirmLeaveMatch() async {
    final room = _room;
    if (room == null || room.isFinished || !room.isInProgress) {
      return true;
    }

    final isHost = _isCurrentUserHost;
    return showMultiplayerLeaveConfirmation(
      context,
      palette: const MultiplayerPalette(),
      title: isHost ? 'Encerrar partida?' : 'Sair da partida?',
      message: isHost
          ? 'Ao sair agora, todos os jogadores serao desconectados desta partida imediatamente.'
          : 'Você vai deixar a partida atual e não poderá continuar desta rodada de onde parou.',
      confirmLabel: isHost ? 'Encerrar agora' : 'Sair agora',
      icon: isHost ? Icons.cancel_schedule_send_rounded : Icons.logout_rounded,
      accentColor: isHost ? const Color(0xFFB42318) : const Color(0xFFF4A261),
      eyebrow: isHost ? 'Afeta toda a sala' : 'Você sairá sozinho.',
      cancelLabel: 'Continuar jogando',
    );
  }

  void _selectAnswer(int index) {
    if (_hasSubmittedAnswer || _isSubmittingAnswer || _remainingSeconds <= 0) {
      return;
    }

    setState(() => _selectedAnswerIndex = index);
  }

  Future<void> _loadQuestions({MultiplayerRoom? roomOverride}) async {
    final sourceRoom = roomOverride ?? _room;
    setState(() {
      _isLoadingQuestions = true;
      _questionsErrorMessage = null;
    });

    try {
      final loadedQuestions = sourceRoom?.hasMatchQuestions == true
          ? await _loadQuestionsByRoomIds(sourceRoom!)
          : await _loadFallbackQuestions();

      if (!mounted) return;
      setState(() {
        _questions
          ..clear()
          ..addAll(loadedQuestions);
        _questionIndex = _initialQuestionIndex(sourceRoom, loadedQuestions);
        _selectedAnswerIndex = null;
        _hasSubmittedAnswer = false;
        _lastAnswerWasCorrect = null;
        _lastCorrectLetter = null;
        _remainingSeconds = _remainingSecondsForRoom(sourceRoom);
        _score = sourceRoom == null ? 0 : _scoreFromRoom(sourceRoom) ?? _score;
        _loadedQuestionIdsKey = _questionIdsKey(sourceRoom?.questionIds);
        _isLoadingQuestions = false;
        if (_questions.isEmpty) {
          _questionsErrorMessage = 'Não encontrei questões disponíveis.';
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _questionsErrorMessage = humanizeMultiplayerError(
          error,
          fallback: 'Não consegui carregar as questões da partida.',
        );
        _isLoadingQuestions = false;
      });
    }
  }

  Future<List<QuestionItem>> _loadQuestionsByRoomIds(
    MultiplayerRoom room,
  ) async {
    final questionsById = <int, QuestionItem>{
      for (final question in await fetchQuestionsByIds(room.questionIds))
        question.id: question,
    };

    return [
      for (final id in room.questionIds)
        if (questionsById[id] != null) questionsById[id]!,
    ];
  }

  Future<List<QuestionItem>> _loadFallbackQuestions() async {
    final disciplines = await fetchDisciplines();

    for (final discipline in disciplines) {
      final subcategories = await fetchSubcategories(discipline);
      for (final subcategory in subcategories) {
        if (subcategory.total <= 0) {
          continue;
        }
        final page = await fetchQuestionsPageBySubcategory(
          discipline: discipline,
          subcategory: subcategory.name,
          limit: 10,
        );
        if (page.items.isNotEmpty) {
          return page.items;
        }
      }
    }

    return const <QuestionItem>[];
  }

  int _initialQuestionIndex(
    MultiplayerRoom? room,
    List<QuestionItem> loadedQuestions,
  ) {
    final index = room?.hasMatchQuestions == true
        ? room!.currentQuestionIndex
        : 0;
    if (loadedQuestions.isEmpty || index < 0) {
      return 0;
    }
    return index.clamp(0, loadedQuestions.length - 1);
  }

  Future<void> _submitAnswer() async {
    final question = _currentQuestion;
    final selectedIndex = _selectedAnswerIndex;
    if (question == null ||
        selectedIndex == null ||
        _hasSubmittedAnswer ||
        _isSubmittingAnswer) {
      return;
    }

    final selectedAlternative = question.alternatives[selectedIndex];
    setState(() => _isSubmittingAnswer = true);
    try {
      final room = _room;
      final usesSyncedQuestions = room?.hasMatchQuestions == true;
      final bool? wasCorrect;
      final String? correctLetter;
      final int? score;

      if (usesSyncedQuestions) {
        final result = await submitMultiplayerAnswer(
          roomId: room!.id,
          questionId: question.id,
          selectedLetter: selectedAlternative.letter,
        );
        wasCorrect = result.isCorrect;
        correctLetter = result.correctLetter;
        score = result.score;
        if (mounted) {
          setState(() {
            _room = result.room;
            _score = result.score ?? _scoreFromRoom(result.room) ?? _score;
          });
        }
      } else {
        final attempt = await submitAttempt(
          questionId: question.id,
          selectedLetter: selectedAlternative.letter,
          discipline: question.discipline,
          subcategory: question.subcategory,
        );
        wasCorrect = attempt.isCorrect;
        correctLetter = attempt.correctLetter;
        score = null;
      }

      if (!mounted) return;
      setState(() {
        _lastAnswerWasCorrect = wasCorrect;
        _lastCorrectLetter = correctLetter;
        _hasSubmittedAnswer = true;
        if (score != null) {
          _score = score;
        } else if (!usesSyncedQuestions && wasCorrect == true) {
          _score += 100;
        }
      });
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isSubmittingAnswer = false);
      }
    }
  }

  void _goToNextQuestion() {
    if (!_hasSubmittedAnswer || _questionIndex >= _questions.length - 1) {
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedAnswerIndex = null;
      _hasSubmittedAnswer = false;
      _lastAnswerWasCorrect = null;
      _lastCorrectLetter = null;
      _remainingSeconds = 60;
    });
  }

  void _handleRemovedFromRoom() {
    if (_handledRemovalRedirect || !mounted) {
      return;
    }

    _handledRemovalRedirect = true;
    _refreshTimer?.cancel();
    _notifyAndGoHome(
      message: 'Você foi removido da partida.',
      backgroundColor: const Color(0xFFB42318),
    );
  }

  void _handleRoomClosedByHost() {
    if (_handledRoomClosedRedirect || !mounted || _isCurrentUserHost) {
      return;
    }

    _handledRoomClosedRedirect = true;
    _refreshTimer?.cancel();
    _notifyAndGoHome(
      message: 'O criador encerrou a partida.',
      backgroundColor: const Color(0xFFB42318),
    );
  }

  void _notifyAndGoHome({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    });
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(humanizeMultiplayerError(error))));
  }

  @override
  Widget build(BuildContext context) {
    const palette = MultiplayerPalette();
    final currentRoom = _room;
    final currentQuestion = _currentQuestion;
    final usesSyncedQuestions = currentRoom?.hasMatchQuestions == true;
    final isFinished = currentRoom?.isFinished == true;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _goHome();
      },
      child: Scaffold(
        backgroundColor: palette.surface,
        body: MultiplayerScaffold(
          title: isFinished ? 'Fim da partida' : 'Partida iniciada',
          subtitle: isFinished
              ? 'Confira o ranking final da sala.'
              : 'Responda antes do tempo acabar e acompanhe a rodada.',
          leadingIcon: isFinished
              ? Icons.emoji_events_rounded
              : Icons.bolt_rounded,
          palette: palette,
          onBack: () {
            _goHome();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _MatchHeader(
                palette: palette,
                room: currentRoom,
                questionIndex: _questionIndex,
                totalQuestions: _questions.length,
                remainingSeconds: _remainingSeconds,
                score: _score,
              ),
              const SizedBox(height: 16),
              if (isFinished && currentRoom != null)
                _MatchFinishedPanel(palette: palette, room: currentRoom)
              else if (_isLoadingQuestions)
                _MatchLoadingPanel(palette: palette)
              else if (_questionsErrorMessage != null ||
                  currentQuestion == null)
                _MatchErrorPanel(
                  palette: palette,
                  message:
                      _questionsErrorMessage ??
                      'Não há questão carregada para esta rodada.',
                  onRetry: () {
                    _loadQuestions();
                  },
                )
              else
                _MatchQuestionPanel(
                  palette: palette,
                  question: currentQuestion,
                  selectedAnswerIndex: _selectedAnswerIndex,
                  hasSubmittedAnswer: _hasSubmittedAnswer,
                  lastAnswerWasCorrect: _lastAnswerWasCorrect,
                  correctLetter: _lastCorrectLetter,
                  onSelectAnswer: _selectAnswer,
                ),
              if (currentRoom != null && !isFinished) ...[
                const SizedBox(height: 16),
                _MatchParticipantsPanel(palette: palette, room: currentRoom),
              ],
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: isFinished
                    ? () {
                        _goHome();
                      }
                    : _buttonAction(
                        hasQuestion: currentQuestion != null,
                        isLastQuestion: _questionIndex >= _questions.length - 1,
                        usesSyncedQuestions: usesSyncedQuestions,
                      ),
                style: FilledButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: palette.surface,
                  disabledBackgroundColor: palette.surfaceContainerHigh,
                  disabledForegroundColor: palette.onSurfaceMuted,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  isFinished
                      ? Icons.home_rounded
                      : _hasSubmittedAnswer
                      ? Icons.arrow_forward_rounded
                      : Icons.send_rounded,
                ),
                label: Text(
                  isFinished
                      ? 'Voltar para o inicio'
                      : _buttonLabel(
                          isLastQuestion:
                              _questionIndex >= _questions.length - 1,
                          usesSyncedQuestions: usesSyncedQuestions,
                        ),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? _buttonAction({
    required bool hasQuestion,
    required bool isLastQuestion,
    required bool usesSyncedQuestions,
  }) {
    if (!hasQuestion || _isLoadingQuestions || _isSubmittingAnswer) {
      return null;
    }
    if (_hasSubmittedAnswer) {
      if (usesSyncedQuestions) {
        return null;
      }
      return isLastQuestion ? null : _goToNextQuestion;
    }
    if (_selectedAnswerIndex == null || _remainingSeconds <= 0) {
      return null;
    }
    return () {
      _submitAnswer();
    };
  }

  String _buttonLabel({
    required bool isLastQuestion,
    required bool usesSyncedQuestions,
  }) {
    if (_isSubmittingAnswer) {
      return 'Enviando...';
    }
    if (_hasSubmittedAnswer) {
      if (usesSyncedQuestions) {
        return 'Aguardando rodada';
      }
      return isLastQuestion ? 'Fim das questões' : 'Próxima questão';
    }
    return 'Enviar resposta';
  }

  String? _questionIdsKey(List<int>? questionIds) {
    if (questionIds == null || questionIds.isEmpty) {
      return null;
    }
    return questionIds.join(',');
  }

  int? _scoreFromRoom(MultiplayerRoom room) {
    final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
    if (firebaseUid == null || firebaseUid.trim().isEmpty) {
      return null;
    }

    for (final participant in room.participants) {
      if (participant.firebaseUid == firebaseUid) {
        return participant.score;
      }
    }
    return null;
  }

  int _remainingSecondsForRoom(MultiplayerRoom? room) {
    if (room == null || room.roundStartedAt == null) {
      return room?.roundDurationSeconds ?? 60;
    }

    final elapsed = DateTime.now()
        .toUtc()
        .difference(room.roundStartedAt!.toUtc())
        .inSeconds;
    return (room.roundDurationSeconds - elapsed).clamp(
      0,
      room.roundDurationSeconds,
    );
  }
}

class _MatchHeader extends StatelessWidget {
  const _MatchHeader({
    required this.palette,
    required this.room,
    required this.questionIndex,
    required this.totalQuestions,
    required this.remainingSeconds,
    required this.score,
  });

  final MultiplayerPalette palette;
  final MultiplayerRoom? room;
  final int questionIndex;
  final int totalQuestions;
  final int remainingSeconds;
  final int score;

  @override
  Widget build(BuildContext context) {
    final currentRoom = room;
    final participantCount = currentRoom?.participantCount ?? 0;
    final roundLabel = totalQuestions == 0
        ? 'Carregando questões'
        : 'Rodada ${questionIndex + 1} de $totalQuestions';

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roundLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: palette.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Questão da partida',
                      style: GoogleFonts.manrope(
                        color: palette.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              _MatchTimerBadge(
                palette: palette,
                remainingSeconds: remainingSeconds,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MatchHudChip(
                palette: palette,
                icon: Icons.groups_2_rounded,
                label: participantCount == 0
                    ? 'Jogadores'
                    : '$participantCount jogador${participantCount == 1 ? '' : 'es'}',
              ),
              const SizedBox(width: 8),
              _MatchHudChip(
                palette: palette,
                icon: Icons.leaderboard_rounded,
                label: '$score pts',
              ),
              if (currentRoom != null) ...[
                const SizedBox(width: 8),
                _MatchHudChip(
                  palette: palette,
                  icon: Icons.tag_rounded,
                  label: currentRoom.pin,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchTimerBadge extends StatelessWidget {
  const _MatchTimerBadge({
    required this.palette,
    required this.remainingSeconds,
  });

  final MultiplayerPalette palette;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final isEnding = remainingSeconds <= 10;
    final color = isEnding ? palette.secondary : palette.primary;

    return Container(
      width: 78,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Column(
        children: [
          Icon(Icons.timer_rounded, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '${remainingSeconds}s',
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchHudChip extends StatelessWidget {
  const _MatchHudChip({
    required this.palette,
    required this.icon,
    required this.label,
  });

  final MultiplayerPalette palette;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: palette.onSurfaceMuted, size: 15),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: palette.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchQuestionPanel extends StatelessWidget {
  const _MatchQuestionPanel({
    required this.palette,
    required this.question,
    required this.selectedAnswerIndex,
    required this.hasSubmittedAnswer,
    required this.lastAnswerWasCorrect,
    required this.correctLetter,
    required this.onSelectAnswer,
  });

  final MultiplayerPalette palette;
  final QuestionItem question;
  final int? selectedAnswerIndex;
  final bool hasSubmittedAnswer;
  final bool? lastAnswerWasCorrect;
  final String? correctLetter;
  final ValueChanged<int> onSelectAnswer;

  @override
  Widget build(BuildContext context) {
    final correctOptionIndex = _correctOptionIndex();

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrainingSessionQuestionCard(
            discipline: question.discipline,
            statement: question.statement,
            alternativesIntroduction: question.alternativesIntroduction,
            surfaceContainer: palette.surfaceContainerHigh,
            onSurface: palette.onSurface,
            onSurfaceMuted: palette.onSurfaceMuted,
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < question.alternatives.length; i++) ...[
            Builder(
              builder: (context) {
                final alternative = question.alternatives[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: hasSubmittedAnswer ? null : () => onSelectAnswer(i),
                  child: TrainingAnswerOption(
                    letter: alternative.letter,
                    text: alternative.text,
                    attachmentUrl: alternative.fileUrl,
                    attachmentLabel: _attachmentLabel(alternative.fileUrl),
                    surfaceContainer: palette.surfaceContainer,
                    surfaceContainerHigh: palette.surfaceContainerHigh,
                    onSurfaceMuted: palette.onSurfaceMuted,
                    onSurface: palette.onSurface,
                    primary: palette.primary,
                    selected: selectedAnswerIndex == i,
                    isDisabled: hasSubmittedAnswer,
                    showSelectedCorrect:
                        hasSubmittedAnswer &&
                        selectedAnswerIndex == i &&
                        lastAnswerWasCorrect == true,
                    showSelectedIncorrect:
                        hasSubmittedAnswer &&
                        selectedAnswerIndex == i &&
                        lastAnswerWasCorrect == false,
                    showCorrectReveal:
                        hasSubmittedAnswer &&
                        lastAnswerWasCorrect == false &&
                        correctOptionIndex == i,
                  ),
                );
              },
            ),
            if (i < question.alternatives.length - 1)
              const SizedBox(height: 10),
          ],
          if (hasSubmittedAnswer) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.lock_rounded, color: palette.primary, size: 17),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _feedbackMessage(lastAnswerWasCorrect),
                    style: GoogleFonts.inter(
                      color: palette.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int? _correctOptionIndex() {
    final resolvedCorrectLetter = correctLetter ?? question.answerKey;
    final normalized = resolvedCorrectLetter?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return question.alternatives.indexWhere(
      (item) => item.letter.trim().toUpperCase() == normalized,
    );
  }

  String _feedbackMessage(bool? wasCorrect) {
    if (wasCorrect == true) {
      return 'Resposta correta. Aguarde a próxima rodada.';
    }
    if (wasCorrect == false) {
      return 'Resposta registrada. Confira a alternativa correta e avance.';
    }
    return 'Resposta registrada. Aguarde os outros jogadores.';
  }

  String? _attachmentLabel(String? fileUrl) {
    final value = fileUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return value;
  }
}

class _MatchLoadingPanel extends StatelessWidget {
  const _MatchLoadingPanel({required this.palette});

  final MultiplayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircularProgressIndicator(color: palette.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Carregando questões da partida...',
              style: GoogleFonts.inter(
                color: palette.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchFinishedPanel extends StatelessWidget {
  const _MatchFinishedPanel({required this.palette, required this.room});

  final MultiplayerPalette palette;
  final MultiplayerRoom room;

  @override
  Widget build(BuildContext context) {
    final ranking = [...room.participants]
      ..sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;
        final correctCompare = b.correctAnswers.compareTo(a.correctAnswers);
        if (correctCompare != 0) return correctCompare;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    final winner = ranking.isEmpty ? null : ranking.first;

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: palette.secondary.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: palette.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      winner == null
                          ? 'Partida encerrada'
                          : 'Vitória de ${winner.name}',
                      style: GoogleFonts.manrope(
                        color: palette.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${room.questionIds.length} rodada${room.questionIds.length == 1 ? '' : 's'} concluida${room.questionIds.length == 1 ? '' : 's'}',
                      style: GoogleFonts.inter(
                        color: palette.onSurfaceMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ranking final',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < ranking.length; i++) ...[
            _RankingTile(
              palette: palette,
              participant: ranking[i],
              position: i + 1,
            ),
            if (i < ranking.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _RankingTile extends StatelessWidget {
  const _RankingTile({
    required this.palette,
    required this.participant,
    required this.position,
  });

  final MultiplayerPalette palette;
  final MultiplayerParticipant participant;
  final int position;

  @override
  Widget build(BuildContext context) {
    final isTopThree = position <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: isTopThree
            ? palette.primary.withValues(alpha: 0.12)
            : palette.surfaceContainerHigh.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTopThree
              ? palette.primary.withValues(alpha: 0.24)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isTopThree
                  ? palette.secondary.withValues(alpha: 0.18)
                  : palette.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '#$position',
                style: GoogleFonts.plusJakartaSans(
                  color: isTopThree
                      ? palette.secondary
                      : palette.onSurfaceMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${participant.correctAnswers} acerto${participant.correctAnswers == 1 ? '' : 's'}',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${participant.score} pts',
            style: GoogleFonts.plusJakartaSans(
              color: palette.primary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchErrorPanel extends StatelessWidget {
  const _MatchErrorPanel({
    required this.palette,
    required this.message,
    required this.onRetry,
  });

  final MultiplayerPalette palette;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Não foi possivel carregar a rodada',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _MatchParticipantsPanel extends StatelessWidget {
  const _MatchParticipantsPanel({required this.palette, required this.room});

  final MultiplayerPalette palette;
  final MultiplayerRoom room;

  @override
  Widget build(BuildContext context) {
    final participants = room.participants;

    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jogadores na partida',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (final participant in participants.take(4)) ...[
            MultiplayerParticipantTile(
              participant: participant,
              palette: palette,
            ),
            const SizedBox(height: 8),
          ],
          if (participants.length > 4)
            Text(
              '+${participants.length - 4} jogador${participants.length - 4 == 1 ? '' : 'es'}',
              style: GoogleFonts.inter(
                color: palette.onSurfaceMuted,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
