part of '../subscription_screen.dart';

Future<void> _refreshSubscriptionStatusForState(
  _SubscriptionScreenState state,
) async {
  state._applyState(() {
    state._statusFuture = fetchCurrentEntitlements();
  });
  await state._statusFuture;
}

Future<void> _refreshAfterGooglePlayReturnForState(
  _SubscriptionScreenState state,
) async {
  if (state._isRefreshingAfterGooglePlay) {
    return;
  }

  state._isRefreshingAfterGooglePlay = true;
  try {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._statusFuture = fetchCurrentEntitlements();
    });
    await state._statusFuture;
  } catch (_) {
    // O FutureBuilder exibirá o erro de carregamento no próprio card.
  } finally {
    state._isRefreshingAfterGooglePlay = false;
  }
}

Future<void> _manageGooglePlaySubscriptionForState(
  _SubscriptionScreenState state,
  SubscriptionStatus status,
) async {
  state._shouldRefreshAfterGooglePlay = true;
  try {
    await state._googlePlayBilling.openSubscriptionManagement(
      productId: status.planId,
    );
  } catch (error) {
    state._shouldRefreshAfterGooglePlay = false;
    if (!state.mounted) {
      return;
    }
    showCognixMessage(
      state.context,
      readableApiErrorMessage(error),
      type: CognixMessageType.error,
    );
  }
}

Future<void> _confirmCancellationForState(
  _SubscriptionScreenState state,
  SubscriptionStatus status,
) async {
  final accessEndLabel = _formatDate(status.accessEndsAt);
  final shouldCancel = await showDialog<bool>(
    context: state.context,
    builder: (context) {
      final colors = context.cognixColors;
      return AlertDialog(
        title: const Text('Cancelar assinatura?'),
        content: Text(
          accessEndLabel == null
              ? 'O cancelamento interrompe novas cobranças. Essa ação não pode ser desfeita pela AbacatePay.'
              : 'O cancelamento interrompe novas cobranças. Seu acesso segue até $accessEndLabel.',
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

  if (shouldCancel != true || !state.mounted) {
    return;
  }

  await _cancelSubscriptionForState(state);
}

Future<void> _cancelSubscriptionForState(_SubscriptionScreenState state) async {
  state._applyState(() {
    state._isCancelling = true;
  });

  try {
    await cancelCurrentSubscription();
    if (!state.mounted) {
      return;
    }
    showCognixMessage(
      state.context,
      'Assinatura cancelada. Seu acesso segue até o fim do perísodo.',
      type: CognixMessageType.success,
    );
    state._applyState(() {
      state._statusFuture = fetchCurrentEntitlements();
    });
  } catch (_) {
    if (!state.mounted) {
      return;
    }
    showCognixMessage(
      state.context,
      'Não foi possível cancelar sua assinatura agora.',
      type: CognixMessageType.error,
    );
  } finally {
    if (state.mounted) {
      state._applyState(() {
        state._isCancelling = false;
      });
    }
  }
}

Future<void> _startTrialForState(_SubscriptionScreenState state) async {
  state._applyState(() {
    state._isStartingTrial = true;
  });

  try {
    final status = await startTrialEntitlement();
    if (!state.mounted) {
      return;
    }
    final endLabel = _formatDate(status.trialEndsAt);
    showCognixMessage(
      state.context,
      endLabel == null
          ? 'Experiência Cognix ativada.'
          : 'Experiência Cognix ativada até $endLabel.',
      type: CognixMessageType.success,
    );
    state._applyState(() {
      state._statusFuture = Future<EntitlementStatus>.value(status);
    });
  } catch (_) {
    if (!state.mounted) {
      return;
    }
    showCognixMessage(
      state.context,
      'Não foi possível ativar a experiência agora.',
      type: CognixMessageType.error,
    );
  } finally {
    if (state.mounted) {
      state._applyState(() {
        state._isStartingTrial = false;
      });
    }
  }
}
