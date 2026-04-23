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
                // ProfileMenuItem(
                //   icon: Icons.description_rounded,
                //   title: 'Meus Planos',
                //   subtitle: 'Plano atual e histórico de cobrança',
                //   onTap: () {
                //     Navigator.of(context).pushNamed('plan');
                //   },
                //   surfaceContainer: surfaceContainer,
                //   onSurface: onSurface,
                //   onSurfaceMuted: onSurfaceMuted,
                //   primary: primary,
                //   highlightText: 'PRO',
                // ),
                // const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.flag_rounded,
                  title: 'Metas de Estudo',
                  subtitle:
                      'Defina objetivos de ritmo, volume e foco para guiar sua rotina',
                  onTap: () {
                    Navigator.of(context).pushNamed('study-plan');
                  },
                  surfaceContainer: surfaceContainer,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  highlightText: 'META',
                ),
              ],
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
