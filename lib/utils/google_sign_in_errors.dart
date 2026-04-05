String googleSignInErrorMessage(String code) {
  switch (code) {
    case 'canceled':
    case 'sign_in_canceled':
      return 'Login cancelado.';
    case 'interrupted':
      return 'Login interrompido. Tente novamente.';
    case 'uiUnavailable':
      return 'Nao foi possivel abrir a interface de login.';
    case 'clientConfigurationError':
      return 'Falha na configuração do cliente Google.';
    case 'providerConfigurationError':
      return 'Falha na configuração do provedor Google.';
    case 'userMismatch':
      return 'A conta usada nao corresponde a sessao atual.';
    case 'network_error':
      return 'Sem conexão. Verifique sua internet.';
    case 'sign_in_failed':
      return 'Falha no login com Google. Verifique o provedor e o SHA-1.';
    case 'popup_closed_by_user':
      return 'Login cancelado.';
    case 'access_denied':
      return 'Acesso negado. Tente novamente.';
    case 'unknownError':
      return 'Nao foi possivel autenticar com o Google.';
    default:
      if (code.isEmpty) {
        return 'Não foi possível autenticar com o Google.';
      }
      return 'Não foi possível autenticar com o Google (codigo: $code).';
  }
}
