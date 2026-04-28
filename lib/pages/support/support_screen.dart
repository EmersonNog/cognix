import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/profile/profile_api.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';
import '../performance/performance_screen.dart';
import 'widgets/support_app_info_dialog.dart';

part 'support_screen/support_cards.dart';
part 'support_screen/support_faq.dart';
part 'support_screen/support_models.dart';
part 'support_screen/support_palette.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _openAccountSecurity(BuildContext context) {
    Navigator.of(context).pushNamed('account-security');
  }

  void _openStudyPlan(BuildContext context) {
    Navigator.of(context).pushNamed('study-plan');
  }

  void _openSubscription(BuildContext context) {
    Navigator.of(context).pushNamed('subscription');
  }

  Future<void> _openPerformance(
    BuildContext context,
    _SupportPalette palette,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final profile = await fetchProfileScore();
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PerformanceScreen(
            profile: profile,
            onSurface: palette.onSurface,
            onSurfaceMuted: palette.onSurfaceMuted,
            primary: palette.primary,
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      showCognixMessage(
        context,
        'Não foi possível abrir a análise agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _SupportPalette.fromContext(context);

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: palette.surface,
        foregroundColor: palette.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Suporte e Ajuda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SupportHeroCard(palette: palette),
            const SizedBox(height: 24),
            _SectionTitle(
              palette: palette,
              title: 'Temas principais',
              subtitle:
                  'Atalhos para os assuntos que mais ajudam a destravar sua rotina.',
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.key_rounded,
              title: 'Segurança da conta',
              subtitle:
                  'Senha, exclusão da conta e proteção do acesso do seu usuário.',
              accent: palette.primary,
              onTap: () => _openAccountSecurity(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.flag_rounded,
              title: 'Plano e metas',
              subtitle:
                  'Ritmo semanal, volume de estudo e prioridades do seu planejamento.',
              accent: palette.secondary,
              onTap: () => _openStudyPlan(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.workspace_premium_rounded,
              title: 'Assinatura',
              subtitle:
                  'Consulte seu plano atual e cancele novas cobranças quando precisar.',
              accent: palette.primary,
              onTap: () => _openSubscription(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.analytics_rounded,
              title: 'Treino e desempenho',
              subtitle:
                  'Simulados, recomendações e leitura dos seus indicadores recentes.',
              accent: palette.accent,
              onTap: () => _openPerformance(context, palette),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              palette: palette,
              title: 'Perguntas frequentes',
              subtitle:
                  'Respostas rápidas para os pontos mais comuns do seu uso diário.',
            ),
            const SizedBox(height: 12),
            ..._supportFaqItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SupportFaqCard(palette: palette, item: item),
              ),
            ),
            const SizedBox(height: 12),
            _SupportInfoCard(
              palette: palette,
              onShowAbout: () => showSupportAppInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
