import 'package:flutter/material.dart';

import '../../services/profile/profile_api.dart';
import '../../utils/api_datetime.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF05051A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        title: const Text('Painel pessoal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consistência diária',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _buildConsistencyMessage(profile),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                  subtitle: 'Plano atual e histórico de cobrança',
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
                  subtitle: 'Análise completa por área, constância e rendimento',
                  onTap: () {},
                  surfaceContainer: surfaceContainer,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  highlightText: 'SCORE',
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.notifications_rounded,
                  title: 'Configurações de Notificação',
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
                  subtitle: 'Central de ajuda, contato e orientações',
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
      ),
    );
  }

  String _buildConsistencyMessage(ProfileScoreData profile) {
    final lastActivityLabel = formatShortDateTime(profile.lastActivityAt);
    if (profile.activeDaysLast30 <= 0) {
      return 'Nenhuma atividade registrada nos últimos ${profile.consistencyWindowDays} dias.';
    }

    if (profile.nextLevel == null) {
      return '${profile.activeDaysLast30} dias ativos nos últimos ${profile.consistencyWindowDays}. Última atividade: $lastActivityLabel.';
    }

    return '${profile.activeDaysLast30} dias ativos nos últimos ${profile.consistencyWindowDays}. Última atividade: $lastActivityLabel. Faltam ${profile.pointsToNextLevel} pts para ${profile.nextLevel}.';
  }
}
