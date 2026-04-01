import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../navigation/app_route_observer.dart';
import '../../services/questions/questions_api.dart';
import '../subjects/subjects_area_screen.dart';
import '../subjects/subjects_data.dart';
import 'models/training_tab_models.dart';
import 'widgets/training_area_card.dart';
import 'widgets/training_rhythm_card.dart';

class TrainingTab extends StatefulWidget {
  const TrainingTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingTab> createState() => _TrainingTabState();
}

class _TrainingTabState extends State<TrainingTab> with RouteAware {
  late Future<TrainingRhythmData> _rhythmFuture;
  late Future<Map<SubjectsArea, int>> _areaTotalsFuture;
  bool _isRouteObserverSubscribed = false;

  @override
  void initState() {
    super.initState();
    _scheduleRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isRouteObserverSubscribed) return;
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
      _isRouteObserverSubscribed = true;
    }
  }

  void _scheduleRefresh() {
    _rhythmFuture = _loadRhythmData();
    _areaTotalsFuture = _loadAreaTotals();
  }

  Future<TrainingRhythmData> _loadRhythmData() async {
    try {
      final overview = await fetchTrainingSessionsOverview();
      final latest = overview.latestSession;
      if (latest == null) {
        return const TrainingRhythmData.empty();
      }

      final completedCountLabel =
          '${overview.completedSessions} '
          '${overview.completedSessions == 1 ? 'simulado concluído' : 'simulados concluídos'}';

      if (latest.completed) {
        final percent = latest.totalQuestions <= 0
            ? 0
            : ((latest.answeredQuestions / latest.totalQuestions) * 100)
                  .round();
        return TrainingRhythmData(
          subtitle: latest.subcategory.isEmpty
              ? 'Último simulado concluído'
              : 'Último simulado concluído em ${latest.subcategory}',
          badgeLabel: '$percent%',
          completedCountLabel: completedCountLabel,
        );
      }

      return TrainingRhythmData(
        subtitle: latest.subcategory.isEmpty
            ? 'Simulado em andamento'
            : 'Continuando ${latest.subcategory}',
        badgeLabel: latest.totalQuestions <= 0
            ? '${latest.answeredQuestions}'
            : '${latest.answeredQuestions}/${latest.totalQuestions}',
        completedCountLabel: completedCountLabel,
      );
    } catch (_) {
      return const TrainingRhythmData.empty();
    }
  }

  Future<Map<SubjectsArea, int>> _loadAreaTotals() async {
    final totals = <SubjectsArea, int>{};

    for (final item in trainingAreas) {
      try {
        final subcategories = await fetchSubcategories(
          subjectsAreaTitle(item.area),
        );
        totals[item.area] = subcategories.fold<int>(
          0,
          (sum, subcategory) => sum + subcategory.total,
        );
      } catch (_) {
        totals[item.area] = 0;
      }
    }

    return totals;
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(_scheduleRefresh);
  }

  void _openArea(TrainingAreaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubjectsAreaScreen(
          area: item.area,
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
  }

  @override
  void didPopNext() {
    _refreshData();
  }

  @override
  void dispose() {
    if (_isRouteObserverSubscribed) {
      appRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Áreas de Conhecimento',
            style: GoogleFonts.manrope(
              color: widget.onSurface,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Escolha uma área para iniciar seu treino personalizado.',
            style: GoogleFonts.inter(
              color: widget.onSurfaceMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          FutureBuilder<TrainingRhythmData>(
            future: _rhythmFuture,
            builder: (context, snapshot) {
              final rhythm = snapshot.data ?? const TrainingRhythmData.empty();

              return TrainingRhythmCard(
                data: rhythm,
                surfaceContainerHigh: widget.surfaceContainerHigh,
                primary: widget.primary,
                onSurface: widget.onSurface,
                onSurfaceMuted: widget.onSurfaceMuted,
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'LISTA DE AREAS',
            style: GoogleFonts.plusJakartaSans(
              color: widget.onSurfaceMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Map<SubjectsArea, int>>(
            future: _areaTotalsFuture,
            builder: (context, snapshot) {
              final totals = snapshot.data ?? const <SubjectsArea, int>{};

              return Column(
                children: [
                  for (final area in trainingAreas) ...[
                    TrainingAreaCard(
                      item: area,
                      totalQuestions: totals[area.area] ?? 0,
                      surfaceContainer: widget.surfaceContainer,
                      surfaceContainerHigh: widget.surfaceContainerHigh,
                      onSurface: widget.onSurface,
                      onSurfaceMuted: widget.onSurfaceMuted,
                      onTap: () => _openArea(area),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
