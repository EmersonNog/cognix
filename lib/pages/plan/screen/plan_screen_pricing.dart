part of '../plan_screen.dart';

Widget _buildBillingStatusForState(
  _PlanScreenState state,
  CognixThemeColors colors,
) {
  if (!state._googlePlayBilling.isSupported) {
    return _PlanStatusMessage(
      colors: colors,
      icon: Icons.android_rounded,
      title: 'Disponível no Android',
      message: 'A assinatura pelo app será processada pelo Google Play.',
    );
  }

  if (state._hasSubscriptionAccess) {
    return _PlanStatusMessage(
      colors: colors,
      icon: state._subscriptionWillEnd
          ? Icons.event_busy_rounded
          : Icons.verified_user_rounded,
      title: state._subscriptionWillEnd
          ? '${_currentPlanLabelForState(state)} cancelado'
          : '${_currentPlanLabelForState(state)} ativo',
      message: state._subscriptionWillEnd
          ? 'Seu acesso premium continua liberado até o fim do período pago.'
          : 'Você já possui acesso premium ativo neste momento.',
    );
  }

  if (state._isLoadingEntitlements) {
    return _PlanStatusMessage(
      colors: colors,
      icon: Icons.sync_rounded,
      title: 'Verificando acesso',
      message: 'Conferindo se já existe uma assinatura ativa na sua conta.',
    );
  }

  if (state._isLoadingPlans) {
    return _PlanStatusMessage(
      colors: colors,
      icon: Icons.hourglass_top_rounded,
      title: 'Carregando planos',
      message: 'Consultando os valores configurados no Google Play.',
    );
  }

  if (state._plansError != null) {
    return _PlanStatusMessage(
      colors: colors,
      icon: Icons.sync_problem_rounded,
      title: 'Planos indisponíveis',
      message: state._plansError!,
      action: TextButton(
        onPressed: () => _loadPlansForState(state),
        style: TextButton.styleFrom(foregroundColor: colors.primary),
        child: const Text('Tentar novamente'),
      ),
    );
  }

  return _PlanStatusMessage(
    colors: colors,
    icon: Icons.verified_rounded,
    title: 'Compra segura',
    message:
        'A assinatura renova automaticamente e pode ser cancelada pela sua conta Google Play.',
  );
}

String _planButtonLabelForState(
  _PlanScreenState state, {
  required GooglePlaySubscriptionProduct? selectedPlan,
  required bool selectedProductBusy,
  required bool selectedPlanIsCurrentSubscription,
}) {
  if (!state._googlePlayBilling.isSupported) {
    return 'Disponível no Android';
  }
  if (selectedPlanIsCurrentSubscription) {
    return state._subscriptionWillEnd
        ? 'Ver assinatura'
        : 'Gerenciar assinatura';
  }
  if (state._isLoadingEntitlements) {
    return 'Verificando acesso...';
  }
  if (selectedProductBusy) {
    return 'Abrindo Google Play...';
  }
  if (selectedPlan == null && !state._isLoadingPlans) {
    return 'Plano indisponível';
  }
  return 'Assinar agora';
}

bool _isSelectedPlanCurrentSubscriptionForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct plan,
) {
  return state._hasSubscriptionAccess &&
      state._activeSubscriptionPlanId == plan.productId;
}

String _currentPlanLabelForState(_PlanScreenState state) {
  return switch (state._activeSubscriptionPlanId) {
    googlePlaySubscriptionMonthlyProductId || 'mensal' => 'Plano mensal',
    googlePlaySubscriptionAnnualProductId || 'anual' => 'Plano anual',
    'semestral' => 'Plano semestral',
    _ => 'Plano',
  };
}
