import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const Duration apiTimeout = Duration(seconds: 15);

String apiBaseUrl() {
  const String envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  if (envBaseUrl.isNotEmpty) {
    if (kReleaseMode && !envBaseUrl.startsWith('https://')) {
      throw StateError(
        'API_BASE_URL precisa usar HTTPS em builds de produção.',
      );
    }
    return envBaseUrl;
  }
  if (kReleaseMode) {
    throw StateError('API_BASE_URL não configurada para build de produção.');
  }
  if (kIsWeb) {
    return 'http://localhost:8000';
  }
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://localhost:8000';
}

Future<String> requireAuthToken() async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
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
