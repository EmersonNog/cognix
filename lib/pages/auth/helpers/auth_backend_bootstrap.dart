import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth/auth_api.dart';

Future<void> prepareAuthenticatedBackendSession() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw FirebaseAuthException(
      code: 'missing-current-user',
      message: 'Usuário autenticado não encontrado.',
    );
  }

  Object? lastError;
  for (var attempt = 0; attempt < 3; attempt++) {
    try {
      await user.getIdToken(true);
      await syncCurrentUserToBackend();
      return;
    } catch (error) {
      lastError = error;
      if (attempt == 2) {
        break;
      }
      await Future<void>.delayed(Duration(milliseconds: 350 * (attempt + 1)));
    }
  }

  throw lastError ?? Exception('Falha ao sincronizar sessão autenticada.');
}
