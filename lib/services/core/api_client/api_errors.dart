part of '../api_client.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => message;
}

class SubscriptionRequiredException extends ApiException {
  const SubscriptionRequiredException(super.message, {super.statusCode})
    : super(code: 'subscription_required');
}

bool isSubscriptionRequiredError(Object? error) {
  return error is SubscriptionRequiredException;
}

String readableApiErrorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }

  return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
}

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

String? _subscriptionRequiredMessageFromResponse(http.Response response) {
  try {
    final payload = jsonDecode(response.body);
    if (payload is! Map<String, dynamic>) {
      return null;
    }

    final detail = payload['detail'];
    if (detail is Map<String, dynamic> &&
        detail['code'] == 'subscription_required') {
      final message = detail['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      return 'Evolua sua experiência com um plano de assinatura.';
    }
  } catch (_) {
    return null;
  }
  return null;
}
