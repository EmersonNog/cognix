part of '../plan_screen.dart';

void _initPlanScreenState(_PlanScreenState state) {
  state._googlePlayBilling = GooglePlayBillingService();
  if (state._googlePlayBilling.isSupported) {
    state._purchaseSubscription = state._googlePlayBilling.purchaseStream
        .listen(
          (purchases) {
            unawaited(_handlePurchaseUpdatesForState(state, purchases));
          },
          onError: (_) {
            _handlePurchaseStreamErrorForState(state);
          },
        );
  }
  unawaited(_loadInitialPlanDataForState(state));
}

void _disposePlanScreenState(_PlanScreenState state) {
  state._purchaseSheetFallbackTimer?.cancel();
  state._purchaseSubscription?.cancel();
}
