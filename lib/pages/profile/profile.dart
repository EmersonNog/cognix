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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileHeader(
            userName: userName,
            level: 'ACADÊMICO AVANÇADO',
            questionsCount: '1500',
            studyHours: '45h',
            improvementPercentage: '78%',
            surfaceContainer: surfaceContainer,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            primaryDim: primaryDim,
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              ProfileMenuItem(
                icon: Icons.description_rounded,
                title: 'Meus Planos',
                subtitle: 'Plano atual • Fatura',
                onTap: () {
                  Navigator.of(context).pushNamed('plan');
                },
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.trending_up_rounded,
                title: 'Desempenho Detalhado',
                subtitle: 'Análise completa',
                onTap: () {},
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.notifications_rounded,
                title: 'Configurações de Notificação',
                subtitle: 'Gerenciar alertas',
                onTap: () {},
                surfaceContainer: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.help_rounded,
                title: 'Suporte & Ajuda',
                subtitle: 'Central de ajuda',
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
