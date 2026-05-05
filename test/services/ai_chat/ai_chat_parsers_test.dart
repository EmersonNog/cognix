import 'package:cognix/services/ai_chat/ai_chat_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseAiChatReply', () {
    test('lê resposta no formato message', () {
      final parsed = parseAiChatReply({
        'message': {
          'role': 'assistant',
          'content': '  Revise Bio hoje e faça 10 questões.  ',
          'created_at': '2026-05-05T10:20:00Z',
        },
      });

      expect(parsed.role, AiChatRole.assistant);
      expect(parsed.content, 'Revise Bio hoje e faça 10 questões.');
      expect(parsed.createdAt.year, 2026);
    });

    test('aceita resposta plana do backend', () {
      final parsed = parseAiChatReply({'reply': 'Vamos por partes.'});

      expect(parsed.role, AiChatRole.assistant);
      expect(parsed.content, 'Vamos por partes.');
    });

    test('aceita choices quando o backend repassa formato de provedor', () {
      final parsed = parseAiChatReply({
        'choices': [
          {
            'message': {'role': 'assistant', 'content': 'Resposta do chat.'},
          },
        ],
      });

      expect(parsed.role, AiChatRole.assistant);
      expect(parsed.content, 'Resposta do chat.');
    });
  });
}
