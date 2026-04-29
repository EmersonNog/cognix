part of '../subscription_screen.dart';

class _SubscriptionStatusCard extends StatelessWidget {
  const _SubscriptionStatusCard({
    required this.colors,
    required this.status,
    required this.isCancelling,
    required this.isStartingTrial,
    required this.onCancel,
    required this.onStartTrial,
    required this.onManageGooglePlaySubscription,
  }) : onRetry = null,
       _mode = _SubscriptionStatusCardMode.loaded;

  const _SubscriptionStatusCard.loading({required this.colors})
    : status = null,
      isCancelling = false,
      isStartingTrial = false,
      onCancel = null,
      onStartTrial = null,
      onManageGooglePlaySubscription = null,
      onRetry = null,
      _mode = _SubscriptionStatusCardMode.loading;

  const _SubscriptionStatusCard.error({
    required this.colors,
    required VoidCallback this.onRetry,
  }) : status = null,
       isCancelling = false,
       isStartingTrial = false,
       onCancel = null,
       onStartTrial = null,
       onManageGooglePlaySubscription = null,
       _mode = _SubscriptionStatusCardMode.error;

  final CognixThemeColors colors;
  final EntitlementStatus? status;
  final bool isCancelling;
  final bool isStartingTrial;
  final VoidCallback? onCancel;
  final VoidCallback? onStartTrial;
  final VoidCallback? onManageGooglePlaySubscription;
  final VoidCallback? onRetry;
  final _SubscriptionStatusCardMode _mode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.16),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              colors.primary.withValues(alpha: isDark ? 0.05 : 0.035),
              colors.surfaceContainer,
            ),
            colors.surfaceContainerHigh.withValues(alpha: 0.98),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -54,
            right: -24,
            child: IgnorePointer(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.primary.withValues(alpha: isDark ? 0.16 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -68,
            left: -30,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.accent.withValues(alpha: isDark ? 0.12 : 0.09),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: switch (_mode) {
              _SubscriptionStatusCardMode.loading =>
                _SubscriptionLoadingContent(colors: colors),
              _SubscriptionStatusCardMode.error => _StatusMessage(
                colors: colors,
                icon: Icons.wifi_off_rounded,
                accent: colors.danger,
                title: 'Não foi possível carregar',
                subtitle: 'Verifique sua conexão e tente novamente.',
                action: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.34),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Tentar novamente'),
                ),
              ),
              _SubscriptionStatusCardMode.loaded => _buildLoaded(context),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(BuildContext context) {
    final current = status!;
    final subscription = current.subscription;

    if (current.hasActiveTrial) {
      return _TrialActiveContent(colors: colors, status: current);
    }

    if (current.trialAvailable ||
        current.isTrialExpired ||
        !current.hasSubscription) {
      return _NoSubscriptionContent(
        colors: colors,
        status: current,
        isStartingTrial: isStartingTrial,
        onStartTrial: onStartTrial,
      );
    }

    if (subscription.isCancelled || subscription.willCancelAtPeriodEnd) {
      return _CancelledSubscriptionContent(
        colors: colors,
        status: subscription,
      );
    }

    return _ActiveSubscriptionContent(
      colors: colors,
      subscription: subscription,
      isCancelling: isCancelling,
      onCancel: onCancel,
      onManageGooglePlay: onManageGooglePlaySubscription,
    );
  }
}

enum _SubscriptionStatusCardMode { loading, error, loaded }
