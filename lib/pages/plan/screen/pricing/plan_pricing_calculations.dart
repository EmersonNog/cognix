part of '../../plan_screen.dart';

bool _hasMonthlyIntroOfferForState(
  _PlanScreenState state,
  GooglePlaySubscriptionProduct? plan,
) {
  if (state._selectedBillingPeriod == 'anual') {
    return false;
  }
  if (plan?.hasIntroductoryPrice == true) {
    return true;
  }
  return plan == null &&
      (state._monthlyIntroOfferEligible || state._isLoadingEntitlements);
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
