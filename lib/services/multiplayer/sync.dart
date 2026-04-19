import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/api_client.dart';
import 'models.dart';
import 'parsers.dart';
import 'requests.dart';

part 'sync/session_commands.dart';
part 'sync/session_emitters.dart';
part 'sync/session_lifecycle.dart';
part 'sync/session_transport.dart';

enum MultiplayerSyncSource { initial, polling, manual, action, websocket }

enum MultiplayerRealtimeStatus {
  idle,
  connecting,
  connected,
  pollingFallback,
  reconnectScheduled,
  disconnected,
}

class MultiplayerRoomSyncEvent {
  const MultiplayerRoomSyncEvent({
    required this.room,
    required this.source,
    required this.receivedAt,
  });

  final MultiplayerRoom room;
  final MultiplayerSyncSource source;
  final DateTime receivedAt;
}

class MultiplayerRoomSyncError {
  const MultiplayerRoomSyncError({
    required this.error,
    required this.source,
    required this.occurredAt,
  });

  final Object error;
  final MultiplayerSyncSource source;
  final DateTime occurredAt;
}

class MultiplayerSyncStatusEvent {
  const MultiplayerSyncStatusEvent({
    required this.status,
    required this.occurredAt,
    this.detail,
    this.error,
  });

  final MultiplayerRealtimeStatus status;
  final DateTime occurredAt;
  final String? detail;
  final Object? error;
}

typedef MultiplayerRoomFetcher = Future<MultiplayerRoom> Function(int roomId);
typedef MultiplayerTokenProvider = Future<String> Function();
typedef MultiplayerChannelFactory = WebSocketChannel Function(Uri uri);

class MultiplayerRoomSyncSession {
  MultiplayerRoomSyncSession({
    MultiplayerRoomFetcher? fetchRoom,
    MultiplayerTokenProvider? tokenProvider,
    MultiplayerChannelFactory? channelFactory,
    Duration heartbeatInterval = const Duration(seconds: 15),
    Duration heartbeatTimeout = const Duration(seconds: 45),
    Duration reconnectDelay = const Duration(seconds: 5),
  }) : _fetchRoom = fetchRoom ?? fetchMultiplayerRoom,
       _tokenProvider = tokenProvider ?? requireAuthToken,
       _channelFactory = channelFactory ?? WebSocketChannel.connect,
       _heartbeatInterval = heartbeatInterval,
       _heartbeatTimeout = heartbeatTimeout,
       _reconnectDelay = reconnectDelay;

  final MultiplayerRoomFetcher _fetchRoom;
  final MultiplayerTokenProvider _tokenProvider;
  final MultiplayerChannelFactory _channelFactory;
  final Duration _heartbeatInterval;
  final Duration _heartbeatTimeout;
  final Duration _reconnectDelay;
  final StreamController<MultiplayerRoomSyncEvent> _events =
      StreamController<MultiplayerRoomSyncEvent>.broadcast();
  final StreamController<MultiplayerRoomSyncError> _errors =
      StreamController<MultiplayerRoomSyncError>.broadcast();
  final StreamController<MultiplayerSyncStatusEvent> _status =
      StreamController<MultiplayerSyncStatusEvent>.broadcast();

  Timer? _pollingTimer;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  StreamSubscription<dynamic>? _webSocketSubscription;
  WebSocketChannel? _webSocketChannel;
  MultiplayerRoom? _room;
  bool _isRefreshing = false;
  bool _isDisposed = false;
  bool _isRealtimeEnabled = false;
  bool _isConnectingWebSocket = false;
  DateTime? _lastSocketActivityAt;
  Duration _pollingInterval = const Duration(seconds: 3);
  MultiplayerRealtimeStatus _currentStatus = MultiplayerRealtimeStatus.idle;
  int _reconnectAttempts = 0;
  int _commandSequence = 0;
  final Map<String, Completer<Map<String, dynamic>>> _pendingCommands =
      <String, Completer<Map<String, dynamic>>>{};

  Stream<MultiplayerRoomSyncEvent> get events => _events.stream;
  Stream<MultiplayerRoomSyncError> get errors => _errors.stream;
  Stream<MultiplayerSyncStatusEvent> get status => _status.stream;
  MultiplayerRoom? get room => _room;
  bool get isRefreshing => _isRefreshing;
  MultiplayerRealtimeStatus get currentStatus => _currentStatus;
  bool get isWebSocketReady =>
      _webSocketChannel != null &&
      _currentStatus == MultiplayerRealtimeStatus.connected;

  void bindRoom(MultiplayerRoom room, {bool emitInitial = true}) {
    _bindRoom(this, room, emitInitial: emitInitial);
  }

  void applyLocalRoom(
    MultiplayerRoom room, {
    MultiplayerSyncSource source = MultiplayerSyncSource.action,
  }) {
    _applyLocalRoom(this, room, source: source);
  }

  Future<MultiplayerRoom?> refresh({
    MultiplayerSyncSource source = MultiplayerSyncSource.manual,
  }) {
    return _refresh(this, source: source);
  }

  Future<MultiplayerRoom?> startMatch() {
    return _startMatch(this);
  }

  Future<MultiplayerRoom?> removeParticipant(int participantId) {
    return _removeParticipant(this, participantId);
  }

  Future<MultiplayerAnswerResult?> submitAnswer({
    required int questionId,
    required String selectedLetter,
  }) {
    return _submitAnswer(
      this,
      questionId: questionId,
      selectedLetter: selectedLetter,
    );
  }

  Future<Map<String, dynamic>?> leaveRoom() {
    return _leaveRoom(this);
  }

  void startPolling({Duration interval = const Duration(seconds: 3)}) {
    _startPolling(this, interval: interval);
  }

  void stopPolling() {
    _stopPolling(this);
  }

  void dispose() {
    _disposeSyncSession(this);
  }
}
