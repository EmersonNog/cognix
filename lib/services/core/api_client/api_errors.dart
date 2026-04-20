part of '../api_client.dart';

String _connectionHintMessage(String errorMessage) {
  final normalized = errorMessage.trim().replaceFirst(RegExp(r'[.!]\s*$'), '');
  return '$normalized. Confira sua conexão e tente novamente.';
}

bool _looksLikeConnectionError(Object error) {
  if (error is http.ClientException || error is TimeoutException) {
    return true;
  }

  final message = error.toString().toLowerCase();
  return message.contains('socketexception') ||
      message.contains('clientexception') ||
      message.contains('failed host lookup') ||
      message.contains('network is unreachable') ||
      message.contains('connection failed');
}

String? _validationMessageFromResponse(http.Response response) {
  try {
    final payload = jsonDecode(response.body);
    if (payload is! Map<String, dynamic>) {
      return null;
    }

    final detail = payload['detail'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail.trim();
    }
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map && first['msg'] is String) {
        return first['msg'].toString().trim();
      }
    }
  } catch (_) {
    return null;
  }
  return null;
}
