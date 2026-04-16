import 'package:cognix/services/multiplayer/parsers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseMultiplayerRoom', () {
    test('converte payload do backend para sala com participantes', () {
      final room = parseMultiplayerRoom({
        'id': 12,
        'pin': '123456',
        'host_user_id': 2,
        'host_firebase_uid': 'host-uid',
        'status': 'waiting',
        'max_participants': 8,
        'participant_count': 2,
        'participants': [
          {
            'id': 1,
            'room_id': 12,
            'user_id': 2,
            'firebase_uid': 'host-uid',
            'display_name': 'Host',
            'role': 'host',
            'status': 'joined',
          },
          {
            'id': 2,
            'room_id': 12,
            'user_id': 5,
            'firebase_uid': 'player-uid',
            'display_name': 'Player',
            'role': 'player',
            'status': 'joined',
          },
        ],
      });

      expect(room.id, 12);
      expect(room.pin, '123456');
      expect(room.isWaiting, isTrue);
      expect(room.participants, hasLength(2));
      expect(room.participants.first.isHost, isTrue);
      expect(room.hasParticipantFirebaseUid('player-uid'), isTrue);
      expect(room.isHostFirebaseUid('host-uid'), isTrue);
    });
  });
}
