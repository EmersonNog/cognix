import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/api_client.dart' show apiBaseUrl, postJson;
import '../../entitlements/entitlements_api.dart';
import '../subscription_api.dart' show googlePlayPackageName;

Future<EntitlementStatus> verifyGooglePlaySubscriptionPurchase(
  PurchaseDetails purchase,
) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/payments/google-play/subscription/verify'),
    body: {
      'platform': 'android',
      'provider': 'google_play',
      'packageName': googlePlayPackageName,
      'productId': purchase.productID,
      'purchaseId': purchase.purchaseID,
      'purchaseToken': purchase.verificationData.serverVerificationData,
      'verificationSource': purchase.verificationData.source,
      'localVerificationData': purchase.verificationData.localVerificationData,
      if (purchase.transactionDate != null)
        'transactionDate': purchase.transactionDate,
    },
    errorMessage: 'Não foi possível confirmar sua compra no Google Play.',
  );
  return EntitlementStatus.fromJson(payload);
}
