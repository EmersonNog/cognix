part of '../api_client.dart';

const Duration apiTimeout = Duration(seconds: 15);

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

Future<Map<String, dynamic>> getJson(
  Uri uri, {
  required String errorMessage,
}) async {
  final token = await requireAuthToken();
  http.Response response;
  try {
    response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(apiTimeout);
  } catch (error) {
    if (_looksLikeConnectionError(error)) {
      throw Exception(_connectionHintMessage(errorMessage));
    }
    rethrow;
  }

  if (response.statusCode != 200) {
    throw Exception('$errorMessage (${response.statusCode}).');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>?> getJsonOrNullOn404(
  Uri uri, {
  required String errorMessage,
}) async {
  final token = await requireAuthToken();
  http.Response response;
  try {
    response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(apiTimeout);
  } catch (error) {
    if (_looksLikeConnectionError(error)) {
      throw Exception(_connectionHintMessage(errorMessage));
    }
    rethrow;
  }

  if (response.statusCode == 404) {
    return null;
  }
  if (response.statusCode != 200) {
    throw Exception('$errorMessage (${response.statusCode}).');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> postJson(
  Uri uri, {
  required Map<String, dynamic> body,
  required String errorMessage,
  Duration timeout = apiTimeout,
}) async {
  final token = await requireAuthToken();
  http.Response response;
  try {
    response = await http
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(timeout);
  } catch (error) {
    if (_looksLikeConnectionError(error)) {
      throw Exception(_connectionHintMessage(errorMessage));
    }
    rethrow;
  }

  if (response.statusCode != 200) {
    throw Exception('$errorMessage (${response.statusCode}).');
  }

  if (response.body.trim().isEmpty) {
    return const <String, dynamic>{};
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<void> deleteJson(Uri uri, {required String errorMessage}) async {
  final token = await requireAuthToken();
  http.Response response;
  try {
    response = await http
        .delete(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(apiTimeout);
  } catch (error) {
    if (_looksLikeConnectionError(error)) {
      throw Exception(_connectionHintMessage(errorMessage));
    }
    rethrow;
  }

  if (response.statusCode != 200) {
    throw Exception('$errorMessage (${response.statusCode}).');
  }
}
