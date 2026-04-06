enum AuthAction { signIn, signUp, reset, updatePassword, deleteAccount }

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
      return 'Não foi possível entrar. Tente novamente.';
    case AuthAction.signUp:
      switch (code) {
        case 'email-already-in-use':
          return 'Este e-mail já esta em uso.';
        case 'weak-password':
          return 'Senha fraca. Use ao menos 6 caracteres.';
      }
      return 'Não foi possível criar a conta. Tente novamente.';
    case AuthAction.reset:
      return 'Não foi possível enviar o link.';
    case AuthAction.updatePassword:
      switch (code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'A senha atual informada esta incorreta.';
        case 'weak-password':
          return 'A nova senha precisa ser mais forte.';
        case 'requires-recent-login':
          return 'Confirme sua senha novamente para concluir a alteração.';
        case 'missing-email':
          return 'Não foi possível identificar o email da conta atual.';
      }
      return 'Não foi possível atualizar sua senha agora.';
    case AuthAction.deleteAccount:
      switch (code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'A senha atual informada esta incorreta.';
        case 'requires-recent-login':
          return 'Confirme sua identidade novamente antes de excluir a conta.';
        case 'user-mismatch':
          return 'A conta escolhida não corresponde a sessão atual.';
        case 'missing-email':
          return 'Não foi possível identificar os dados da conta atual.';
      }
      return 'Não foi possível excluir sua conta agora.';
  }
}
