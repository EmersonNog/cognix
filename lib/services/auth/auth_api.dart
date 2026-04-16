import '../core/api_client.dart' show apiBaseUrl, postJson;

Future<void> syncCurrentUserToBackend() async {
  await postJson(
    Uri.parse('${apiBaseUrl()}/users/sync'),
    body: const <String, dynamic>{},
    errorMessage: 'Erro ao sincronizar usuário',
  );
}
