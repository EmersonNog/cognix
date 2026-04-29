import '../../utils/api_datetime.dart';
import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;
import '../subscription/subscription_api.dart';

const _defaultAccessStatus = 'trial_available';
const _defaultTrialStatus = 'not_started';

class EntitlementStatus {
  const EntitlementStatus({
    required this.accessStatus,
    required this.hasFullAccess,
    required this.trialAvailable,
    required this.trialStatus,
    required this.subscription,
    this.activeSource,
    this.eligibleForMonthlyIntroOffer = false,
    this.trialStartedAt,
    this.trialEndsAt,
  });

  final String accessStatus;
  final bool hasFullAccess;
  final String? activeSource;
  final bool eligibleForMonthlyIntroOffer;
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
      accessStatus: _stringValue(
        json,
        'accessStatus',
        fallback: _defaultAccessStatus,
      ),
      hasFullAccess: _boolValue(json, 'hasFullAccess'),
      activeSource: _nullableStringValue(json, 'activeSource'),
      eligibleForMonthlyIntroOffer: _eligibleForMonthlyIntroOfferFromJson(json),
      trialAvailable: _boolValue(json, 'trialAvailable'),
      trialStatus: _stringValue(
        json,
        'trialStatus',
        fallback: _defaultTrialStatus,
      ),
      trialStartedAt: _dateTimeValue(json, 'trialStartedAt'),
      trialEndsAt: _dateTimeValue(json, 'trialEndsAt'),
      subscription: _subscriptionStatusFromEntitlementsJson(json),
    );
  }
}

Future<EntitlementStatus> fetchCurrentEntitlements() async {
  return _fetchEntitlementStatus(
    endpoint: '/entitlements/current',
    errorMessage: 'Não foi possível carregar seu acesso.',
  );
}

Future<EntitlementStatus> startTrialEntitlement() async {
  return _postEntitlementStatus(
    endpoint: '/entitlements/trial/start',
    errorMessage: 'Não foi possível ativar a experiêsncia agora.',
  );
}

Future<EntitlementStatus> _fetchEntitlementStatus({
  required String endpoint,
  required String errorMessage,
}) async {
  final payload = await getJson(
    _entitlementsUri(endpoint),
    errorMessage: errorMessage,
  );
  return EntitlementStatus.fromJson(payload);
}

Future<EntitlementStatus> _postEntitlementStatus({
  required String endpoint,
  required String errorMessage,
}) async {
  final payload = await postJson(
    _entitlementsUri(endpoint),
    body: const {},
    errorMessage: errorMessage,
  );
  return EntitlementStatus.fromJson(payload);
}

Uri _entitlementsUri(String endpoint) => Uri.parse('${apiBaseUrl()}$endpoint');

SubscriptionStatus _subscriptionStatusFromEntitlementsJson(
  Map<String, dynamic> json,
) {
  return SubscriptionStatus(
    status: _stringValue(json, 'subscriptionStatus', fallback: 'none'),
    canCancel: _boolValue(json, 'subscriptionCanCancel'),
    hasAccess: _boolValue(json, 'subscriptionHasAccess'),
    accessEndsAt: _dateTimeValue(json, 'subscriptionAccessEndsAt'),
    willCancelAtPeriodEnd: _boolValue(
      json,
      'subscriptionWillCancelAtPeriodEnd',
    ),
    planId: _nullableStringValue(json, 'subscriptionPlanId'),
    provider: _nullableStringValue(json, 'subscriptionProvider'),
  );
}

bool _eligibleForMonthlyIntroOfferFromJson(Map<String, dynamic> json) {
  return _boolValue(json, 'eligibleForMonthlyIntroOffer') ||
      _boolValue(json, 'monthlyIntroOfferEligible') ||
      _boolValue(json, 'eligible_for_monthly_intro_offer');
}

bool _boolValue(Map<String, dynamic> json, String key) => json[key] == true;

String _stringValue(
  Map<String, dynamic> json,
  String key, {
  required String fallback,
}) {
  return '${json[key] ?? fallback}';
}

String? _nullableStringValue(Map<String, dynamic> json, String key) {
  return json[key] is String ? json[key] as String : null;
}

DateTime? _dateTimeValue(Map<String, dynamic> json, String key) {
  return parseApiDateTime(json[key]?.toString());
}
