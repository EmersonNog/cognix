part of '../api_client.dart';

const Duration apiTimeout = Duration(seconds: 15);

enum _ApiMethod { get, post, delete }

Future<Map<String, dynamic>> getJson(
  Uri uri, {
  required String errorMessage,
}) async {
  final response = await _sendAuthorizedRequest(
    uri,
    method: _ApiMethod.get,
    errorMessage: errorMessage,
  );
  _throwIfUnexpectedStatus(response, errorMessage: errorMessage);
  return _decodeJsonObject(response);
}

Future<Map<String, dynamic>?> getJsonOrNullOn404(
  Uri uri, {
  required String errorMessage,
}) async {
  final response = await _sendAuthorizedRequest(
    uri,
    method: _ApiMethod.get,
    errorMessage: errorMessage,
  );
  if (response.statusCode == 404) {
    return null;
  }

  _throwIfUnexpectedStatus(response, errorMessage: errorMessage);
  return _decodeJsonObject(response);
}

Future<Map<String, dynamic>> postJson(
  Uri uri, {
  required Map<String, dynamic> body,
  required String errorMessage,
  Duration timeout = apiTimeout,
}) async {
  final response = await _sendAuthorizedRequest(
    uri,
    method: _ApiMethod.post,
    body: body,
    errorMessage: errorMessage,
    timeout: timeout,
  );
  _throwIfUnexpectedStatus(response, errorMessage: errorMessage);
  return _decodeJsonObject(response);
}

Future<void> deleteJson(Uri uri, {required String errorMessage}) async {
  final response = await _sendAuthorizedRequest(
    uri,
    method: _ApiMethod.delete,
    errorMessage: errorMessage,
  );
  _throwIfUnexpectedStatus(response, errorMessage: errorMessage);
}

Future<http.Response> _sendAuthorizedRequest(
  Uri uri, {
  required _ApiMethod method,
  required String errorMessage,
  Map<String, dynamic>? body,
  Duration timeout = apiTimeout,
}) async {
  final token = await requireAuthToken();
  final headers = {
    'Authorization': 'Bearer $token',
    if (body != null) 'Content-Type': 'application/json',
  };

  try {
    return await _sendRequest(
      uri,
      method: method,
      headers: headers,
      body: body,
    ).timeout(timeout);
  } catch (error) {
    if (_looksLikeConnectionError(error)) {
      throw Exception(_connectionHintMessage(errorMessage));
    }
    rethrow;
  }
}

Future<http.Response> _sendRequest(
  Uri uri, {
  required _ApiMethod method,
  required Map<String, String> headers,
  Map<String, dynamic>? body,
}) {
  switch (method) {
    case _ApiMethod.get:
      return http.get(uri, headers: headers);
    case _ApiMethod.post:
      return http.post(uri, headers: headers, body: jsonEncode(body));
    case _ApiMethod.delete:
      return http.delete(uri, headers: headers);
  }
}
