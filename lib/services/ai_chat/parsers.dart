import '../../utils/api_datetime.dart';
import 'models.dart';

AiChatMessage parseAiChatReply(Map<String, dynamic> payload) {
  final messagePayload = _extractMessagePayload(payload);
  final role = _parseAiChatRole(_valueFromMessage(messagePayload, 'role'));
  final content =
      _messageContent(messagePayload) ??
      _directContent(payload) ??
      'Não consegui gerar uma resposta agora.';

  return AiChatMessage(
    role: role ?? AiChatRole.assistant,
    content: content,
    createdAt:
        parseApiDateTime(
          _valueFromMessage(messagePayload, 'created_at')?.toString(),
        ) ??
        parseApiDateTime(payload['created_at']?.toString()) ??
        DateTime.now(),
  );
}

AiChatRole? parseAiChatRole(Object? raw) {
  return _parseAiChatRole(raw);
}

Object? _extractMessagePayload(Map<String, dynamic> payload) {
  final message = payload['message'];
  if (message is Map) {
    return message;
  }
  if (message is String && message.trim().isNotEmpty) {
    return message;
  }

  final choices = payload['choices'];
  if (choices is List) {
    for (final choice in choices) {
      if (choice is! Map) continue;
      final choiceMessage = choice['message'];
      if (choiceMessage is Map || choiceMessage is String) {
        return choiceMessage;
      }
      final choiceText = _firstTrimmedString([
        choice['text'],
        choice['content'],
        choice['answer'],
      ]);
      if (choiceText != null) {
        return choiceText;
      }
    }
  }

  return payload;
}

String? _messageContent(Object? raw) {
  if (raw is String) {
    return _trimmedString(raw);
  }
  if (raw is Map) {
    return _firstTrimmedString([
      raw['content'],
      raw['text'],
      raw['reply'],
      raw['answer'],
    ]);
  }
  return null;
}

String? _directContent(Map<String, dynamic> payload) {
  return _firstTrimmedString([
    payload['reply'],
    payload['answer'],
    payload['content'],
    payload['text'],
  ]);
}

Object? _valueFromMessage(Object? raw, String key) {
  if (raw is Map) {
    return raw[key];
  }
  return null;
}

AiChatRole? _parseAiChatRole(Object? raw) {
  final value = raw?.toString().trim().toLowerCase();
  return switch (value) {
    'user' => AiChatRole.user,
    'assistant' => AiChatRole.assistant,
    'ai' => AiChatRole.assistant,
    'ia' => AiChatRole.assistant,
    _ => null,
  };
}

String? _firstTrimmedString(List<Object?> values) {
  for (final value in values) {
    final text = _trimmedString(value?.toString());
    if (text != null) {
      return text;
    }
  }
  return null;
}

String? _trimmedString(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}
