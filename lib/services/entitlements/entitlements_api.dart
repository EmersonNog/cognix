import '../../utils/api_datetime.dart';
import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;
import '../subscription/subscription_api.dart';

class EntitlementStatus {
  const EntitlementStatus({
    required this.accessStatus,
    required this.hasFullAccess,
    required this.trialAvailable,
    required this.trialStatus,
    required this.subscription,
    this.activeSource,
    this.trialStartedAt,
    this.trialEndsAt,
  });

  final String accessStatus;
  final bool hasFullAccess;
  final String? activeSource;
  final bool trialAvailable;
  final String trialStatus;
  final DateTime? trialStartedAt;
  final DateTime? trialEndsAt;
  final SubscriptionStatus subscription;

  bool get hasActiveTrial => accessStatus == 'trial';
  bool get isTrialExpired => accessStatus == 'trial_expired';
  bool get hasSubscription => subscription.hasSubscription;

  factory EntitlementStatus.fromJson(Map<String, dynamic> json) {
    return EntitlementStatus(
      accessStatus: '${json['accessStatus'] ?? 'trial_available'}',
      hasFullAccess: json['hasFullAccess'] == true,
      activeSource: json['activeSource'] is String
          ? json['activeSource'] as String
          : null,
      trialAvailable: json['trialAvailable'] == true,
      trialStatus: '${json['trialStatus'] ?? 'not_started'}',
      trialStartedAt: parseApiDateTime(json['trialStartedAt']?.toString()),
      trialEndsAt: parseApiDateTime(json['trialEndsAt']?.toString()),
      subscription: SubscriptionStatus(
        status: '${json['subscriptionStatus'] ?? 'none'}',
        canCancel: json['subscriptionCanCancel'] == true,
        hasAccess: json['subscriptionHasAccess'] == true,
        accessEndsAt: parseApiDateTime(
          json['subscriptionAccessEndsAt']?.toString(),
        ),
        willCancelAtPeriodEnd:
            json['subscriptionWillCancelAtPeriodEnd'] == true,
        planId: json['subscriptionPlanId'] is String
            ? json['subscriptionPlanId'] as String
            : null,
      ),
    );
  }
}

Future<EntitlementStatus> fetchCurrentEntitlements() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/entitlements/current'),
    errorMessage: 'Não foi possível carregar seu acesso.',
  );
  return EntitlementStatus.fromJson(payload);
}

Future<EntitlementStatus> startTrialEntitlement() async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/entitlements/trial/start'),
    body: const {},
    errorMessage: 'Não foi possível ativar a experiencia agora.',
  );
  return EntitlementStatus.fromJson(payload);
}
