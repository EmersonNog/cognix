import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/profile/profile_api.dart';

class ProfilePerformanceScreen extends StatelessWidget {
  const ProfilePerformanceScreen({
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
    final disciplines = [...profile.questionsByDiscipline]
      ..sort((a, b) => b.count.compareTo(a.count));
    final totalQuestions = math.max(profile.questionsAnswered, 1);
    final activeDisciplineCount = disciplines
        .where((item) => item.count > 0)
        .length;
    final leader = disciplines.isNotEmpty ? disciplines.first : null;
    final underused = disciplines.length > 1 ? disciplines.last : leader;
    final strongestSubcategory = profile.strongestSubcategory;
    final weakestSubcategory = profile.weakestSubcategory;
    final attentionSubcategoriesCount = profile.attentionSubcategoriesCount;
    final attentionAccuracyThreshold = profile.attentionAccuracyThreshold;
    final errorCount = math.max(
      0,
      profile.questionsAnswered - profile.totalCorrect,
    );
    final averageSecondsPerQuestion = profile.questionsAnswered == 0
        ? 0
        : (profile.totalStudySeconds / profile.questionsAnswered).round();
    final hasWeeklyRhythmBase = profile.activeDaysLast30 >= 3;
    final weeklyQuestionAverage = profile.consistencyWindowDays == 0
        ? 0.0
        : (profile.questionsAnswered / profile.consistencyWindowDays) * 7;
    final secondsPerSimulation = profile.completedSessions == 0
        ? 0
        : (profile.totalStudySeconds / profile.completedSessions).round();

    return Scaffold(
      backgroundColor: const Color(0xFF05051A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        title: const Text('Painel de desempenho'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Indicadores do momento',
              subtitle:
                  'Leituras derivadas da API para enxergar intensidade, distribuição e cobertura da sua rotina.',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Pontos de atenção',
                    value: '$attentionSubcategoriesCount',
                    helper: weakestSubcategory == null
                        ? 'Ainda não há subcategorias com base suficiente para identificar alertas.'
                        : attentionSubcategoriesCount == 0
                        ? 'Nenhuma subcategoria ficou abaixo de ${attentionAccuracyThreshold.toStringAsFixed(0)}% de acerto'
                        : '${_shortSubcategoryName(weakestSubcategory.subcategory)} é a mais sensível agora.',
                    icon: Icons.warning_amber_rounded,
                    accent: const Color(0xFF7C9BFF),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Maior acerto',
                    value: strongestSubcategory == null
                        ? '--'
                        : '${strongestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                    helper: strongestSubcategory == null
                        ? 'Ainda não há subcategorias com base suficiente para comparar.'
                        : '${_shortSubcategoryName(strongestSubcategory.subcategory)}\n${_shortDisciplineName(strongestSubcategory.discipline)} • ${_attemptsLabel(strongestSubcategory.totalAttempts)}',
                    icon: Icons.emoji_events_rounded,
                    accent: const Color(0xFFC28BFF),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Tempo por simulado',
                    value: _formatSeconds(secondsPerSimulation),
                    helper: profile.completedSessions == 0
                        ? 'Conclua simulados para liberar essa média.'
                        : 'Média sobre ${profile.completedSessions} simulados concluídos.',
                    icon: Icons.flag_rounded,
                    accent: const Color(0xFFFFC857),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Menor acerto',
                    value: weakestSubcategory == null
                        ? '--'
                        : '${weakestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                    helper: weakestSubcategory == null
                        ? 'Ainda não há subcategorias com base suficiente para comparar'
                        : '${_shortSubcategoryName(weakestSubcategory.subcategory)}\n${_shortDisciplineName(weakestSubcategory.discipline)} • ${_attemptsLabel(weakestSubcategory.totalAttempts)}',
                    icon: Icons.troubleshoot_rounded,
                    accent: const Color(0xFF4ED7A6),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'Leitura por disciplina',
              subtitle:
                  'Aqui o foco é peso relativo: onde seu volume já tem tração e onde ainda falta presença.',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SpotlightCard(
                  title: 'Maior presença',
                  value: leader == null
                      ? 'Sem dados'
                      : _shortDisciplineName(leader.discipline),
                  subtitle: leader == null
                      ? 'Assim que você responder questões, essa leitura aparece.'
                      : '${_disciplineShare(leader.count, totalQuestions)} do seu histórico está aqui.',
                  accent: leader == null
                      ? const Color(0xFF7C88A8)
                      : _disciplineAccent(leader.discipline),
                  icon: Icons.trending_up_rounded,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                ),
                const SizedBox(height: 12),
                _SpotlightCard(
                  title: 'Mais espaço para crescer',
                  value: underused == null
                      ? 'Sem leitura'
                      : _shortDisciplineName(underused.discipline),
                  subtitle: underused == null
                      ? 'Ainda não há base suficiente para comparar áreas.'
                      : '${_disciplineShare(underused.count, totalQuestions)} do volume atual passa por essa área.',
                  accent: underused == null
                      ? const Color(0xFF7C88A8)
                      : _disciplineAccent(underused.discipline),
                  icon: Icons.radar_rounded,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                ),
              ],
            ),
            if (disciplines.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A33),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.045)),
                ),
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < disciplines.length;
                      index++
                    ) ...[
                      _DisciplineBreakdownRow(
                        label: _shortDisciplineName(
                          disciplines[index].discipline,
                        ),
                        count: disciplines[index].count,
                        share: disciplines[index].count / totalQuestions,
                        accent: _disciplineAccent(
                          disciplines[index].discipline,
                        ),
                        onSurface: onSurface,
                        onSurfaceMuted: onSurfaceMuted,
                      ),
                      if (index != disciplines.length - 1)
                        const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'Eficiência e ritmo',
              subtitle:
                  'Mais do que volume, essa leitura mostra a qualidade do seu tempo e das suas respostas.',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Acertos',
                    value: '${profile.totalCorrect}',
                    helper: profile.questionsAnswered == 0
                        ? 'Suas respostas certas aparecem aqui.'
                        : '${profile.accuracyPercent.toStringAsFixed(0)}% do volume virou acerto.',
                    icon: Icons.check_circle_rounded,
                    accent: const Color(0xFF4ED7A6),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Erros úteis',
                    value: '$errorCount',
                    helper: errorCount == 0
                        ? 'Nenhum erro relevante no histórico.'
                        : 'Pontos com mais espaço para revisão.',
                    icon: Icons.refresh_rounded,
                    accent: const Color(0xFFFF9D6C),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Tempo por questão',
                    value: _formatSeconds(averageSecondsPerQuestion),
                    helper: profile.questionsAnswered == 0
                        ? 'A média aparece com suas respostas.'
                        : 'Tempo médio gasto por questão.',
                    icon: Icons.timer_outlined,
                    accent: const Color(0xFF7C9BFF),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: hasWeeklyRhythmBase
                        ? 'Média semanal'
                        : 'Volume inicial',
                    value: hasWeeklyRhythmBase
                        ? (weeklyQuestionAverage == 0
                              ? '0'
                              : weeklyQuestionAverage.toStringAsFixed(1))
                        : '${profile.questionsAnswered}',
                    helper: profile.questionsAnswered == 0
                        ? 'Sem questões recentes para calcular.'
                        : hasWeeklyRhythmBase
                        ? 'Questões respondidas por semana, em média.'
                        : 'Questões acumuladas nos seus primeiros dias.',
                    icon: Icons.bolt_rounded,
                    accent: const Color(0xFFFFC857),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _PerformanceInsightCard(
              title: 'Leitura do cenário',
              description: _buildPerformanceNarrative(
                leaderDiscipline: leader?.discipline,
                activeDisciplineCount: activeDisciplineCount,
                activeDaysLast30: profile.activeDaysLast30,
                consistencyWindowDays: profile.consistencyWindowDays,
                accuracyPercent: profile.accuracyPercent,
                completedSessions: profile.completedSessions,
              ),
              primary: primary,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
          style: GoogleFonts.manrope(
            color: onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: onSurfaceMuted,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SpotlightCard extends StatelessWidget {
  const _SpotlightCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF101A33),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 11.8,
                    height: 1.35,
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

class _DisciplineBreakdownRow extends StatelessWidget {
  const _DisciplineBreakdownRow({
    required this.label,
    required this.count,
    required this.share,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String label;
  final int count;
  final double share;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$count questões',
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: share.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(share * 100).toStringAsFixed(0)}% do volume atual',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;

  static const double _cardHeight = 176;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101A33),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.75,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            helper,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 11.5,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PerformanceInsightCard extends StatelessWidget {
  const _PerformanceInsightCard({
    required this.title,
    required this.description,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String title;
  final String description;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF111C38), const Color(0xFF0D1730)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.insights_rounded, color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Resumo editorial do seu momento atual',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted.withOpacity(0.9),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.035),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Text(
              description,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 12.6,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _shortDisciplineName(String value) {
  final normalized = value.trim().toLowerCase();

  if (normalized.contains('linguagens')) {
    return 'Linguagens';
  }

  if (normalized.contains('humanas')) {
    return 'Ciências Humanas';
  }

  if (normalized.contains('natureza')) {
    return 'Ciências da Natureza';
  }

  if (normalized.contains('matem')) {
    return 'Matemática';
  }

  return value;
}

String _shortSubcategoryName(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= 28) {
    return trimmed;
  }

  return '${trimmed.substring(0, 28).trimRight()}...';
}

Color _disciplineAccent(String value) {
  switch (value.trim().toLowerCase()) {
    case 'linguagens, cÃ³digos e suas tecnologias':
    case 'linguagens, codigos e suas tecnologias':
      return const Color(0xFF7C9BFF);
    case 'ciências humanas e suas tecnologias':
    case 'ciencias humanas e suas tecnologias':
      return const Color(0xFFFF8A65);
    case 'ciências da natureza e suas tecnologias':
    case 'ciencias da natureza e suas tecnologias':
      return const Color(0xFF49D7A8);
    case 'matemática e suas tecnologias':
    case 'matematica e suas tecnologias':
      return const Color(0xFFFFC857);
    default:
      return const Color(0xFF8E7CFF);
  }
}

String _disciplineShare(int count, int totalQuestions) {
  final ratio = totalQuestions == 0 ? 0 : (count / totalQuestions * 100);
  return '${ratio.toStringAsFixed(0)}%';
}

String _attemptsLabel(int value) {
  return value == 1 ? '1 tentativa.' : '$value tentativas.';
}

String _formatSeconds(int value) {
  if (value <= 0) {
    return '0m';
  }

  if (value < 60) {
    return '${value}s';
  }

  final minutes = value ~/ 60;
  final seconds = value % 60;
  if (minutes >= 60) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  return seconds == 0 ? '${minutes}m' : '${minutes}m ${seconds}s';
}

String _buildPerformanceNarrative({
  required String? leaderDiscipline,
  required int activeDisciplineCount,
  required int activeDaysLast30,
  required int consistencyWindowDays,
  required double accuracyPercent,
  required int completedSessions,
}) {
  final focus = leaderDiscipline == null
      ? 'Seu histórico ainda está distribuindo volume entre poucas referências.'
      : 'Você mostra mais presença em ${_shortDisciplineName(leaderDiscipline)}.';

  final coverage = activeDisciplineCount >= 4
      ? 'Seu treino já passou por todas as áreas de conhecimentos.'
      : activeDisciplineCount >= 2
      ? 'Seu estudo já está mais distribuído, mas ainda pode ganhar mais equilíbrio entre as áreas.'
      : 'Seu estudo ainda está concentrado em poucas áreas.';

  final rhythm = activeDaysLast30 >= (consistencyWindowDays * 0.7)
      ? 'A rotina recente indica uma cadência forte.'
      : activeDaysLast30 >= (consistencyWindowDays * 0.4)
      ? 'A rotina já tem uma base boa, mas ainda pede mais regularidade.'
      : 'Seu desempenho ainda depende bastante de ganhar frequência.';

  final quality = accuracyPercent >= 75
      ? 'Sua taxa de acerto está em um bom nível.'
      : accuracyPercent >= 55
      ? 'Sua taxa de acerto está evoluindo, mas ainda há espaço para ganhar mais consistência.'
      : 'Sua taxa de acerto ainda pede mais revisão e reforço nos estudos.';

  final simulation = completedSessions >= 15
      ? 'Seu histórico de simulados já oferece uma leitura mais consistente do seu comportamento.'
      : completedSessions >= 5
      ? 'Você já tem uma base inicial de simulados para observar seu comportamento.'
      : 'Ainda há espaço para usar mais simulados como referência do seu desempenho.';

  return '$focus $coverage $rhythm $quality $simulation';
}
