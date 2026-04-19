import 'package:cognix/services/multiplayer/models.dart';
import 'package:cognix/services/multiplayer/sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MultiplayerRoom room({
    required int id,
    String status = 'waiting',
    int questionIndex = 0,
  }) {
    return MultiplayerRoom(
      id: id,
      pin: '123456',
      hostUserId: 1,
      hostFirebaseUid: 'host-uid',
      status: status,
      maxParticipants: 10,
      participantCount: 1,
      participants: const <MultiplayerParticipant>[],
      currentQuestionIndex: questionIndex,
    );
  }

  group('MultiplayerRoomSyncSession', () {
    test('emite refresh manual com sala atualizada', () async {
      final session = MultiplayerRoomSyncSession(
        fetchRoom: (roomId) async => room(id: roomId, status: 'in_progress'),
      );
      addTearDown(session.dispose);

      final events = <MultiplayerRoomSyncEvent>[];
      final subscription = session.events.listen(events.add);
      addTearDown(subscription.cancel);

      session.bindRoom(room(id: 7), emitInitial: false);
      final updated = await session.refresh();
      await Future<void>.delayed(Duration.zero);

      expect(updated, isNotNull);
      expect(events, hasLength(1));
      expect(events.single.room.isInProgress, isTrue);
      expect(events.single.source, MultiplayerSyncSource.manual);
    });

    test('emite erro quando refresh falha', () async {
      final session = MultiplayerRoomSyncSession(
        fetchRoom: (_) async => throw StateError('boom'),
      );
      addTearDown(session.dispose);

      final errors = <MultiplayerRoomSyncError>[];
      final subscription = session.errors.listen(errors.add);
      addTearDown(subscription.cancel);

      session.bindRoom(room(id: 7), emitInitial: false);
      await session.refresh(source: MultiplayerSyncSource.polling);
      await Future<void>.delayed(Duration.zero);

      expect(errors, hasLength(1));
      expect(errors.single.error, isA<StateError>());
      expect(errors.single.source, MultiplayerSyncSource.polling);
    });

    test('faz fallback para polling com status explicito quando websocket falha', () async {
      final session = MultiplayerRoomSyncSession(
        fetchRoom: (roomId) async => room(id: roomId, status: 'in_progress'),
        tokenProvider: () async => throw StateError('token-fail'),
        reconnectDelay: const Duration(seconds: 30),
      );
      addTearDown(session.dispose);

      final events = <MultiplayerRoomSyncEvent>[];
      final statuses = <MultiplayerSyncStatusEvent>[];
      final eventSubscription = session.events.listen(events.add);
      final statusSubscription = session.status.listen(statuses.add);
      addTearDown(eventSubscription.cancel);
      addTearDown(statusSubscription.cancel);

      session.bindRoom(room(id: 7), emitInitial: false);
      session.startPolling();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(
        statuses.map((item) => item.status),
        containsAll(<MultiplayerRealtimeStatus>[
          MultiplayerRealtimeStatus.connecting,
          MultiplayerRealtimeStatus.pollingFallback,
          MultiplayerRealtimeStatus.reconnectScheduled,
        ]),
      );
      expect(events, isNotEmpty);
      expect(events.last.source, MultiplayerSyncSource.polling);
      expect(events.last.room.isInProgress, isTrue);
    });
  });
}
