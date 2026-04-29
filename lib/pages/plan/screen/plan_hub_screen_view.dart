part of '../plan_hub_screen.dart';

Widget _buildPlanHubScreenView(PlanHubScreen screen, BuildContext context) {
  final palette = _PlanHubPalette.fromContext(context);

  return Scaffold(
    backgroundColor: palette.surface,
    appBar: AppBar(
      backgroundColor: palette.surface,
      surfaceTintColor: palette.surface,
      foregroundColor: palette.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text('Planos e assinatura'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlanHubHeroCard(palette: palette),
          const SizedBox(height: 24),
          _PlanHubSectionTitle(
            palette: palette,
            title: 'Temas principais',
            subtitle:
                'Escolha se você quer contratar um plano novo ou apenas acompanhar a sua assinatura atual.',
          ),
          const SizedBox(height: 12),
          _PlanHubTopicCard(
            palette: palette,
            icon: Icons.workspace_premium_rounded,
            title: 'Planos disponíveis',
            subtitle:
                'Veja as opções mensal e anual e escolha o plano ideal para você.',
            accent: palette.primary,
            onTap: () => screen._openPlanCatalog(context),
          ),
          const SizedBox(height: 12),
          _PlanHubTopicCard(
            palette: palette,
            icon: Icons.verified_user_rounded,
            title: 'Assinatura',
            subtitle:
                'Consulte seu plano atual e cancele novas cobranças quando precisar.',
            accent: palette.accent,
            onTap: () => screen._openSubscription(context),
          ),
        ],
      ),
    ),
  );
}
