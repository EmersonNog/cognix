String humanizeMultiplayerError(
  Object error, {
  String fallback =
      'Não deu para concluir agora. Tente novamente em instantes.',
}) {
  final rawMessage = error.toString().trim();
  final withoutExceptionPrefix = rawMessage.replaceFirst(
    RegExp(r'^Exception:\s*'),
    '',
  );
  final withoutStatusCode = withoutExceptionPrefix.replaceFirst(
    RegExp(r'\s*\(\d{3}\)\.?$'),
    '',
  );
  final message = withoutStatusCode.trim();

  return message.isEmpty ? fallback : message;
}

bool isMultiplayerNotFoundError(Object error) {
  return RegExp(r'\(404\)\.?$').hasMatch(error.toString().trim());
}
