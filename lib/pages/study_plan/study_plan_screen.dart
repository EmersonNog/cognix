import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/questions/questions_api.dart';
import '../../services/study_plan/study_plan_api.dart';
import '../../services/study_plan/study_plan_refresh_notifier.dart';
import 'widgets/study_plan_widgets.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  static const _periodOptions = <String, String>{
    'flexivel': 'Flexivel',
    'manha': 'Manha',
    'tarde': 'Tarde',
    'noite': 'Noite',
  };

  static const _minutesOptions = <int>[30, 45, 60, 90, 120, 150];
  static const _questionOptions = <int>[20, 40, 60, 80, 120, 160];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  List<String> _availableDisciplines = const [];
  StudyPlanData _plan = const StudyPlanData.empty();
  _StudyPlanDraft _draft = _StudyPlanDraft.fromPlan(
    const StudyPlanData.empty(),
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait<Object>([
        fetchStudyPlan(),
        fetchDisciplines(),
      ]);
      if (!mounted) {
        return;
      }

      final plan = results[0] as StudyPlanData;
      final disciplines = results[1] as List<String>;
      setState(() {
        _plan = plan;
        _draft = _StudyPlanDraft.fromPlan(plan);
        _availableDisciplines = disciplines;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Nao foi possivel carregar seu plano agora.';
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final savedPlan = await saveStudyPlan(
        studyDaysPerWeek: _draft.studyDaysPerWeek,
        minutesPerDay: _draft.minutesPerDay,
        weeklyQuestionsGoal: _draft.weeklyQuestionsGoal,
        focusMode: _draft.focusMode,
        preferredPeriod: _draft.preferredPeriod,
        priorityDisciplines: _draft.priorityDisciplines,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _plan = savedPlan;
        _draft = _StudyPlanDraft.fromPlan(savedPlan);
      });
      studyPlanRefreshNotifier.markDirty();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plano de estudos salvo.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel salvar o plano.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _toggleDiscipline(String discipline) {
    setState(() {
      final next = List<String>.from(_draft.priorityDisciplines);
      if (next.contains(discipline)) {
        next.remove(discipline);
      } else if (next.length < 4) {
        next.add(discipline);
      }
      _draft = _draft.copyWith(priorityDisciplines: next);
    });
  }

  @override
  Widget build(BuildContext context) {
    const palette = _StudyPlanPalette();
    final preview = _buildPreviewProgress(_draft, _plan);

    return Scaffold(
      backgroundColor: palette.surface,
      body: SafeArea(
        child: Stack(
          children: [
            _StudyPlanBackground(palette: palette),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _StudyPlanHeader(
                    palette: palette,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildBody(palette, preview)),
                _StudyPlanFooterBar(
                  palette: palette,
                  isSaving: _isSaving,
                  onSave: _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(_StudyPlanPalette palette, _StudyPlanPreview preview) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_tethering_error_rounded,
                color: palette.primary,
                size: 36,
              ),
              const SizedBox(height: 14),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: palette.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tente novamente para abrir seu plano de estudos.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: palette.onSurfaceMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _load,
                style: FilledButton.styleFrom(
                  backgroundColor: palette.surfaceContainerHigh,
                ),
                child: const Text('Recarregar'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      children: [
        _PlanHeroCard(
          palette: palette,
          configured: _plan.configured,
          weeklyCompletionPercent: preview.weeklyCompletionPercent,
          activeDaysValue:
              '${_plan.activeDaysThisWeek}/${_draft.studyDaysPerWeek}',
          minutesValue:
              '${_plan.completedMinutesThisWeek}/${preview.weeklyMinutesTarget}',
          questionsValue:
              '${_plan.answeredQuestionsThisWeek}/${_draft.weeklyQuestionsGoal}',
          updatedAt: _plan.updatedAt,
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Ritmo semanal',
          subtitle:
              'Escolha em quantos dias voce quer distribuir seus estudos.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(7, (index) {
              final value = index + 1;
              return StudyPlanChoiceChip(
                label: '$value dias',
                selected: _draft.studyDaysPerWeek == value,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(studyDaysPerWeek: value),
                ),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Carga diaria',
          subtitle: 'Defina o tempo medio que voce quer dedicar por dia ativo.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _minutesOptions.map((value) {
              return StudyPlanChoiceChip(
                label: '$value min',
                selected: _draft.minutesPerDay == value,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(minutesPerDay: value),
                ),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Meta de questoes',
          subtitle: 'Use uma meta semanal clara para acompanhar sua evolucao.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _questionOptions.map((value) {
              return StudyPlanChoiceChip(
                label: '$value questoes',
                selected: _draft.weeklyQuestionsGoal == value,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(weeklyQuestionsGoal: value),
                ),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Foco do plano',
          subtitle: 'Escolha o criterio que mais importa para sua semana.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StudyPlanFocusCard(
                      title: 'Constancia',
                      subtitle: 'Valoriza dias ativos e rotina consistente.',
                      icon: Icons.local_fire_department_rounded,
                      selected: _draft.focusMode == 'constancia',
                      onTap: () => setState(
                        () => _draft = _draft.copyWith(focusMode: 'constancia'),
                      ),
                      surfaceContainerHigh: palette.surfaceContainerHigh,
                      onSurface: palette.onSurface,
                      onSurfaceMuted: palette.onSurfaceMuted,
                      primary: palette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StudyPlanFocusCard(
                      title: 'Revisao',
                      subtitle:
                          'Puxa mais peso para tempo de estudo acumulado.',
                      icon: Icons.menu_book_rounded,
                      selected: _draft.focusMode == 'revisao',
                      onTap: () => setState(
                        () => _draft = _draft.copyWith(focusMode: 'revisao'),
                      ),
                      surfaceContainerHigh: palette.surfaceContainerHigh,
                      onSurface: palette.onSurface,
                      onSurfaceMuted: palette.onSurfaceMuted,
                      primary: palette.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StudyPlanFocusCard(
                title: 'Desempenho',
                subtitle:
                    'Da mais importancia ao volume de questoes resolvidas.',
                icon: Icons.stacked_line_chart_rounded,
                selected: _draft.focusMode == 'desempenho',
                onTap: () => setState(
                  () => _draft = _draft.copyWith(focusMode: 'desempenho'),
                ),
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
                primary: palette.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Melhor periodo',
          subtitle: 'Escolha quando voce costuma render melhor.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _periodOptions.entries.map((entry) {
              return StudyPlanChoiceChip(
                label: entry.value,
                selected: _draft.preferredPeriod == entry.key,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(preferredPeriod: entry.key),
                ),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Disciplinas prioritarias',
          subtitle:
              'Escolha ate 4 frentes para ganhar mais foco no seu planejamento.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableDisciplines.map((discipline) {
              return StudyPlanChoiceChip(
                label: discipline,
                selected: _draft.priorityDisciplines.contains(discipline),
                onTap: () => _toggleDiscipline(discipline),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StudyPlanHeader extends StatelessWidget {
  const _StudyPlanHeader({required this.palette, required this.onClose});

  final _StudyPlanPalette palette;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: palette.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_note_rounded,
                    color: palette.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Plano de estudos',
                        style: GoogleFonts.manrope(
                          color: palette.onSurface,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Defina seu ritmo, metas e prioridades da semana.',
                        style: GoogleFonts.inter(
                          color: palette.onSurfaceMuted,
                          fontSize: 11.8,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: palette.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Icon(
                Icons.close_rounded,
                color: palette.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanHeroCard extends StatelessWidget {
  const _PlanHeroCard({
    required this.palette,
    required this.configured,
    required this.weeklyCompletionPercent,
    required this.activeDaysValue,
    required this.minutesValue,
    required this.questionsValue,
    required this.updatedAt,
  });

  final _StudyPlanPalette palette;
  final bool configured;
  final int weeklyCompletionPercent;
  final String activeDaysValue;
  final String minutesValue;
  final String questionsValue;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final updatedLabel = updatedAt == null
        ? 'Ainda nao salvo'
        : 'Atualizado ${updatedAt!.day.toString().padLeft(2, '0')}/${updatedAt!.month.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.surfaceContainerHigh, palette.surfaceContainer],
        ),
        border: Border.all(color: palette.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      configured ? 'SEU PLANO DA SEMANA' : 'NOVO PLANO',
                      style: GoogleFonts.plusJakartaSans(
                        color: palette.onSurfaceMuted,
                        fontSize: 10.5,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      configured
                          ? 'Seu progresso contra a meta da semana'
                          : 'Monte uma rotina realista para acompanhar daqui em diante',
                      style: GoogleFonts.manrope(
                        color: palette.onSurface,
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      updatedLabel,
                      style: GoogleFonts.inter(
                        color: palette.onSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: palette.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$weeklyCompletionPercent%',
                    style: GoogleFonts.manrope(
                      color: palette.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 11,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: palette.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: FractionallySizedBox(
                    widthFactor: weeklyCompletionPercent / 100,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: palette.primary.withValues(alpha: 0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _HeroStatsStrip(
            palette: palette,
            items: const [
              (icon: Icons.calendar_today_rounded, label: 'frequência'),
              (icon: Icons.schedule_rounded, label: 'minutos'),
              (icon: Icons.quiz_rounded, label: 'questoes'),
            ],
            values: [activeDaysValue, minutesValue, questionsValue],
          ),
        ],
      ),
    );
  }
}

class _HeroStatsStrip extends StatelessWidget {
  const _HeroStatsStrip({
    required this.palette,
    required this.items,
    required this.values,
  });

  final _StudyPlanPalette palette;
  final List<({IconData icon, String label})> items;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: List<Widget>.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(
              width: 1,
              height: 38,
              color: Colors.white.withValues(alpha: 0.06),
            );
          }

          final itemIndex = index ~/ 2;
          final item = items[itemIndex];
          return Expanded(
            child: _HeroStatCell(
              icon: item.icon,
              label: item.label,
              value: values[itemIndex],
              palette: palette,
            ),
          );
        }),
      ),
    );
  }
}

class _HeroStatCell extends StatelessWidget {
  const _HeroStatCell({
    required this.value,
    required this.label,
    required this.icon,
    required this.palette,
  });

  final String value;
  final String label;
  final IconData icon;
  final _StudyPlanPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: palette.primary, size: 12),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 10.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: GoogleFonts.plusJakartaSans(
                color: palette.onSurface,
                fontSize: 11.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyPlanFooterBar extends StatelessWidget {
  const _StudyPlanFooterBar({
    required this.palette,
    required this.isSaving,
    required this.onSave,
  });

  final _StudyPlanPalette palette;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : onSave,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: palette.primary,
              foregroundColor: palette.surface,
              disabledBackgroundColor: palette.primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              isSaving ? 'Salvando plano...' : 'Salvar plano',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StudyPlanBackground extends StatelessWidget {
  const _StudyPlanBackground({required this.palette});

  final _StudyPlanPalette palette;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -30,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  palette.secondary.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          left: -90,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  palette.primary.withValues(alpha: 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyPlanDraft {
  const _StudyPlanDraft({
    required this.studyDaysPerWeek,
    required this.minutesPerDay,
    required this.weeklyQuestionsGoal,
    required this.focusMode,
    required this.preferredPeriod,
    required this.priorityDisciplines,
  });

  factory _StudyPlanDraft.fromPlan(StudyPlanData plan) {
    return _StudyPlanDraft(
      studyDaysPerWeek: plan.studyDaysPerWeek,
      minutesPerDay: plan.minutesPerDay,
      weeklyQuestionsGoal: plan.weeklyQuestionsGoal,
      focusMode: plan.focusMode,
      preferredPeriod: plan.preferredPeriod,
      priorityDisciplines: List<String>.from(plan.priorityDisciplines),
    );
  }

  final int studyDaysPerWeek;
  final int minutesPerDay;
  final int weeklyQuestionsGoal;
  final String focusMode;
  final String preferredPeriod;
  final List<String> priorityDisciplines;

  _StudyPlanDraft copyWith({
    int? studyDaysPerWeek,
    int? minutesPerDay,
    int? weeklyQuestionsGoal,
    String? focusMode,
    String? preferredPeriod,
    List<String>? priorityDisciplines,
  }) {
    return _StudyPlanDraft(
      studyDaysPerWeek: studyDaysPerWeek ?? this.studyDaysPerWeek,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      weeklyQuestionsGoal: weeklyQuestionsGoal ?? this.weeklyQuestionsGoal,
      focusMode: focusMode ?? this.focusMode,
      preferredPeriod: preferredPeriod ?? this.preferredPeriod,
      priorityDisciplines:
          priorityDisciplines ?? List<String>.from(this.priorityDisciplines),
    );
  }
}

class _StudyPlanPreview {
  const _StudyPlanPreview({
    required this.weeklyCompletionPercent,
    required this.weeklyMinutesTarget,
  });

  final int weeklyCompletionPercent;
  final int weeklyMinutesTarget;
}

_StudyPlanPreview _buildPreviewProgress(
  _StudyPlanDraft draft,
  StudyPlanData plan,
) {
  final activeDaysPercent = _ratioPercent(
    plan.activeDaysThisWeek,
    draft.studyDaysPerWeek,
  );
  final weeklyMinutesTarget = draft.studyDaysPerWeek * draft.minutesPerDay;
  final minutesPercent = _ratioPercent(
    plan.completedMinutesThisWeek,
    weeklyMinutesTarget,
  );
  final questionsPercent = _ratioPercent(
    plan.answeredQuestionsThisWeek,
    draft.weeklyQuestionsGoal,
  );

  double weeklyPercent;
  switch (draft.focusMode) {
    case 'revisao':
      weeklyPercent =
          activeDaysPercent * 0.3 +
          minutesPercent * 0.45 +
          questionsPercent * 0.25;
      break;
    case 'desempenho':
      weeklyPercent =
          activeDaysPercent * 0.2 +
          minutesPercent * 0.3 +
          questionsPercent * 0.5;
      break;
    default:
      weeklyPercent =
          activeDaysPercent * 0.5 +
          minutesPercent * 0.3 +
          questionsPercent * 0.2;
  }

  return _StudyPlanPreview(
    weeklyCompletionPercent: weeklyPercent.round(),
    weeklyMinutesTarget: weeklyMinutesTarget,
  );
}

int _ratioPercent(int current, int target) {
  if (target <= 0) {
    return 0;
  }
  final percent = ((current / target) * 100).round();
  if (percent < 0) {
    return 0;
  }
  if (percent > 100) {
    return 100;
  }
  return percent;
}

class _StudyPlanPalette {
  const _StudyPlanPalette();

  final Color surface = const Color(0xFF060E20);
  final Color surfaceContainer = const Color(0xFF0F1930);
  final Color surfaceContainerHigh = const Color(0xFF141F38);
  final Color onSurface = const Color(0xFFDEE5FF);
  final Color onSurfaceMuted = const Color(0xFF9AA6C5);
  final Color primary = const Color(0xFFA3A6FF);
  final Color secondary = const Color(0xFF7D62F1);
}
