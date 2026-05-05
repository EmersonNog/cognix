part of 'ai_chat_screen.dart';

String _buildGreeting(String? rawName) {
  final greeting = _greetingFor(DateTime.now());
  final name = _firstName(rawName);
  if (name == null) {
    return '$greeting.';
  }
  return '$greeting, $name.';
}

String _greetingFor(DateTime value) {
  if (value.hour < 12) {
    return 'Bom dia';
  }
  if (value.hour < 18) {
    return 'Boa tarde';
  }
  return 'Boa noite';
}

String? _firstName(String? rawName) {
  final trimmed = rawName?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }

  final lower = trimmed.toLowerCase();
  if (lower.contains('usu')) {
    return null;
  }

  return trimmed.split(RegExp(r'\s+')).first;
}

List<InlineSpan> _buildInlineMarkdownSpans({
  required String text,
  required TextStyle baseStyle,
  required TextStyle strongStyle,
}) {
  final spans = <InlineSpan>[];
  var cursor = 0;

  while (cursor < text.length) {
    final start = text.indexOf('**', cursor);
    if (start == -1) {
      spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
      break;
    }

    final end = text.indexOf('**', start + 2);
    if (end == -1) {
      spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
      break;
    }

    if (start > cursor) {
      spans.add(
        TextSpan(text: text.substring(cursor, start), style: baseStyle),
      );
    }

    final strongText = text.substring(start + 2, end);
    if (strongText.isEmpty) {
      spans.add(
        TextSpan(text: text.substring(start, end + 2), style: baseStyle),
      );
    } else {
      spans.add(TextSpan(text: strongText, style: strongStyle));
    }

    cursor = end + 2;
  }

  if (spans.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  return spans;
}

String _formatMessageTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
