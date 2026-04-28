import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
import 'widgets/multiplayer_create_widgets.dart';

part 'screen/actions.dart';
part 'screen/lifecycle.dart';
part 'screen/sync.dart';
part 'screen/view.dart';

const int _createRoomConnectionGraceSeconds = 60;

class MultiplayerCreateRoomScreen extends StatefulWidget {
  const MultiplayerCreateRoomScreen({super.key});

  @override
  State<MultiplayerCreateRoomScreen> createState() =>
      _MultiplayerCreateRoomScreenState();
}

class _MultiplayerCreateRoomScreenState
    extends State<MultiplayerCreateRoomScreen> {
  late final MultiplayerRoomSyncSession _roomSync;
  StreamSubscription<MultiplayerRoomSyncEvent>? _roomSubscription;
  StreamSubscription<MultiplayerRoomSyncError>? _roomErrorSubscription;
  StreamSubscription<MultiplayerSyncStatusEvent>? _roomStatusSubscription;
  Timer? _connectionCountdownTimer;

  MultiplayerRoom? _room;
  String? _errorMessage;
  DateTime? _lastReconnectNoticeAt;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isStarting = false;
  bool _isClosing = false;
  bool _isOpeningMatch = false;
  bool _isSubscriptionRequired = false;
  bool _connectionInterrupted = false;
  bool _awaitingReconnectConfirmation = false;
  bool _handledConnectionTimeoutRedirect = false;

  int _connectionRemainingSeconds = _createRoomConnectionGraceSeconds;
  final Set<int> _removingParticipantIds = <int>{};

  @override
  void initState() {
    super.initState();
    _initCreateRoomScreenState(this);
  }

  @override
  void dispose() {
    _disposeCreateRoomScreenState(this);
    super.dispose();
  }

  bool get _shouldShowConnectionOverlay => _connectionInterrupted;

  void _handleRoomEvent(MultiplayerRoomSyncEvent event) =>
      _handleCreateRoomEvent(this, event);

  void _handleRoomSyncError(MultiplayerRoomSyncError event) =>
      _handleCreateRoomSyncError(this, event);

  void _handleRoomSyncStatus(MultiplayerSyncStatusEvent event) =>
      _handleCreateRoomSyncStatus(this, event);

  void _update(VoidCallback callback) {
    if (!mounted) return;
    setState(callback);
  }

  @override
  Widget build(BuildContext context) => _buildCreateRoomScreen(this, context);
}
