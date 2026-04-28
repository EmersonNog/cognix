import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/core/api_client.dart'
    show isSubscriptionRequiredError;
import '../../../../services/multiplayer/errors.dart';
import '../../../../services/multiplayer/models.dart';
import '../../../../services/multiplayer/requests.dart';
import '../../../../services/multiplayer/sync.dart';
import '../shared/text.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import '../shared/widgets/dialogs.dart';
import '../shared/widgets/room_widgets.dart';
import '../shared/widgets/palette.dart';
import '../shared/widgets/scaffold.dart';
import 'widgets/multiplayer_join_widgets.dart';

part 'screen/actions.dart';
part 'screen/lifecycle.dart';
part 'screen/sync.dart';
part 'screen/view.dart';

const int _joinRoomConnectionGraceSeconds = 60;

class MultiplayerJoinRoomScreen extends StatefulWidget {
  const MultiplayerJoinRoomScreen({super.key});

  @override
  State<MultiplayerJoinRoomScreen> createState() =>
      _MultiplayerJoinRoomScreenState();
}

class _MultiplayerJoinRoomScreenState extends State<MultiplayerJoinRoomScreen> {
  final TextEditingController _pinController = TextEditingController();

  late final MultiplayerRoomSyncSession _roomSync;
  StreamSubscription<MultiplayerRoomSyncEvent>? _roomSubscription;
  StreamSubscription<MultiplayerRoomSyncError>? _roomErrorSubscription;
  StreamSubscription<MultiplayerSyncStatusEvent>? _roomStatusSubscription;
  Timer? _connectionCountdownTimer;

  MultiplayerRoom? _room;
  String? _errorMessage;
  DateTime? _lastReconnectNoticeAt;

  bool _isJoining = false;
  bool _isRefreshing = false;
  bool _isLeaving = false;
  bool _wasRemoved = false;
  bool _handledRemovalRedirect = false;
  bool _handledRoomClosedRedirect = false;
  bool _isOpeningMatch = false;
  bool _isSubscriptionRequired = false;
  bool _connectionInterrupted = false;
  bool _awaitingReconnectConfirmation = false;
  bool _handledConnectionTimeoutRedirect = false;

  int _connectionRemainingSeconds = _joinRoomConnectionGraceSeconds;

  bool get _canJoin => _pinController.text.trim().length == 6 && !_isJoining;

  bool get _shouldShowConnectionOverlay =>
      _room != null && _connectionInterrupted;

  @override
  void initState() {
    super.initState();
    _initJoinRoomScreenState(this);
  }

  @override
  void dispose() {
    _disposeJoinRoomScreenState(this);
    super.dispose();
  }

  void _handleRoomEvent(MultiplayerRoomSyncEvent event) =>
      _handleJoinRoomEvent(this, event);

  void _handleRoomSyncError(MultiplayerRoomSyncError event) =>
      _handleJoinRoomSyncError(this, event);

  void _handleRoomSyncStatus(MultiplayerSyncStatusEvent event) =>
      _handleJoinRoomSyncStatus(this, event);

  void _update(VoidCallback callback) {
    if (!mounted) return;
    setState(callback);
  }

  @override
  Widget build(BuildContext context) => _buildJoinRoomScreen(this, context);
}
