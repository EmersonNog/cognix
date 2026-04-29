part of '../subscription_screen.dart';

String _planTitle(String? planId) {
  return switch (planId) {
    'mensal' || googlePlaySubscriptionMonthlyProductId => 'Plano mensal',
    'semestral' => 'Plano semestral',
    'anual' || googlePlaySubscriptionAnnualProductId => 'Plano anual',
    _ => 'Assinatura Cognix',
  };
}

String _billingCycleLabel(String? planId) {
  return switch (planId) {
    'mensal' || googlePlaySubscriptionMonthlyProductId => 'Cobrança mensal',
    'semestral' => 'Cobrança semestral',
    'anual' || googlePlaySubscriptionAnnualProductId => 'Cobrança anual',
    _ => 'Plano ativo',
  };
}

String _currentPeriodLabel(SubscriptionStatus status) {
  final accessEndLabel = _formatDate(status.accessEndsAt);
  if (accessEndLabel == null) {
    return status.hasAccess ? 'Acesso ativo agora' : 'Aguardando confirmação';
  }

  return status.hasAccess
      ? 'Disponível até $accessEndLabel'
      : 'Previsão até $accessEndLabel';
}

String? _cancelledAccessLabel(SubscriptionStatus status) {
  final accessEndLabel = _formatDate(status.accessEndsAt);
  if (accessEndLabel == null) {
    return null;
  }

  return status.hasAccess
      ? 'Disponível ate $accessEndLabel'
      : 'Encerrado em $accessEndLabel';
}

String? _trialAccessLabel(EntitlementStatus status) {
  final trialEndLabel = _formatDate(status.trialEndsAt);
  if (trialEndLabel == null) {
    return null;
  }

  return status.hasFullAccess
      ? 'Disponível ate $trialEndLabel'
      : 'Encerrado em $trialEndLabel';
}

String? _formatDate(DateTime? value) {
  if (value == null) {
    return null;
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  return '$day/$month/$year';
}
