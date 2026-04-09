part of '../study_plan_screen.dart';

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
        ? 'Ainda não salvo'
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
              (icon: Icons.calendar_today_rounded, label: 'dias ativos'),
              (icon: Icons.schedule_rounded, label: 'minutos'),
              (icon: Icons.quiz_rounded, label: 'questões'),
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
