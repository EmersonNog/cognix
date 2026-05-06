import '../core/api_client.dart' show apiBaseUrl, postJson;
import 'models.dart';
import 'parsers.dart';

Future<AiChatMessage> sendAiChatMessage({
  required List<AiChatMessage> messages,
}) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/ai/chat'),
    body: {
      'messages': messages
          .where(
            (message) =>
                message.content.trim().isNotEmpty ||
                message.attachments.isNotEmpty,
          )
          .map((message) => message.toRequestJson())
          .toList(),
    },
    errorMessage: 'Não foi possível conversar com a IA',
    timeout: const Duration(seconds: 45),
  );

  return parseAiChatReply(payload);
}
