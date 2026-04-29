import 'package:flutter/material.dart';

import '../../services/profile/profile_api.dart';
import '../../theme/cognix_theme_colors.dart';
import 'widgets/profile_menu_item.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({
    super.key,
    required this.profile,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final ProfileScoreData profile;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final pageBackgroundColor = colors.surface;
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        surfaceTintColor: pageBackgroundColor,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Painel pessoal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: 'Conta e plano',
              subtitle: 'Acesse as configurações centrais da sua jornada.',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.key_rounded,
                  title: 'Segurança da conta',
                  subtitle: 'Senha, acesso e proteção da sua conta.',
                  onTap: () {
                    Navigator.of(context).pushNamed('account-security');
                  },
                  surfaceContainer: surfaceContainer,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  highlightText: 'CONTA',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PremiumPlanCta(
              surfaceContainer: surfaceContainer,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Suporte',
              subtitle: 'Encontre ajuda e orientações sempre que precisar.',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            ProfileMenuItem(
              icon: Icons.help_rounded,
              title: 'Suporte e Ajuda',
              subtitle: 'Central de ajuda, contato e orientações',
              onTap: () {
                Navigator.of(context).pushNamed('support');
              },
              surfaceContainer: surfaceContainer,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumPlanCta extends StatelessWidget {
  const _PremiumPlanCta({
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ProfileMenuItem(
      icon: Icons.workspace_premium_rounded,
      title: 'Plano e assinatura',
      subtitle: 'Compare os planos premium e acompanhe a sua assinatura atual.',
      onTap: () => Navigator.of(context).pushNamed('plan-hub'),
      surfaceContainer: surfaceContainer,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
      highlightText: 'PLANO',
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String title;
  final String subtitle;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: onSurfaceMuted, height: 1.45),
        ),
      ],
    );
  }
}
