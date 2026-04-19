part of '../api_client.dart';

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

