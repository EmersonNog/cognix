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
    required this.onRefreshHubData,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback onRefreshHubData;

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
      final completedCountLabel =
          '${overview.completedSessions} '
          '${overview.completedSessions == 1 ? 'simulado conclu\u00eddo' : 'simulados conclu\u00eddos'}';

      if (latest == null) {
        if (overview.inProgressSessions > 0) {
          final inProgressLabel =
              '${overview.inProgressSessions} '
              '${overview.inProgressSessions == 1 ? 'simulado em andamento' : 'simulados em andamento'}';
          return TrainingRhythmData(
            subtitle: 'Voc\u00ea ainda tem treino para retomar',
            badgeLabel: '${overview.inProgressSessions}x',
            completedCountLabel: inProgressLabel,
          );
        }

        if (overview.completedSessions > 0) {
          return TrainingRhythmData(
            subtitle: 'Seu hist\u00f3rico recente j\u00e1 est\u00e1 salvo',
            badgeLabel: '${overview.completedSessions}x',
            completedCountLabel: completedCountLabel,
          );
        }

        return const TrainingRhythmData.empty();
      }

      if (latest.completed) {
        final percent = latest.totalQuestions <= 0
            ? 0
            : ((latest.answeredQuestions / latest.totalQuestions) * 100)
                  .round();
        return TrainingRhythmData(
          subtitle: latest.subcategory.isEmpty
              ? '\u00daltimo simulado conclu\u00eddo'
              : '\u00daltimo simulado conclu\u00eddo em ${latest.subcategory}',
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
      return const TrainingRhythmData.error();
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
    final rhythmFuture = _loadRhythmData();
    final areaTotalsFuture = _loadAreaTotals();
    if (!mounted) return;

    setState(() {
      _rhythmFuture = rhythmFuture;
      _areaTotalsFuture = areaTotalsFuture;
    });

    await Future.wait<void>([
      rhythmFuture.then((_) {}),
      areaTotalsFuture.then((_) {}),
    ]);
  }

  Future<void> _handlePullToRefresh() async {
    await Future.wait<void>([_refreshData(), widget.onRefreshHubData()]);
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
    return RefreshIndicator(
      onRefresh: _handlePullToRefresh,
      color: widget.primary,
      backgroundColor: widget.surfaceContainer,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: [
          Text(
            '\u00c1reas de Conhecimento',
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
              final rhythm =
                  snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData
                  ? const TrainingRhythmData.loading()
                  : snapshot.data ??
                        (snapshot.hasError
                            ? const TrainingRhythmData.error()
                            : const TrainingRhythmData.empty());

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
