import '../../utils/api_datetime.dart';
import 'models.dart';

MultiplayerRoom parseMultiplayerRoom(Map<String, dynamic> payload) {
  final participants = _parseParticipants(payload['participants']);

  return MultiplayerRoom(
    id: _parseInt(payload['id']),
    pin: _parseString(payload['pin']),
    hostUserId: _parseInt(payload['host_user_id']),
    hostFirebaseUid: _parseString(payload['host_firebase_uid']),
    status: _parseString(payload['status'], fallback: 'waiting'),
    maxParticipants: _parseInt(payload['max_participants'], fallback: 8),
    participantCount: _parseInt(
      payload['participant_count'],
      fallback: participants.length,
    ),
    participants: participants,
    startedAt: parseApiDateTime(payload['started_at']?.toString()),
    finishedAt: parseApiDateTime(payload['finished_at']?.toString()),
    createdAt: parseApiDateTime(payload['created_at']?.toString()),
    updatedAt: parseApiDateTime(payload['updated_at']?.toString()),
  );
}

MultiplayerParticipant parseMultiplayerParticipant(
  Map<String, dynamic> payload,
) {
  return MultiplayerParticipant(
    id: _parseInt(payload['id']),
    roomId: _parseInt(payload['room_id']),
    userId: _parseInt(payload['user_id']),
    firebaseUid: _parseString(payload['firebase_uid']),
    displayName: _parseString(payload['display_name'], fallback: 'Jogador'),
    role: _parseString(payload['role'], fallback: 'player'),
    status: _parseString(payload['status'], fallback: 'joined'),
    joinedAt: parseApiDateTime(payload['joined_at']?.toString()),
    removedAt: parseApiDateTime(payload['removed_at']?.toString()),
    createdAt: parseApiDateTime(payload['created_at']?.toString()),
    updatedAt: parseApiDateTime(payload['updated_at']?.toString()),
  );
}

List<MultiplayerParticipant> _parseParticipants(Object? rawValue) {
  if (rawValue is! List) {
    return const [];
  }

  return rawValue
      .whereType<Map>()
      .map(
        (item) => parseMultiplayerParticipant(Map<String, dynamic>.from(item)),
      )
      .toList();
}

int _parseInt(Object? rawValue, {int fallback = 0}) {
  return int.tryParse('$rawValue') ?? fallback;
}

String _parseString(Object? rawValue, {String fallback = ''}) {
  final normalized = rawValue?.toString().trim() ?? '';
  return normalized.isNotEmpty ? normalized : fallback;
}
