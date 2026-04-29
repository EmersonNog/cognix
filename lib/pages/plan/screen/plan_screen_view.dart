part of '../plan_screen.dart';

Widget _buildPlanScreenView(_PlanScreenState state, BuildContext context) {
  final colors = context.cognixColors;
  final colorScheme = Theme.of(context).colorScheme;
  final selectedPlan = state._selectedPlan;
  final selectedProductBusy =
      selectedPlan != null &&
      state._selectedProductId == selectedPlan.productId;
  final selectedPlanIsCurrentSubscription =
      selectedPlan != null &&
      _isSelectedPlanCurrentSubscriptionForState(state, selectedPlan);
  final buttonLabel = _planButtonLabelForState(
    state,
    selectedPlan: selectedPlan,
    selectedProductBusy: selectedProductBusy,
    selectedPlanIsCurrentSubscription: selectedPlanIsCurrentSubscription,
  );
  final buttonStyle = selectedPlanIsCurrentSubscription
      ? PlanButtonStyle.primary
      : state._selectedBillingPeriod == 'anual'
      ? PlanButtonStyle.primary
      : PlanButtonStyle.secondary;
  final buttonAction = selectedPlanIsCurrentSubscription
      ? () => _openSubscriptionOverviewForState(state)
      : selectedPlan == null ||
            state._isPurchaseBusy ||
            state._isLoadingPlans ||
            state._isLoadingEntitlements
      ? null
      : () => _buySelectedPlanForState(state);

  return Scaffold(
    backgroundColor: colors.surface,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Row(
            children: [
              if (!state.widget.showSkipAction) ...[
                PlanTopIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                  background: colors.surfaceContainerHigh,
                  iconColor: colors.onSurfaceMuted,
                ),
                const SizedBox(width: 12),
                Text(
                  'COGNIX',
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.primary,
                    fontSize: 15,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const Spacer(),
              if (state.widget.showSkipAction)
                TextButton(
                  onPressed: () => _dismissPlanOfferForState(state),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceMuted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Agora nao',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              else
                PlanTopIconButton(
                  icon: Icons.help_outline_rounded,
                  onTap: () => _showHelpForState(state, colors),
                  background: colors.surfaceContainerHigh,
                  iconColor: colors.onSurfaceMuted,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Escolha seu Plano',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: colors.onSurface,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Eleve seu preparo a um novo patamar\n'
            'com acesso premium, treino guiado\n'
            'e acompanhamento inteligente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          PlanBillingToggle(
            surfaceContainerHigh: colors.surfaceContainerHigh,
            onSurface: colors.onSurface,
            onSurfaceMuted: colors.onSurfaceMuted,
            selectedBackground: colors.primary,
            selectedForeground: colorScheme.onPrimary,
            selectedPeriod: state._selectedBillingPeriod,
            onChanged: (period) {
              state._applyState(() {
                state._selectedBillingPeriod = period;
                state._subscriptionConflictNotice = null;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildBillingStatusForState(state, colors),
          const SizedBox(height: 24),
          PlanCard(
            title: state._selectedBillingPeriod == 'anual' ? 'Anual' : 'Mensal',
            price: _planPriceValueForState(state, selectedPlan),
            pricePrefix: _planPricePrefixForState(state, selectedPlan),
            subtitle: _planPriceSuffixForState(state, selectedPlan),
            badge: state._selectedBillingPeriod == 'anual'
                ? 'MAIS ESTRATÉGICO'
                : null,
            floatingBadge: state._selectedBillingPeriod == 'anual',
            badgeOffsetY: state._selectedBillingPeriod == 'anual' ? -12 : 0,
            background: colors.surfaceContainer,
            surfaceContainerHigh: colors.surfaceContainerHigh,
            onSurface: colors.onSurface,
            onSurfaceMuted: colors.onSurfaceMuted,
            primary: colors.primary,
            primaryDim: colors.primaryDim,
            features: _planFeaturesForState(state, selectedPlan),
            footer: null,
            footerPrefix: state._selectedBillingPeriod == 'anual'
                ? _annualFooterPrefixForState(state)
                : _monthlyFooterPrefixForState(state, selectedPlan),
            footerHighlight: state._selectedBillingPeriod == 'anual'
                ? _annualFooterHighlightForState(state, selectedPlan)
                : _monthlyFooterHighlightForState(state, selectedPlan),
            footerSuffix: state._selectedBillingPeriod == 'anual'
                ? _annualFooterSuffixForState(state)
                : _monthlyFooterSuffixForState(state, selectedPlan),
            buttonStyle: buttonStyle,
            buttonLabel: buttonLabel,
            isLoading: selectedProductBusy,
            isPriceLoading: state._isLoadingEntitlements,
            onPressed: buttonAction,
            noticeMessage: state._subscriptionConflictNotice,
            noticeLinkLabel: state._subscriptionConflictNotice == null
                ? null
                : 'Entenda no FAQ',
            onNoticeLinkTap: state._subscriptionConflictNotice == null
                ? null
                : () => _openGooglePlaySubscriptionFaqForState(state),
            noticeColor: colors.danger,
          ),
          const SizedBox(height: 24),
          Text(
            'Benefícios Principais',
            style: GoogleFonts.manrope(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          PlanBenefitItem(
            icon: Icons.library_books_rounded,
            title: '2700+ Questões',
            subtitle: 'Treinos e simulados premium',
            onSurfaceMuted: colors.onSurfaceMuted,
            onSurface: colors.onSurface,
            surfaceContainer: colors.surfaceContainer,
            primary: colors.primary,
          ),
          const SizedBox(height: 16),
          PlanBenefitItem(
            icon: Icons.trending_up_rounded,
            title: 'Analytics',
            subtitle: 'Relatórios completos de evolução',
            onSurfaceMuted: colors.onSurfaceMuted,
            onSurface: colors.onSurface,
            surfaceContainer: colors.surfaceContainer,
            primary: colors.primary,
          ),
          const SizedBox(height: 16),
          PlanBenefitItem(
            icon: Icons.school_rounded,
            title: 'Personalizado',
            subtitle: 'Plano de estudos adaptado ao seu ritmo',
            onSurfaceMuted: colors.onSurfaceMuted,
            onSurface: colors.onSurface,
            surfaceContainer: colors.surfaceContainer,
            primary: colors.primary,
          ),
          const SizedBox(height: 16),
          PlanBenefitItem(
            icon: Icons.verified_user_rounded,
            title: 'Compra Segura',
            subtitle: 'Assinatura processada pelo Google Play',
            onSurfaceMuted: colors.onSurfaceMuted,
            onSurface: colors.onSurface,
            surfaceContainer: colors.surfaceContainer,
            primary: colors.primary,
          ),
        ],
      ),
    ),
  );
}
