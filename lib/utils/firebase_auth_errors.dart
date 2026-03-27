enum AuthAction { signIn, signUp, reset }

String authErrorMessage(String code, {AuthAction action = AuthAction.signIn}) {
  switch (code) {
    case 'user-not-found':
      return 'E-mail nao encontrado.';
    case 'invalid-email':
      return 'E-mail invalido.';
    case 'user-disabled':
      return 'Conta desativada.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente.';
    case 'network-request-failed':
      return 'Sem conexao. Verifique sua internet.';
    case 'operation-not-allowed':
      return 'Ative o login por e-mail no Firebase Console.';
    case 'account-exists-with-different-credential':
      return 'Conta ja existe com outro provedor.';
  }

  switch (action) {
    case AuthAction.signIn:
      switch (code) {
        case 'wrong-password':
          return 'Senha incorreta.';
        case 'invalid-credential':
          return 'Credenciais invalidas.';
      }
      return 'Nao foi possivel entrar. Tente novamente.';
    case AuthAction.signUp:
      switch (code) {
        case 'email-already-in-use':
          return 'Este e-mail ja esta em uso.';
        case 'weak-password':
          return 'Senha fraca. Use ao menos 6 caracteres.';
      }
      return 'Nao foi possivel criar a conta. Tente novamente.';
    case AuthAction.reset:
      return 'Nao foi possivel enviar o link.';
  }
}
