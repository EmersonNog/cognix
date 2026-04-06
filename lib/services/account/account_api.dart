import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/api_client.dart'
    show apiBaseUrl, apiTimeout, requireFreshAuthToken;

class AccountApiException implements Exception {
  const AccountApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<void> deleteCurrentAccountFromBackend() async {
  try {
    final token = await requireFreshAuthToken();
    final response = await http
        .delete(
          Uri.parse('${apiBaseUrl()}/users/account'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(apiTimeout);

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 403) {
      throw const AccountApiException(
        'Confirme sua identidade novamente para concluir a exclusão da conta.',
      );
    }

    throw AccountApiException(
      'Não foi possível excluir sua conta agora (${response.statusCode}).',
    );
  } on TimeoutException {
    throw const AccountApiException(
      'A exclusão demorou demais para responder. Tente novamente.',
    );
  } on SocketException {
    throw const AccountApiException(
      'Sem conexão. Verifique sua internet e tente novamente.',
    );
  }
}
