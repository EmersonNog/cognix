String googleSignInErrorMessage(String code) {
  switch (code) {
    case 'canceled':
    case 'sign_in_canceled':
      return 'Login cancelado.';
    case 'interrupted':
      return 'Login interrompido. Tente novamente.';
    case 'uiUnavailable':
      return 'Não foi possível abrir a interface de login.';
    case 'clientConfigurationError':
      return 'Falha na configuração do cliente Google.';
    case 'providerConfigurationError':
      return 'Falha na configuração do provedor Google.';
    case 'userMismatch':
      return 'A conta usada não corresponde a sessão atual.';
    case 'network_error':
      return 'Sem conexão. Verifique sua internet.';
    case 'sign_in_failed':
      return 'Falha no login com Google. Verifique o provedor e o SHA-1.';
    case 'popup_closed_by_user':
      return 'Login cancelado.';
    case 'access_denied':
      return 'Acesso negado. Tente novamente.';
    case 'unknownError':
      return 'Não foi possível autenticar com o Google.';
    default:
      if (code.isEmpty) {
        return 'Não foi possível autenticar com o Google.';
      }
      return 'Não foi possível autenticar com o Google (codigo: $code).';
  }
}
