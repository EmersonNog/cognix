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

String _planPricePrefixForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (plan != null) {
    return '${plan.displayPricePrefix} ';
  }
  return '${_PlanScreenState._fallbackCurrencyPrefix} ';
}

String _planPriceValueForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return _annualMonthlyPriceValueForState(state, plan);
  }
  if (plan != null) {
    return plan.displayPriceValue;
  }
  return _PlanScreenState._monthlyFallbackPriceValue;
}

String _planPriceSuffixForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return ' /mês';
  }
  if (plan?.hasIntroductoryPrice == true) {
    return ' /1º mês';
  }
  return ' /mês';
}

List<String> _planFeaturesForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return const [
      '2 meses grátis no plano anual',
      'Tudo do plano mensal',
      '12 meses de acesso premium',
      'Melhor custo-benefício para uso contínuo',
      'Prioridade nas novidades do Cognix',
    ];
  }

  if (state._isLoadingEntitlements) {
    return const [
      'Oferta especial no primeiro mês',
      'Plano de estudos inteligente',
      'Temas e recursos premium de redação',
      'Relatórios completos de desempenho',
    ];
  }

  final monthlyLead = plan?.hasIntroductoryPrice == true
      ? 'Primeiro mês por ${plan?.displayPriceLabel ?? 'R\$ 9,90'}'
      : 'Cancele quando quiser';

  return [
    monthlyLead,
    'Plano de estudos inteligente',
    'Temas e recursos premium de redação',
    'Relatórios completos de desempenho',
  ];
}

String? _monthlyFooterPrefixForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return null;
  }
  if (plan?.hasIntroductoryPrice == true) {
    return 'Depois, ';
  }
  return null;
}

String? _annualFooterPrefixForState(_PlanScreenState state) {
  if (state._selectedBillingPeriod == 'anual') {
    return 'Cobrado anualmente - ';
  }
  return null;
}

String? _annualFooterHighlightForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return '${_annualRegularPriceLabelForState(state, plan)}/ano';
  }
  return null;
}

String? _annualFooterSuffixForState(_PlanScreenState state) {
  if (state._selectedBillingPeriod == 'anual') {
    return ' - 12 meses de acesso';
  }
  return null;
}

String? _monthlyFooterHighlightForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return null;
  }
  if (plan?.hasIntroductoryPrice == true) {
    final followUpPrice =
        plan?.regularPriceLabel ??
        _PlanScreenState._monthlyFallbackRegularPriceLabel;
    return '$followUpPrice/mês';
  }
  return null;
}

String? _monthlyFooterSuffixForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return null;
  }
  if (plan?.hasIntroductoryPrice == true) {
    return '. Cancele quando quiser.';
  }
  return null;
}

String _annualMonthlyPriceValueForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  final yearlyMicros = plan?.regularPricingPhase?.priceAmountMicros;
  if (yearlyMicros == null || yearlyMicros <= 0) {
    return _PlanScreenState._annualFallbackMonthlyPriceValue;
  }

  final monthlyCents = (yearlyMicros ~/ 12) ~/ 10000;
  final whole = monthlyCents ~/ 100;
  final cents = (monthlyCents % 100).toString().padLeft(2, '0');
  return '$whole,$cents';
}

String _annualRegularPriceLabelForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  final yearlyMicros = plan?.regularPricingPhase?.priceAmountMicros;
  final currencyPrefix =
      plan?.displayPricePrefix ?? _PlanScreenState._fallbackCurrencyPrefix;

  if (yearlyMicros == null || yearlyMicros <= 0) {
    return _PlanScreenState._annualFallbackRegularPriceLabel;
  }

  final yearlyCents = yearlyMicros ~/ 10000;
  final whole = yearlyCents ~/ 100;
  final cents = (yearlyCents % 100).toString().padLeft(2, '0');
  return '$currencyPrefix $whole,$cents';
}
