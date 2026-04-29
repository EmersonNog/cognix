const String googlePlayAlreadySubscribedMessage =
    'Essa conta Google Play já tem uma assinatura ativa do Cognix.';

String googlePlayBillingErrorMessage(
  String? message, {
  required String fallback,
}) {
  final trimmedMessage = message?.trim();
  if (isGooglePlaySubscriptionConflictMessage(trimmedMessage)) {
    return googlePlayAlreadySubscribedMessage;
  }
  if (trimmedMessage != null && trimmedMessage.isNotEmpty) {
    return trimmedMessage;
  }
  return fallback;
}

bool isGooglePlaySubscriptionConflictMessage(String? message) {
  if (message == null || message.isEmpty) {
    return false;
  }

  final normalized = message.toLowerCase();
  return _looksLikeAlreadySubscribedError(normalized) ||
      normalized.contains('assinatura google play ja esta vinculada') ||
      normalized.contains('assinatura google play já está vinculada') ||
      normalized.contains('vinculada a outra conta cognix');
}

bool _looksLikeAlreadySubscribedError(String normalized) {
  return normalized.contains('already subscribed') ||
      normalized.contains('billingresponse.itemalreadyowned') ||
      normalized.contains(
        "account identifiers don't match the previous subscription",
      ) ||
      normalized.contains(
        'account identifiers do not match the previous subscription',
      ) ||
      normalized.contains('itemalreadyowned') ||
      normalized.contains('unable to change your subscription plan') ||
      normalized.contains('nao foi possivel alterar seu plano de assinatura') ||
      normalized.contains('não foi possível alterar seu plano de assinatura') ||
      normalized.contains('já possui uma assinatura') ||
      normalized.contains('já está inscrito') ||
      normalized.contains('já está assinando');
}

class GooglePlayBillingException implements Exception {
  const GooglePlayBillingException(this.message);

  final String message;

  @override
  String toString() => message;
}
