import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/entitlements/entitlements_api.dart';
import '../../services/subscription/subscription_api.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';

part 'screen/subscription_helpers.dart';
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

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Future<EntitlementStatus> _statusFuture;
  bool _isCancelling = false;
  bool _isStartingTrial = false;

  @override
  void initState() {
    super.initState();
    _statusFuture = fetchCurrentEntitlements();
  }

  Future<void> _refresh() async {
    setState(() {
      _statusFuture = fetchCurrentEntitlements();
    });
    await _statusFuture;
  }

  Future<void> _confirmCancellation(SubscriptionStatus status) async {
    final accessEndLabel = _formatDate(status.accessEndsAt);
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colors = context.cognixColors;
        return AlertDialog(
          title: const Text('Cancelar assinatura?'),
          content: Text(
            accessEndLabel == null
                ? 'O cancelamento interrompe novas cobranças. Essa ação não pode ser desfeita pela AbacatePay.'
                : 'O cancelamento interrompe novas cobranças. Seu acesso segue ate $accessEndLabel.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Voltar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cancelar assinatura'),
            ),
          ],
        );
      },
    );

    if (shouldCancel != true || !mounted) {
      return;
    }

    await _cancelSubscription();
  }

  Future<void> _cancelSubscription() async {
    setState(() {
      _isCancelling = true;
    });

    try {
      await cancelCurrentSubscription();
      if (!mounted) {
        return;
      }
      showCognixMessage(
        context,
        'Assinatura cancelada. Seu acesso segue ate o fim do período.',
        type: CognixMessageType.success,
      );
      setState(() {
        _statusFuture = fetchCurrentEntitlements();
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      showCognixMessage(
        context,
        'Não foi possível cancelar sua assinatura agora.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  Future<void> _startTrial() async {
    setState(() {
      _isStartingTrial = true;
    });

    try {
      final status = await startTrialEntitlement();
      if (!mounted) {
        return;
      }
      final endLabel = _formatDate(status.trialEndsAt);
      showCognixMessage(
        context,
        endLabel == null
            ? 'Experiência Cognix ativada.'
            : 'Experiência Cognix ativada até $endLabel.',
        type: CognixMessageType.success,
      );
      setState(() {
        _statusFuture = Future<EntitlementStatus>.value(status);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      showCognixMessage(
        context,
        'Não foi possível ativar a experiência agora.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isStartingTrial = false;
        });
      }
    }
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
        onRefresh: _refresh,
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
                    onRetry: _refresh,
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

                return _SubscriptionStatusCard(
                  colors: colors,
                  status: status,
                  isCancelling: _isCancelling,
                  isStartingTrial: _isStartingTrial,
                  onStartTrial: status.trialAvailable && !_isStartingTrial
                      ? _startTrial
                      : null,
                  onCancel: status.subscription.canCancel && !_isCancelling
                      ? () => _confirmCancellation(status.subscription)
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
