part of '../plan_screen.dart';

Future<void> _loadInitialPlanDataForState(_PlanScreenState state) async {
  await _loadCurrentEntitlementsForState(state);
  await _loadPlansForState(state);
}

Future<void> _loadCurrentEntitlementsForState(_PlanScreenState state) async {
  state._applyState(() {
    state._isLoadingEntitlements = true;
  });

  try {
    final entitlements = await fetchCurrentEntitlements();
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._currentEntitlements = entitlements;
    });
  } catch (_) {
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._currentEntitlements = null;
    });
  } finally {
    if (state.mounted) {
      state._applyState(() {
        state._isLoadingEntitlements = false;
      });
    }
  }
}

Future<void> _loadPlansForState(_PlanScreenState state) async {
  if (!state._googlePlayBilling.isSupported || !state.mounted) {
    return;
  }

  state._applyState(() {
    state._isLoadingPlans = true;
    state._plansError = null;
  });

  try {
    final plans = await state._googlePlayBilling.loadSubscriptionProducts(
      monthlyIntroOfferEligible: state._monthlyIntroOfferEligible,
    );
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._plans = plans;
    });
  } catch (error) {
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._plansError = readableApiErrorMessage(error);
    });
  } finally {
    if (state.mounted) {
      state._applyState(() {
        state._isLoadingPlans = false;
      });
    }
  }
}

Future<void> _buySelectedPlanForState(_PlanScreenState state) async {
  final plan = state._selectedPlan;
  if (plan == null ||
      state._isPurchaseBusy ||
      state._isLoadingEntitlements ||
      _isSelectedPlanCurrentSubscriptionForState(state, plan) ||
      !state._googlePlayBilling.isSupported) {
    return;
  }

  state._applyState(() {
    state._selectedProductId = plan.productId;
    state._subscriptionConflictNotice = null;
  });

  try {
    final started = await state._googlePlayBilling.buySubscription(
      plan,
      applicationUserName: state._billingApplicationUserName,
    );
    if (!started && state.mounted) {
      state._purchaseSheetFallbackTimer?.cancel();
      state._applyState(() {
        state._selectedProductId = null;
      });
    }
    if (started && state.mounted) {
      _schedulePurchaseSheetFallbackForState(state, plan.productId);
    }
  } catch (error) {
    if (!state.mounted) {
      return;
    }
    state._purchaseSheetFallbackTimer?.cancel();
    state._applyState(() {
      state._selectedProductId = null;
    });
    final message = googlePlayBillingErrorMessage(
      readableApiErrorMessage(error),
      fallback: readableApiErrorMessage(error),
    );
    if (message == googlePlayAlreadySubscribedMessage) {
      state._applyState(() {
        state._subscriptionConflictNotice = message;
      });
    } else {
      showCognixMessage(state.context, message, type: CognixMessageType.error);
    }
  }
}

void _handlePurchaseStreamErrorForState(_PlanScreenState state) {
  if (!state.mounted) {
    return;
  }
  state._purchaseSheetFallbackTimer?.cancel();
  state._applyState(() {
    state._selectedProductId = null;
    state._isVerifyingPurchase = false;
  });
  showCognixMessage(
    state.context,
    'Não foi possível acompanhar a compra no Google Play.',
    type: CognixMessageType.error,
  );
}

Future<void> _handlePurchaseUpdatesForState(
  _PlanScreenState state,
  List<PurchaseDetails> purchases,
) async {
  for (final purchase in purchases) {
    if (!_shouldHandlePurchaseUpdate(purchase)) {
      continue;
    }
    await _handlePurchaseUpdateForState(state, purchase);
  }
}

Future<void> _handlePurchaseUpdateForState(
  _PlanScreenState state,
  PurchaseDetails purchase,
) async {
  switch (purchase.status) {
    case PurchaseStatus.pending:
      state._purchaseSheetFallbackTimer?.cancel();
      if (state.mounted) {
        state._applyState(() {
          state._selectedProductId = purchase.productID;
        });
      }
      return;
    case PurchaseStatus.error:
      if (!state.mounted) {
        return;
      }
      state._purchaseSheetFallbackTimer?.cancel();
      final message = googlePlayBillingErrorMessage(
        _purchaseErrorMessage(purchase.error),
        fallback: 'Compra recusada pelo Google Play.',
      );
      state._applyState(() {
        state._selectedProductId = null;
        state._isVerifyingPurchase = false;
        if (message == googlePlayAlreadySubscribedMessage) {
          state._subscriptionConflictNotice = message;
        }
      });
      if (message != googlePlayAlreadySubscribedMessage) {
        showCognixMessage(
          state.context,
          message,
          type: CognixMessageType.error,
        );
      }
      return;
    case PurchaseStatus.canceled:
      if (!state.mounted) {
        return;
      }
      state._purchaseSheetFallbackTimer?.cancel();
      state._applyState(() {
        state._selectedProductId = null;
        state._isVerifyingPurchase = false;
      });
      showCognixMessage(
        state.context,
        'Compra cancelada.',
        type: CognixMessageType.info,
      );
      return;
    case PurchaseStatus.purchased:
    case PurchaseStatus.restored:
      await _verifyPurchaseForState(state, purchase);
      return;
  }
}

bool _shouldHandlePurchaseUpdate(PurchaseDetails purchase) {
  if (googlePlaySubscriptionProductIds.contains(purchase.productID)) {
    return true;
  }

  return purchase.productID.isEmpty &&
      (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled);
}

String? _purchaseErrorMessage(IAPError? error) {
  final detailsMessage = error?.details?.toString().trim();
  if (detailsMessage != null &&
      detailsMessage.isNotEmpty &&
      detailsMessage != 'null') {
    return detailsMessage;
  }

  final directMessage = error?.message.trim();
  if (directMessage != null && directMessage.isNotEmpty) {
    return directMessage;
  }

  return null;
}

Future<void> _verifyPurchaseForState(
  _PlanScreenState state,
  PurchaseDetails purchase,
) async {
  if (!state.mounted) {
    return;
  }

  state._purchaseSheetFallbackTimer?.cancel();
  state._applyState(() {
    state._isVerifyingPurchase = true;
    state._selectedProductId = purchase.productID;
  });

  try {
    final entitlementStatus = await verifyGooglePlaySubscriptionPurchase(
      purchase,
    );
    await _completePurchaseIfNeededForState(state, purchase);
    if (!state.mounted) {
      return;
    }
    if (!entitlementStatus.subscription.hasAccess) {
      showCognixMessage(
        state.context,
        purchase.status == PurchaseStatus.restored
            ? 'Encontramos sua compra no Google Play, mas ela já expirou ou não possui acesso ativo.'
            : 'Compra recebida, mas o acesso ainda não foi liberado pelo servidor.',
        type: purchase.status == PurchaseStatus.restored
            ? CognixMessageType.info
            : CognixMessageType.error,
      );
      return;
    }
    if (purchase.status == PurchaseStatus.restored &&
        (entitlementStatus.subscription.isCancelled ||
            entitlementStatus.subscription.willCancelAtPeriodEnd)) {
      showCognixMessage(
        state.context,
        _cancelledRestoreMessageForState(
          entitlementStatus.subscription.accessEndsAt,
        ),
        type: CognixMessageType.info,
      );
      Navigator.of(state.context).pushReplacementNamed('subscription');
      return;
    }
    showCognixMessage(
      state.context,
      purchase.status == PurchaseStatus.restored
          ? 'Compra restaurada com sucesso.'
          : 'Assinatura confirmada com sucesso.',
      type: CognixMessageType.success,
    );
    Navigator.of(state.context).pushReplacementNamed('subscription');
  } catch (error) {
    if (!state.mounted) {
      return;
    }
    final message = googlePlayBillingErrorMessage(
      readableApiErrorMessage(error),
      fallback:
          'Compra recebida, mas ainda não foi possível confirmar no servidor.',
    ).trim();
    if (message == googlePlayAlreadySubscribedMessage) {
      state._applyState(() {
        state._subscriptionConflictNotice = message;
      });
    } else {
      showCognixMessage(state.context, message, type: CognixMessageType.error);
    }
  } finally {
    if (state.mounted) {
      state._applyState(() {
        state._selectedProductId = null;
        state._isVerifyingPurchase = false;
      });
    }
  }
}

Future<void> _completePurchaseIfNeededForState(
  _PlanScreenState state,
  PurchaseDetails purchase,
) async {
  try {
    await state._googlePlayBilling.completePurchase(purchase);
  } catch (_) {
    // The backend also acknowledges Google Play purchases after validation.
  }
}

void _schedulePurchaseSheetFallbackForState(
  _PlanScreenState state,
  String productId,
) {
  state._purchaseSheetFallbackTimer?.cancel();
  state._purchaseSheetFallbackTimer = Timer(const Duration(seconds: 3), () {
    if (!state.mounted ||
        state._isVerifyingPurchase ||
        state._selectedProductId != productId) {
      return;
    }
    state._applyState(() {
      state._selectedProductId = null;
    });
  });
}

void _openSubscriptionOverviewForState(_PlanScreenState state) {
  Navigator.of(state.context).pushNamed('subscription');
}

void _openGooglePlaySubscriptionFaqForState(_PlanScreenState state) {
  Navigator.of(state.context).pushNamed(
    'support',
    arguments: const SupportScreenArgs(
      initialFaqKey: 'google_play_existing_subscription',
    ),
  );
}

void _dismissPlanOfferForState(_PlanScreenState state) {
  final navigator = Navigator.of(state.context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }
  navigator.pushReplacementNamed('home');
}

String _cancelledRestoreMessageForState(DateTime? accessEndsAt) {
  final accessEndLabel = _formatPlanDate(accessEndsAt);
  if (accessEndLabel == null) {
    return 'Assinatura cancelada encontrada. Seu acesso permanece ativo até o fim do período pago.';
  }
  return 'Assinatura cancelada encontrada. Seu acesso permanece até $accessEndLabel.';
}

String? _formatPlanDate(DateTime? value) {
  if (value == null) {
    return null;
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  return '$day/$month/$year';
}

void _showHelpForState(_PlanScreenState state, CognixThemeColors colors) {
  showDialog(
    context: state.context,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (context) {
      return PlanHelpModal(
        primary: colors.primary,
        primaryDim: colors.primaryDim,
        onSurface: colors.onSurface,
        onSurfaceMuted: colors.onSurfaceMuted,
        background: colors.surfaceContainer,
      );
    },
  );
}
