import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../services/core/api_client.dart' show readableApiErrorMessage;
import '../../services/entitlements/entitlements_api.dart';
import '../../services/subscription/google_play/billing_errors.dart';
import '../../services/subscription/google_play/billing_service.dart';
import '../../services/subscription/google_play/purchase_verifier.dart';
import '../../services/subscription/google_play/subscription_product.dart';
import '../../services/subscription/subscription_api.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';
import '../support/support_screen.dart';
import 'widgets/plan_benefit_item.dart';
import 'widgets/plan_billing_toggle.dart';
import 'widgets/plan_button.dart';
import 'widgets/plan_card.dart';
import 'widgets/plan_help_modal.dart';
import 'widgets/plan_top_icon_button.dart';

part 'screen/plan_screen_actions.dart';
part 'screen/plan_screen_lifecycle.dart';
part 'screen/plan_screen_pricing.dart';
part 'screen/plan_screen_view.dart';
part 'screen/pricing/plan_pricing_calculations.dart';
part 'screen/pricing/plan_pricing_display.dart';
part 'screen/pricing/plan_pricing_footer.dart';
part 'widgets/plan_status_message.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key, this.showSkipAction = false});

  final bool showSkipAction;

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class PlanScreenArgs {
  const PlanScreenArgs({this.showSkipAction = false});

  final bool showSkipAction;
}

class _PlanScreenState extends State<PlanScreen> {
  static const _fallbackCurrencyPrefix = 'R\$';
  static const _monthlyFallbackIntroPriceValue = '19,90';
  static const _monthlyFallbackIntroPriceLabel = 'R\$ 19,90';
  static const _monthlyFallbackPriceValue = '29,90';
  static const _monthlyFallbackRegularPriceLabel = 'R\$ 29,90';
  static const _annualFallbackMonthlyPriceValue = '24,91';
  static const _annualFallbackRegularPriceLabel = 'R\$ 299,00';

  late final GooglePlayBillingService _googlePlayBilling;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Timer? _purchaseSheetFallbackTimer;

  String _selectedBillingPeriod = 'mensal';
  List<GooglePlaySubscriptionProduct> _plans = const [];
  EntitlementStatus? _currentEntitlements;
  bool _isLoadingPlans = false;
  bool _isLoadingEntitlements = true;
  bool _isVerifyingPurchase = false;
  String? _plansError;
  String? _selectedProductId;
  String? _subscriptionConflictNotice;

  void _applyState(VoidCallback update) {
    setState(update);
  }

  @override
  void initState() {
    super.initState();
    _initPlanScreenState(this);
  }

  @override
  void dispose() {
    _disposePlanScreenState(this);
    super.dispose();
  }

  GooglePlaySubscriptionProduct? get _selectedPlan {
    final productId = _selectedBillingPeriod == 'anual'
        ? googlePlaySubscriptionAnnualProductId
        : googlePlaySubscriptionMonthlyProductId;

    for (final plan in _plans) {
      if (plan.productId == productId) {
        return plan;
      }
    }
    return null;
  }

  bool get _isPurchaseBusy =>
      _selectedProductId != null || _isVerifyingPurchase;
  bool get _hasSubscriptionAccess =>
      _currentEntitlements?.subscription.hasAccess == true;
  bool get _subscriptionWillEnd =>
      _currentEntitlements?.subscription.isCancelled == true ||
      _currentEntitlements?.subscription.willCancelAtPeriodEnd == true;
  String? get _activeSubscriptionPlanId =>
      _currentEntitlements?.subscription.planId;
  bool get _monthlyIntroOfferEligible =>
      _currentEntitlements?.eligibleForMonthlyIntroOffer == true;
  String? get _billingApplicationUserName =>
      FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return _buildPlanScreenView(this, context);
  }
}
