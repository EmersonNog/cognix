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
        'status': 'finished',
        'max_participants': 10,
        'participant_count': 2,
        'question_ids': [101, '102', {'question_id': 103}],
        'current_question_index': 1,
        'round_duration_seconds': 45,
        'server_time': '2026-04-17T12:00:10Z',
        'round_started_at': '2026-04-17T12:00:00Z',
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
            'score': 200,
            'correct_answers': 2,
            'answered_current_question': true,
          },
        ],
        'ranking': [
          {
            'id': 2,
            'room_id': 12,
            'user_id': 5,
            'firebase_uid': 'player-uid',
            'display_name': 'Player',
            'role': 'player',
            'status': 'joined',
            'score': 200,
            'correct_answers': 2,
            'answered_current_question': true,
          },
          {
            'id': 1,
            'room_id': 12,
            'user_id': 2,
            'firebase_uid': 'host-uid',
            'display_name': 'Host',
            'role': 'host',
            'status': 'joined',
          },
        ],
      });

      expect(room.id, 12);
      expect(room.pin, '123456');
      expect(room.isFinished, isTrue);
      expect(room.participants, hasLength(2));
      expect(room.participants.first.isHost, isTrue);
      expect(room.hasParticipantFirebaseUid('player-uid'), isTrue);
      expect(room.isHostFirebaseUid('host-uid'), isTrue);
      expect(room.questionIds, [101, 102, 103]);
      expect(room.currentQuestionIndex, 1);
      expect(room.roundDurationSeconds, 45);
      expect(room.serverTime, isNotNull);
      expect(room.roundStartedAt, isNotNull);
      expect(room.ranking.map((item) => item.name), ['Player', 'Host']);
      expect(room.participants.last.score, 200);
      expect(room.participants.last.correctAnswers, 2);
      expect(room.participants.last.answeredCurrentQuestion, isTrue);
    });

    test('converte payload de resposta multiplayer com sala aninhada', () {
      final result = parseMultiplayerAnswerResult({
        'is_correct': true,
        'correct_letter': 'B',
        'score': 300,
        'room': {
          'id': 12,
          'pin': '123456',
          'host_user_id': 2,
          'host_firebase_uid': 'host-uid',
          'status': 'in_progress',
          'question_ids': [101, 102],
          'current_question_index': 0,
          'participants': const [],
        },
      });

      expect(result.isCorrect, isTrue);
      expect(result.correctLetter, 'B');
      expect(result.score, 300);
      expect(result.room.id, 12);
      expect(result.room.questionIds, [101, 102]);
    });
  });
}
