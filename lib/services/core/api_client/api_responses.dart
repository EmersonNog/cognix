part of '../api_client.dart';

void _throwIfUnexpectedStatus(
  http.Response response, {
  required String errorMessage,
  Set<int> expectedStatusCodes = const {200},
}) {
  final statusCode = response.statusCode;
  if (expectedStatusCodes.contains(statusCode)) {
    return;
  }

  if (statusCode == 403) {
    final subscriptionMessage = _subscriptionRequiredMessageFromResponse(
      response,
    );
    if (subscriptionMessage != null) {
      throw SubscriptionRequiredException(
        subscriptionMessage,
        statusCode: statusCode,
      );
    }
  }

  throw _apiExceptionForUnexpectedStatus(response, errorMessage: errorMessage);
}

Map<String, dynamic> _decodeJsonObject(http.Response response) {
  if (response.body.trim().isEmpty) {
    return const <String, dynamic>{};
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

ApiException _apiExceptionForUnexpectedStatus(
  http.Response response, {
  required String errorMessage,
}) {
  final statusCode = response.statusCode;
  final detailMessage = _detailMessageFromResponse(response);

  if (statusCode == 422) {
    return ApiException(
      detailMessage ?? '$errorMessage (422).',
      statusCode: statusCode,
    );
  }

  if (detailMessage != null) {
    return ApiException(detailMessage, statusCode: statusCode);
  }

  return ApiException('$errorMessage ($statusCode).', statusCode: statusCode);
}
