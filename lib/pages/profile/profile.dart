import 'package:flutter/material.dart';

import 'widgets/profile_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.userName,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(
            userName: userName,
            level: 'ACADEMICO AVANCADO',
            questionsCount: '1500',
            studyHours: '45h',
            improvementPercentage: '78%',
            surfaceContainer: surfaceContainer,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            primaryDim: primaryDim,
          ),
          const SizedBox(height: 28),
          Text(
            'Painel pessoal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Acesse atalhos importantes e acompanhe sua evolucao com mais clareza.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: onSurfaceMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF141E39),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.workspace_premium_rounded, color: primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ritmo da semana',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Voce manteve uma cadencia forte. Continue revisando para transformar volume em precisao.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: onSurfaceMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ProfileMenuItem(
                icon: Icons.description_rounded,
                title: 'Meus Planos',
                subtitle: 'Plano atual e historico de cobranca',
                onTap: () {
                  Navigator.of(context).pushNamed('plan');
                },
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
                highlightText: 'PRO',
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.trending_up_rounded,
                title: 'Desempenho Detalhado',
                subtitle: 'Analise completa por area, constancia e rendimento',
                onTap: () {},
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
                highlightText: 'NOVO',
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.notifications_rounded,
                title: 'Configuracoes de Notificacao',
                subtitle: 'Gerenciar alertas e lembretes de estudo',
                onTap: () {},
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.help_rounded,
                title: 'Suporte e Ajuda',
                subtitle: 'Central de ajuda, contato e orientacoes',
                onTap: () {},
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
