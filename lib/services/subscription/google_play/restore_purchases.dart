import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../entitlements/entitlements_api.dart';
import '../subscription_api.dart';
import 'billing_errors.dart';
import 'billing_service.dart';
import 'purchase_verifier.dart';

class GooglePlayRestorePurchasesResult {
  const GooglePlayRestorePurchasesResult._({
    required this.purchaseRestored,
    this.entitlementStatus,
  });

  const GooglePlayRestorePurchasesResult.restored(
    EntitlementStatus entitlementStatus,
  ) : this._(purchaseRestored: true, entitlementStatus: entitlementStatus);

  const GooglePlayRestorePurchasesResult.notFound()
    : this._(purchaseRestored: false);

  final bool purchaseRestored;
  final EntitlementStatus? entitlementStatus;

  SubscriptionStatus? get restoredSubscription =>
      entitlementStatus?.subscription;

  bool get restoredAccessGranted => restoredSubscription?.hasAccess == true;

  bool get restoredSubscriptionIsCancelled =>
      restoredSubscription?.isCancelled == true ||
      restoredSubscription?.willCancelAtPeriodEnd == true;
}

Future<GooglePlayRestorePurchasesResult> restoreGooglePlayPurchases({
  String? applicationUserName,
  GooglePlayBillingService? billingService,
  Duration timeout = const Duration(seconds: 8),
}) async {
  final billing = billingService ?? GooglePlayBillingService();
  if (!billing.isSupported) {
    throw const GooglePlayBillingException(
      'A restauração de compras está disponível apenas no Android.',
    );
  }

  final completer = Completer<GooglePlayRestorePurchasesResult>();
  StreamSubscription<List<PurchaseDetails>>? purchaseSubscription;
  Timer? timeoutTimer;

  Future<void> completeWithResult(
    GooglePlayRestorePurchasesResult result,
  ) async {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
  }

  Future<void> completeWithError(Object error, [StackTrace? stackTrace]) async {
    if (!completer.isCompleted) {
      completer.completeError(error, stackTrace);
    }
  }

  purchaseSubscription = billing.purchaseStream.listen(
    (purchases) {
      unawaited(
        _handleRestorePurchaseUpdates(
          purchases: purchases,
          billing: billing,
          onRestored: completeWithResult,
          onError: completeWithError,
        ),
      );
    },
    onError: (Object error, StackTrace stackTrace) {
      unawaited(completeWithError(error, stackTrace));
    },
  );

  try {
    await billing.restorePurchases(applicationUserName: applicationUserName);
    timeoutTimer = Timer(timeout, () {
      unawaited(
        completeWithResult(const GooglePlayRestorePurchasesResult.notFound()),
      );
    });
    return await completer.future;
  } finally {
    timeoutTimer?.cancel();
    await purchaseSubscription.cancel();
  }
}

Future<void> _handleRestorePurchaseUpdates({
  required List<PurchaseDetails> purchases,
  required GooglePlayBillingService billing,
  required Future<void> Function(GooglePlayRestorePurchasesResult result)
  onRestored,
  required Future<void> Function(Object error, [StackTrace? stackTrace])
  onError,
}) async {
  GooglePlayRestorePurchasesResult? inactiveRestoredResult;

  for (final purchase in purchases) {
    if (!googlePlaySubscriptionProductIds.contains(purchase.productID)) {
      continue;
    }

    switch (purchase.status) {
      case PurchaseStatus.pending:
        continue;
      case PurchaseStatus.error:
        await onError(
          GooglePlayBillingException(
            googlePlayBillingErrorMessage(
              purchase.error?.message,
              fallback: 'Não foi possível restaurar sua compra no Google Play.',
            ),
          ),
        );
        return;
      case PurchaseStatus.canceled:
        continue;
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        try {
          final entitlementStatus = await verifyGooglePlaySubscriptionPurchase(
            purchase,
          );
          await billing.completePurchase(purchase);
          final result = GooglePlayRestorePurchasesResult.restored(
            entitlementStatus,
          );
          if (result.restoredAccessGranted) {
            await onRestored(result);
            return;
          }
          inactiveRestoredResult ??= result;
        } catch (error, stackTrace) {
          await onError(error, stackTrace);
          return;
        }
    }
  }

  if (inactiveRestoredResult != null) {
    await onRestored(inactiveRestoredResult);
  }
}
