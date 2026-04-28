import '../../utils/api_datetime.dart';
import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.status,
    required this.canCancel,
    this.hasAccess = false,
    this.accessEndsAt,
    this.willCancelAtPeriodEnd = false,
    this.planId,
  });

  final String status;
  final bool canCancel;
  final bool hasAccess;
  final DateTime? accessEndsAt;
  final bool willCancelAtPeriodEnd;
  final String? planId;

  bool get hasSubscription => status != 'none';
  bool get isActive => status == 'active';
  bool get isCancelled => status == 'cancelled';

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final status = '${json['status'] ?? 'none'}';
    return SubscriptionStatus(
      status: status,
      canCancel: json['canCancel'] == true,
      hasAccess: json['hasAccess'] == true || status == 'active',
      accessEndsAt: parseApiDateTime(json['accessEndsAt']?.toString()),
      willCancelAtPeriodEnd: json['willCancelAtPeriodEnd'] == true,
      planId: json['planId'] is String ? json['planId'] as String : null,
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
