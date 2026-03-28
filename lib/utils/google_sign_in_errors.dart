String googleSignInErrorMessage(String code) {
  switch (code) {
    case 'sign_in_canceled':
      return 'Login cancelado.';
    case 'network_error':
      return 'Sem conexão. Verifique sua internet.';
    case 'sign_in_failed':
      return 'Falha no login com Google. Verifique o provedor e o SHA-1.';
    case 'popup_closed_by_user':
      return 'Login cancelado.';
    case 'access_denied':
      return 'Acesso negado. Tente novamente.';
    default:
      if (code.isEmpty) {
        return 'Não foi possível autenticar com o Google.';
      }
      return 'Não foi possível autenticar com o Google (codigo: $code).';
  }
}
