import 'package:cognix/services/multiplayer/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('humanizeMultiplayerError', () {
    test('remove prefixo tecnico e codigo HTTP da mensagem', () {
      final message = humanizeMultiplayerError(
        Exception('Não encontrei essa sala. Confira o PIN. (404).'),
      );

      expect(message, 'Não encontrei essa sala. Confira o PIN.');
    });

    test('usa fallback quando a mensagem vem vazia', () {
      expect(humanizeMultiplayerError(Exception('')), isNotEmpty);
    });

    test('identifica erro 404 de sala inexistente', () {
      expect(
        isMultiplayerNotFoundError(Exception('Sala encerrada. (404).')),
        isTrue,
      );
      expect(isMultiplayerNotFoundError(Exception('Falha. (500).')), isFalse);
    });
  });
}
