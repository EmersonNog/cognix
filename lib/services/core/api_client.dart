import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const Duration apiTimeout = Duration(seconds: 15);
const String _productionApiBaseUrl = 'https://api.cognix-hub.com';
const String _localhostApiBaseUrl = 'http://localhost:8000';
const String _androidEmulatorApiBaseUrl = 'http://10.0.2.2:8000';

String normalizeApiBaseUrl(String rawBaseUrl) {
  return rawBaseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
}

String resolveApiBaseUrl({
  required String envBaseUrl,
  required bool isReleaseMode,
  required bool isWeb,
  required TargetPlatform targetPlatform,
}) {
  final normalizedEnvBaseUrl = normalizeApiBaseUrl(envBaseUrl);
  if (normalizedEnvBaseUrl.isNotEmpty) {
    if (isReleaseMode && !normalizedEnvBaseUrl.startsWith('https://')) {
      throw StateError(
        'API_BASE_URL precisa usar HTTPS em builds de produção.',
      );
    }
    return normalizedEnvBaseUrl;
  }

  if (isReleaseMode) {
    return _productionApiBaseUrl;
  }

  if (isWeb) {
    return _localhostApiBaseUrl;
  }

  if (targetPlatform == TargetPlatform.android) {
    return _androidEmulatorApiBaseUrl;
  }

  return _localhostApiBaseUrl;
}

String apiBaseUrl() {
  const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  return resolveApiBaseUrl(
    envBaseUrl: envBaseUrl,
    isReleaseMode: kReleaseMode,
    isWeb: kIsWeb,
    targetPlatform: defaultTargetPlatform,
  );
}

Future<String> requireAuthToken() async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token == null || token.isEmpty) {
    throw Exception('Usuário não autenticado.');
  }
  return token;
}

Future<String> requireFreshAuthToken() async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  if (token == null || token.isEmpty) {
    throw Exception('Usuário não autenticado.');
  }
  return token;
}

Future<Map<String, dynamic>> getJson(
  Uri uri, {
  required String errorMessage,
}) async {
  final token = await requireAuthToken();
  final response = await http
      .get(uri, headers: {'Authorization': 'Bearer $token'})
      .timeout(apiTimeout);

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
  final response = await http
      .get(uri, headers: {'Authorization': 'Bearer $token'})
      .timeout(apiTimeout);

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
}) async {
  final token = await requireAuthToken();
  final response = await http
      .post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      )
      .timeout(apiTimeout);

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
  final response = await http
      .delete(uri, headers: {'Authorization': 'Bearer $token'})
      .timeout(apiTimeout);

  if (response.statusCode != 200) {
    throw Exception('$errorMessage (${response.statusCode}).');
  }
}
