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

Map<String, dynamic>? _decodeResponseMapOrNull(http.Response response) {
  try {
    final payload = jsonDecode(response.body);
    return payload is Map<String, dynamic> ? payload : null;
  } catch (_) {
    return null;
  }
}

Object? _responseDetail(http.Response response) {
  return _decodeResponseMapOrNull(response)?['detail'];
}

String? _trimmedStringValue(Object? value) {
  if (value is! String) {
    return null;
  }

  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _detailMessageFromResponse(http.Response response) {
  final detail = _responseDetail(response);
  if (detail is String) {
    return _trimmedStringValue(detail);
  }
  if (detail is Map<String, dynamic>) {
    return _trimmedStringValue(detail['message']);
  }
  if (detail is List && detail.isNotEmpty) {
    final first = detail.first;
    if (first is Map) {
      return _trimmedStringValue(first['msg']);
    }
  }
  return null;
}

String? _subscriptionRequiredMessageFromResponse(http.Response response) {
  final detail = _responseDetail(response);
  if (detail is Map<String, dynamic> &&
      detail['code'] == 'subscription_required') {
    return _trimmedStringValue(detail['message']) ??
        'Evolua sua experiência com um plano de assinatura.';
  }
  return null;
}
