import 'package:cognix/pages/training/session/data/training_session_state_codec.dart';
import 'package:cognix/services/questions/models.dart';
import 'package:cognix/services/questions/parsers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseTrainingSessionState', () {
    test('reads savedAt and stateVersion from the API payload', () {
      final parsed = parseTrainingSessionState({
        'state': {
          'discipline': 'Ciencias da Natureza e suas Tecnologias',
          'subcategory': 'Biologia',
          'savedAt': 1776211359647,
          'stateVersion': 2,
        },
        'saved_at': '2026-04-15T00:02:39.647000+00:00',
        'updated_at': '2026-04-15T00:02:39.917488+00:00',
        'state_version': 2,
      });

      expect(parsed.stateVersion, 2);
      expect(
        parsed.savedAt,
        DateTime.parse('2026-04-15T00:02:39.647000+00:00').toLocal(),
      );
      expect(
        parsed.updatedAt,
        DateTime.parse('2026-04-15T00:02:39.917488+00:00').toLocal(),
      );
    });
  });

  group('parseTrainingSessionsOverview', () {
    test('uses session_at as the canonical overview timestamp', () {
      final parsed = parseTrainingSessionsOverview({
        'completed_sessions': 1,
        'in_progress_sessions': 0,
        'latest_session': {
          'discipline': 'Ciencias Humanas e suas Tecnologias',
          'subcategory': 'Geografia',
          'completed': false,
          'answered_questions': 3,
          'total_questions': 205,
          'progress': 3 / 205,
          'session_at': '2026-04-15T14:00:29.965000+00:00',
          'updated_at': '2026-04-15T14:00:28.429743+00:00',
        },
      });

      expect(
        parsed.latestSession?.sessionAt,
        DateTime.parse('2026-04-15T14:00:29.965000+00:00').toLocal(),
      );
    });
  });

  group('chooseTrainingSessionState', () {
    test('prefers the remote state when remote savedAt is newer', () {
      final remoteState = TrainingSessionState(
        state: {
          'discipline': 'Ciencias da Natureza e suas Tecnologias',
          'subcategory': 'Biologia',
          'savedAt': 2000,
          'stateVersion': 2,
        },
        updatedAt: DateTime.fromMillisecondsSinceEpoch(3000, isUtc: true),
        savedAt: DateTime.fromMillisecondsSinceEpoch(2000, isUtc: true),
        stateVersion: 2,
      );

      final chosen = chooseTrainingSessionState(
        localState: {
          'discipline': 'Ciencias da Natureza e suas Tecnologias',
          'subcategory': 'Biologia',
          'savedAt': 1000,
          'stateVersion': 2,
        },
        remoteState: remoteState,
      );

      expect(chosen, same(remoteState.state));
    });

    test('uses stateVersion as a tie-breaker when savedAt matches', () {
      final remoteState = TrainingSessionState(
        state: {
          'discipline': 'Ciencias da Natureza e suas Tecnologias',
          'subcategory': 'Biologia',
          'savedAt': 1000,
          'stateVersion': 2,
        },
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
        savedAt: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
        stateVersion: 2,
      );

      final chosen = chooseTrainingSessionState(
        localState: {
          'discipline': 'Ciencias da Natureza e suas Tecnologias',
          'subcategory': 'Biologia',
          'savedAt': 1000,
          'stateVersion': 1,
        },
        remoteState: remoteState,
      );

      expect(chosen, same(remoteState.state));
    });
  });
}
