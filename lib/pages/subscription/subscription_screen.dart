import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/core/api_client.dart' show readableApiErrorMessage;
import '../../services/entitlements/entitlements_api.dart';
import '../../services/subscription/google_play/billing_service.dart';
import '../../services/subscription/subscription_api.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';

part 'screen/subscription_helpers.dart';
part 'screen/subscription_screen_actions.dart';
part 'screen/subscription_screen_lifecycle.dart';
part 'widgets/subscription_header_card.dart';
part 'widgets/subscription_loading.dart';
part 'widgets/subscription_status_card.dart';
part 'widgets/subscription_status/active_subscription_content.dart';
part 'widgets/subscription_status/cancelled_subscription_content.dart';
part 'widgets/subscription_status/no_subscription_content.dart';
part 'widgets/subscription_status/status_badges.dart';
part 'widgets/subscription_status/trial_active_content.dart';
part 'widgets/subscription_summary.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with WidgetsBindingObserver {
  late Future<EntitlementStatus> _statusFuture;
  late final GooglePlayBillingService _googlePlayBilling;
  bool _isCancelling = false;
  bool _isStartingTrial = false;
  bool _shouldRefreshAfterGooglePlay = false;
  bool _isRefreshingAfterGooglePlay = false;

  void _applyState(VoidCallback update) {
    setState(update);
  }

  @override
  void initState() {
    super.initState();
    _initSubscriptionScreenState(this);
  }

  @override
  void dispose() {
    _disposeSubscriptionScreenState(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleSubscriptionScreenLifecycleStateChange(this, state);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Assinatura'),
      ),
      body: RefreshIndicator(
        color: colors.primary,
        backgroundColor: colors.surfaceContainerHigh,
        onRefresh: () => _refreshSubscriptionStatusForState(this),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
          children: [
            _SubscriptionHeaderCard(colors: colors),
            const SizedBox(height: 14),
            FutureBuilder<EntitlementStatus>(
              future: _statusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _SubscriptionStatusCard.loading(colors: colors);
                }

                if (snapshot.hasError) {
                  return _SubscriptionStatusCard.error(
                    colors: colors,
                    onRetry: () => _refreshSubscriptionStatusForState(this),
                  );
                }

                final status =
                    snapshot.data ??
                    const EntitlementStatus(
                      accessStatus: 'trial_available',
                      hasFullAccess: false,
                      trialAvailable: true,
                      trialStatus: 'not_started',
                      subscription: SubscriptionStatus(
                        status: 'none',
                        canCancel: false,
                      ),
                    );
                final subscription = status.subscription;

                return _SubscriptionStatusCard(
                  colors: colors,
                  status: status,
                  isCancelling: _isCancelling,
                  isStartingTrial: _isStartingTrial,
                  onStartTrial: status.trialAvailable && !_isStartingTrial
                      ? () => _startTrialForState(this)
                      : null,
                  onManageGooglePlaySubscription:
                      subscription.isGooglePlay &&
                          _googlePlayBilling.isSupported
                      ? () => _manageGooglePlaySubscriptionForState(
                          this,
                          subscription,
                        )
                      : null,
                  onCancel:
                      subscription.canCancel &&
                          !_isCancelling &&
                          !subscription.isGooglePlay
                      ? () => _confirmCancellationForState(this, subscription)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
