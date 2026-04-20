part of '../api_client.dart';

void _throwIfUnexpectedStatus(
  http.Response response, {
  required String errorMessage,
  Set<int> expectedStatusCodes = const {200},
}) {
  if (expectedStatusCodes.contains(response.statusCode)) {
    return;
  }

  if (response.statusCode == 422) {
    throw Exception(
      _validationMessageFromResponse(response) ?? '$errorMessage (422).',
    );
  }

  throw Exception('$errorMessage (${response.statusCode}).');
}

Map<String, dynamic> _decodeJsonObject(http.Response response) {
  if (response.body.trim().isEmpty) {
    return const <String, dynamic>{};
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}
