part of '../../plan_screen.dart';

String? _monthlyFooterPrefixForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return null;
  }
  if (_hasMonthlyIntroOfferForState(state, plan)) {
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
  if (_hasMonthlyIntroOfferForState(state, plan)) {
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
  if (_hasMonthlyIntroOfferForState(state, plan)) {
    return '. Cancele quando quiser.';
  }
  return null;
}
