part of '../../plan_screen.dart';

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
  if (_hasMonthlyIntroOfferForState(state, plan)) {
    return plan?.displayPriceValue ??
        _PlanScreenState._monthlyFallbackIntroPriceValue;
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
  if (_hasMonthlyIntroOfferForState(state, plan)) {
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
      'Primeiro mês por R\$ 19,90',
      'Plano de estudos inteligente',
      'Temas e recursos premium de redação',
      'Relatórios completos de desempenho',
    ];
  }

  final monthlyLead = _hasMonthlyIntroOfferForState(state, plan)
      ? 'Primeiro mês por ${plan?.displayPriceLabel ?? _PlanScreenState._monthlyFallbackIntroPriceLabel}'
      : 'Cancele quando quiser';

  return [
    monthlyLead,
    'Plano de estudos inteligente',
    'Temas e recursos premium de redação',
    'Relatórios completos de desempenho',
  ];
}
