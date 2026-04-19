import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/multiplayer/errors.dart';
import '../../../../services/multiplayer/models.dart';
import '../../../../services/multiplayer/requests.dart';
import '../../../../services/multiplayer/sync.dart';
import '../../../services/questions/questions_api.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import '../shared/text.dart';
import '../shared/widgets/dialogs.dart';
import '../shared/widgets/room_widgets.dart';
import 'widgets/multiplayer_match_panels.dart';
import '../shared/widgets/palette.dart';
import '../shared/widgets/scaffold.dart';

part 'screen/actions.dart';
part 'screen/lifecycle.dart';
part 'screen/sync.dart';
part 'screen/view.dart';

const Duration _matchHeartbeatInterval = Duration(seconds: 5);
const Duration _matchHeartbeatTimeout = Duration(seconds: 12);
const Duration _matchReconnectDelay = Duration(seconds: 2);
const Duration _matchPollingInterval = Duration(seconds: 1);
const int _connectionGraceSeconds = 60;

class MultiplayerMatchScreen extends StatefulWidget {
  const MultiplayerMatchScreen({super.key, this.room});

  final MultiplayerRoom? room;

  @override
  State<MultiplayerMatchScreen> createState() => _MultiplayerMatchScreenState();
}

class _MultiplayerMatchScreenState extends State<MultiplayerMatchScreen> {
  Timer? _roundTimer;
  Timer? _connectionCountdownTimer;
  late final MultiplayerRoomSyncSession _roomSync;
  StreamSubscription<MultiplayerRoomSyncEvent>? _roomSubscription;
  StreamSubscription<MultiplayerRoomSyncError>? _roomErrorSubscription;
  StreamSubscription<MultiplayerSyncStatusEvent>? _roomStatusSubscription;

  MultiplayerRoom? _room;
  final List<QuestionItem> _questions = <QuestionItem>[];
  int? _selectedAnswerIndex;
  int _questionIndex = 0;
  int _remainingSeconds = 60;
  int _score = 0;
  int _connectionRemainingSeconds = _connectionGraceSeconds;

  bool _isLeaving = false;
  bool _isLoadingQuestions = true;
  bool _isSubmittingAnswer = false;
  bool _hasSubmittedAnswer = false;
  bool _handledRoomClosedRedirect = false;
  bool _handledRemovalRedirect = false;
  bool _connectionInterrupted = false;
  bool _awaitingReconnectConfirmation = false;
  bool _handledConnectionTimeoutRedirect = false;
  bool _isResolvingRoundTimeout = false;

  DateTime? _lastTimeoutSyncAttemptAt;
  DateTime? _lastReconnectNoticeAt;

  String? _questionsErrorMessage;
  String? _loadedQuestionIdsKey;
  String? _lastCorrectLetter;
  bool? _lastAnswerWasCorrect;

  @override
  void initState() {
    super.initState();
    _initMatchScreenState(this);
  }

  @override
  void dispose() {
    _disposeMatchScreenState(this);
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

  bool get _shouldShowConnectionOverlay =>
      !_isLeaving && (_room?.isFinished != true) && _connectionInterrupted;

  void _handleRoomEvent(MultiplayerRoomSyncEvent event) =>
      _handleMatchRoomEvent(this, event);
  void _handleRoomSyncError(MultiplayerRoomSyncError event) =>
      _handleMatchRoomSyncError(this, event);
  void _handleRoomSyncStatus(MultiplayerSyncStatusEvent event) =>
      _handleMatchRoomSyncStatus(this, event);

  void _update(VoidCallback callback) {
    if (!mounted) return;
    setState(callback);
  }

  @override
  Widget build(BuildContext context) =>
      _buildMultiplayerMatchScreen(this, context);
}
