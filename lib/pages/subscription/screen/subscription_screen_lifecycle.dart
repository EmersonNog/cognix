part of '../subscription_screen.dart';

void _initSubscriptionScreenState(_SubscriptionScreenState state) {
  WidgetsBinding.instance.addObserver(state);
  state._statusFuture = fetchCurrentEntitlements();
  state._googlePlayBilling = GooglePlayBillingService();
}

void _disposeSubscriptionScreenState(_SubscriptionScreenState state) {
  WidgetsBinding.instance.removeObserver(state);
}

void _handleSubscriptionScreenLifecycleStateChange(
  _SubscriptionScreenState state,
  AppLifecycleState lifecycleState,
) {
  if (lifecycleState != AppLifecycleState.resumed ||
      !state._shouldRefreshAfterGooglePlay) {
    return;
  }

  state._shouldRefreshAfterGooglePlay = false;
  unawaited(_refreshAfterGooglePlayReturnForState(state));
}
