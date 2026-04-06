import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/profile/profile_api.dart';
import '../performance/performance_screen.dart';
import 'widgets/support_app_info_dialog.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _surface = Color(0xFF05051A);
  static const _card = Color(0xFF121D38);
  static const _cardSoft = Color(0xFF162448);
  static const _primary = Color(0xFF8E7CFF);
  static const _secondary = Color(0xFF7ED6C5);
  static const _onSurface = Color(0xFFF3F5FF);
  static const _onSurfaceMuted = Color(0xFF9AA6D1);

  static const _faqItems = <_SupportFaqItem>[
    _SupportFaqItem(
      question: 'Como recuperar o acesso a conta?',
      answer:
          'Se você perdeu o acesso, siga este fluxo:\n'
          '• abra a tela de login\n'
          '• toque em "Esqueci minha senha"\n'
          '• informe o email usado no cadastro\n'
          '• siga as instruções enviadas para redefinir sua senha\n\n'
          'Se o email não chegar, confira spam, lixo eletrônico e se o endereço digitado esta correto.',
    ),
    _SupportFaqItem(
      question: 'Onde ajusto minhas metas de estudo?',
      answer:
          'Você pode ajustar o plano direto da tela de "Início":\n'
          '• toque em "Abrir plano"\n'
          '• revise ritmo semanal e frequência\n'
          '• ajuste volume de minutos e meta de questões\n'
          '• escolha o foco que deve guiar sua rotina\n\n'
          'As alterações passam a influenciar como o app apresenta seu planejamento e a leitura da semana.',
    ),
    _SupportFaqItem(
      question: 'Como as recomendações são definidas?',
      answer:
          'As recomendações usam uma combinação de sinais do seu estudo:\n'
          '• desempenho recente por área de conhecimento e disciplina\n'
          '• pontos de atenção onde seu acerto esta mais sensível\n'
          '• prioridades salvas no seu plano de estudo\n'
          '• frentes com pouca cobertura no seu histórico\n\n'
          'A ideia é sugerir o proximo passo com mais impacto no momento, e não apenas repetir os mesmos temas aleatoriamente.',
    ),
    _SupportFaqItem(
      question: 'O que entra no desempenho recente?',
      answer:
          'A seção de desempenho recente considera sessões concluídas e mostra um resumo rápido do que acabou de acontecer:\n'
          '• percentual de acerto da sessão\n'
          '• quantidade de respostas corretas\n'
          '• tempo relativo de conclusão, como "há 5 min"\n'
          '• a tentativa mais recente de cada frente estudada\n\n'
          'Se você refizer a mesma disciplina, o app prioriza a tentativa mais nova em vez de empilhar resultados antigos.',
    ),
    _SupportFaqItem(
      question: 'Por que uma recomendação pode aparecer de novo?',
      answer:
          'Isso pode acontecer quando aquela frente continua relevante para o seu momento:\n'
          '• a disciplina ainda esta com baixa precisão\n'
          '• ela segue como prioridade no seu plano\n'
          '• ainda existe pouca cobertura de questões naquele tema\n\n'
          'As recomendações não funcionam como uma fila fixa. Elas são recalculadas com base no seu estado atual de estudo.',
    ),
    _SupportFaqItem(
      question: 'Como a sequência de estudos funciona?',
      answer:
          'A sequência acompanha quantos dias seguidos você manteve atividade de estudo:\n'
          '• responder questões ou concluir simulados conta como atividade\n'
          '• a contagem cresce dia após dia quando existe continuidade\n'
          '• se você ficar sem atividade, a sequência pode ser interrompida\n\n'
          'No Início, o número principal mostra sua sequência atual e o calendário semanal ajuda a visualizar os dias recentes.',
    ),
  ];

  void _openAccountSecurity(BuildContext context) {
    Navigator.of(context).pushNamed('account-security');
  }

  void _openStudyPlan(BuildContext context) {
    Navigator.of(context).pushNamed('study-plan');
  }

  Future<void> _openPerformance(BuildContext context) async {
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
            onSurface: _onSurface,
            onSurfaceMuted: _onSurfaceMuted,
            primary: _primary,
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Não foi possível abrir a análise agora. Tente novamente.',
          ),
          backgroundColor: _cardSoft,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: _onSurface,
        elevation: 0,
        title: const Text('Suporte e Ajuda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SupportHeroCard(),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Temas principais',
              subtitle:
                  'Atalhos para os assuntos que mais ajudam a destravar sua rotina.',
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              icon: Icons.key_rounded,
              title: 'Segurança da conta',
              subtitle:
                  'Senha, exclusão da conta e proteção do acesso do seu usuário.',
              accent: _primary,
              onTap: () => _openAccountSecurity(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              icon: Icons.flag_rounded,
              title: 'Plano e metas',
              subtitle:
                  'Ritmo semanal, volume de estudo e prioridades do seu planejamento.',
              accent: _secondary,
              onTap: () => _openStudyPlan(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              icon: Icons.analytics_rounded,
              title: 'Treino e desempenho',
              subtitle:
                  'Simulados, recomendações e leitura dos seus indicadores recentes.',
              accent: Color(0xFFFFC857),
              onTap: () => _openPerformance(context),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Perguntas frequentes',
              subtitle:
                  'Respostas rápidas para os pontos mais comuns do seu uso diário.',
            ),
            const SizedBox(height: 12),
            ..._faqItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SupportFaqCard(item: item),
              ),
            ),
            const SizedBox(height: 12),
            _SupportInfoCard(
              onShowAbout: () {
                showSupportAppInfoDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportHeroCard extends StatelessWidget {
  const _SupportHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: SupportScreen._card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9A8CFF), Color(0xFF5F6BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Central de ajuda',
                  style: GoogleFonts.manrope(
                    color: SupportScreen._onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Encontre orientações claras para conta, plano, simulados e leitura do seu progresso.',
                  style: GoogleFonts.inter(
                    color: SupportScreen._onSurfaceMuted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: SupportScreen._onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: SupportScreen._onSurfaceMuted,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SupportTopicCard extends StatelessWidget {
  const _SupportTopicCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: SupportScreen._card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: SupportScreen._onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: SupportScreen._onSurfaceMuted,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: SupportScreen._onSurfaceMuted,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportFaqCard extends StatelessWidget {
  const _SupportFaqCard({required this.item});

  final _SupportFaqItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SupportScreen._card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: SupportScreen._onSurfaceMuted,
          collapsedIconColor: SupportScreen._onSurfaceMuted,
          title: Text(
            item.question,
            style: GoogleFonts.manrope(
              color: SupportScreen._onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: GoogleFonts.inter(
                  color: SupportScreen._onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportInfoCard extends StatelessWidget {
  const _SupportInfoCard({required this.onShowAbout});

  final VoidCallback onShowAbout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SupportScreen._cardSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mais informações do app',
                  style: GoogleFonts.manrope(
                    color: SupportScreen._onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Veja detalhes da versão atual do Cognix direto nesta area.',
                  style: GoogleFonts.inter(
                    color: SupportScreen._onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          FilledButton(
            onPressed: onShowAbout,
            style: FilledButton.styleFrom(
              backgroundColor: SupportScreen._primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Ver detalhes'),
          ),
        ],
      ),
    );
  }
}

class _SupportFaqItem {
  const _SupportFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
