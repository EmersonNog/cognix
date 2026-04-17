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
    questionIds: _parseQuestionIds(payload),
    currentQuestionIndex: _parseInt(
      payload['current_question_index'] ?? payload['current_round_index'],
    ),
    roundDurationSeconds: _parseInt(
      payload['round_duration_seconds'],
      fallback: 60,
    ),
    startedAt: parseApiDateTime(payload['started_at']?.toString()),
    roundStartedAt: parseApiDateTime(payload['round_started_at']?.toString()),
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
    score: _parseInt(payload['score'] ?? payload['points']),
    correctAnswers: _parseInt(payload['correct_answers']),
    answeredCurrentQuestion: _parseBool(
      payload['answered_current_question'] ?? payload['has_answered'],
    ),
    joinedAt: parseApiDateTime(payload['joined_at']?.toString()),
    removedAt: parseApiDateTime(payload['removed_at']?.toString()),
    createdAt: parseApiDateTime(payload['created_at']?.toString()),
    updatedAt: parseApiDateTime(payload['updated_at']?.toString()),
  );
}

MultiplayerAnswerResult parseMultiplayerAnswerResult(
  Map<String, dynamic> payload,
) {
  final rawRoom = payload['room'];
  final roomPayload = rawRoom is Map
      ? Map<String, dynamic>.from(rawRoom)
      : payload;

  return MultiplayerAnswerResult(
    room: parseMultiplayerRoom(roomPayload),
    isCorrect: _parseOptionalBool(payload['is_correct']),
    correctLetter: _parseOptionalString(
      payload['correct_letter'] ?? payload['answer_key'],
    ),
    score: _parseOptionalInt(payload['score'] ?? payload['points']),
  );
}

List<int> _parseQuestionIds(Map<String, dynamic> payload) {
  final rawValue =
      payload['question_ids'] ??
      payload['match_question_ids'] ??
      payload['questions'];
  if (rawValue is! List) {
    return const [];
  }

  final ids = <int>[];
  for (final item in rawValue) {
    if (item is Map) {
      final id = _parseInt(item['id'] ?? item['question_id']);
      if (id > 0) {
        ids.add(id);
      }
      continue;
    }

    final id = _parseInt(item);
    if (id > 0) {
      ids.add(id);
    }
  }
  return ids;
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

String? _parseOptionalString(Object? rawValue) {
  final normalized = rawValue?.toString().trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

int? _parseOptionalInt(Object? rawValue) {
  final value = int.tryParse('$rawValue');
  return value;
}

bool _parseBool(Object? rawValue, {bool fallback = false}) {
  return _parseOptionalBool(rawValue) ?? fallback;
}

bool? _parseOptionalBool(Object? rawValue) {
  if (rawValue is bool) {
    return rawValue;
  }
  final normalized = rawValue?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
  }
  return null;
}
