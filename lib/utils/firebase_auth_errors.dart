enum AuthAction { signIn, signUp, reset }

String authErrorMessage(String code, {AuthAction action = AuthAction.signIn}) {
  switch (code) {
    case 'user-not-found':
      return 'E-mail não encontrado.';
    case 'invalid-email':
      return 'E-mail inválido.';
    case 'user-disabled':
      return 'Conta desativada.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente.';
    case 'network-request-failed':
      return 'Sem conexão. Verifique sua internet.';
    case 'operation-not-allowed':
      return 'Ative o login por e-mail no Firebase Console.';
    case 'account-exists-with-different-credential':
      return 'Conta já existe com outro provedor.';
  }

  switch (action) {
    case AuthAction.signIn:
      switch (code) {
        case 'wrong-password':
          return 'Senha incorreta.';
        case 'invalid-credential':
          return 'Credenciais inválidas.';
      }
      return 'Não foi possivel entrar. Tente novamente.';
    case AuthAction.signUp:
      switch (code) {
        case 'email-already-in-use':
          return 'Este e-mail já está em uso.';
        case 'weak-password':
          return 'Senha fraca. Use ao menos 6 caracteres.';
      }
      return 'Não foi possivel criar a conta. Tente novamente.';
    case AuthAction.reset:
      return 'Não foi possivel enviar o link.';
  }
}
