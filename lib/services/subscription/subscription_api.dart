import '../../utils/api_datetime.dart';
import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;

const googlePlayPackageName = 'com.cognixhub.app';
const googlePlaySubscriptionMonthlyProductId = 'cognix_premium_monthly';
const googlePlaySubscriptionAnnualProductId = 'cognix_premium_annual';
const googlePlaySubscriptionProductIds = {
  googlePlaySubscriptionMonthlyProductId,
  googlePlaySubscriptionAnnualProductId,
};

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.status,
    required this.canCancel,
    this.hasAccess = false,
    this.accessEndsAt,
    this.willCancelAtPeriodEnd = false,
    this.planId,
    this.provider,
  });

  final String status;
  final bool canCancel;
  final bool hasAccess;
  final DateTime? accessEndsAt;
  final bool willCancelAtPeriodEnd;
  final String? planId;
  final String? provider;

  bool get hasSubscription => status != 'none';
  bool get isActive => status == 'active';
  bool get isCancelled => status == 'cancelled';
  bool get isGooglePlay =>
      provider == 'google_play' ||
      googlePlaySubscriptionProductIds.contains(planId);

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final status = '${json['status'] ?? 'none'}';
    return SubscriptionStatus(
      status: status,
      canCancel: json['canCancel'] == true,
      hasAccess: json['hasAccess'] == true || status == 'active',
      accessEndsAt: parseApiDateTime(json['accessEndsAt']?.toString()),
      willCancelAtPeriodEnd: json['willCancelAtPeriodEnd'] == true,
      planId: json['planId'] is String ? json['planId'] as String : null,
      provider: json['provider'] is String ? json['provider'] as String : null,
    );
  }
}

Future<SubscriptionStatus> fetchCurrentSubscriptionStatus() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/payments/abacatepay/subscription/current'),
    errorMessage: 'Não foi possível carregar sua assinatura.',
  );
  return SubscriptionStatus.fromJson(payload);
}

Future<void> cancelCurrentSubscription() async {
  await postJson(
    Uri.parse('${apiBaseUrl()}/payments/abacatepay/subscription/cancel'),
    body: const {},
    errorMessage: 'Não foi possível cancelar sua assinatura agora.',
  );
}
