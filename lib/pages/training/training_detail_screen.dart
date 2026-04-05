import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../navigation/app_route_observer.dart';
import '../../services/summaries/summaries_api.dart';
import '../../widgets/cognix/cognix_messages.dart';
import '../subjects/subjects_area_screen.dart';
import '../subjects/subjects_data.dart';
import 'session/training_session_screen.dart';
import 'models/training_detail_models.dart';
import 'training_summary_screen.dart';
import 'widgets/training_detail_active_card.dart';
import 'widgets/training_detail_header.dart';
import 'widgets/training_detail_progress_section.dart';
import 'widgets/training_detail_quick_actions.dart';

class TrainingDetailScreen extends StatefulWidget {
  const TrainingDetailScreen({
    super.key,
    required this.title,
    required this.discipline,
    this.area,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.countLabel,
    this.areaTotalQuestions,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String discipline;
  final SubjectsArea? area;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final String countLabel;
  final int? areaTotalQuestions;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingDetailScreen> createState() => _TrainingDetailScreenState();
}

class _TrainingDetailScreenState extends State<TrainingDetailScreen>
    with RouteAware {
  late Future<TrainingProgressData> _progressFuture;
  bool _isRouteObserverSubscribed = false;

  @override
  void initState() {
    super.initState();
    _progressFuture = _loadProgress();
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

  Future<TrainingProgressData> _loadProgress() {
    return fetchTrainingProgress(
      discipline: widget.discipline,
      subcategory: widget.title,
    );
  }

  Future<void> _refreshProgress() async {
    if (!mounted) return;
    setState(() {
      _progressFuture = _loadProgress();
    });
  }

  TrainingPrimaryCtaData _buildPrimaryCta(TrainingProgressData? progressData) {
    final hasCompletedSession = progressData?.hasCompletedSession ?? false;
    final hasInProgressSession =
        !hasCompletedSession && (progressData?.answeredQuestions ?? 0) > 0;

    if (hasCompletedSession) {
      return const TrainingPrimaryCtaData(
        label: 'Ver Resultados',
        subtitle: 'Seu último simulado desta disciplina foi concluído.',
        icon: Icons.assessment_rounded,
      );
    }

    if (hasInProgressSession) {
      return const TrainingPrimaryCtaData(
        label: 'Continuar Simulado',
        subtitle: 'Você tem um simulado em andamento nesta disciplina.',
        icon: Icons.play_circle_fill_rounded,
      );
    }

    return TrainingPrimaryCtaData(
      label: 'Iniciar Simulado',
      subtitle: widget.description,
      icon: Icons.play_arrow_rounded,
    );
  }

  List<TrainingQuickActionData> _buildQuickActions() {
    return [
      TrainingQuickActionData(
        icon: Icons.menu_book_rounded,
        label: 'Explorar Disciplinas',
        subtitle: widget.areaTotalQuestions != null
            ? '${widget.areaTotalQuestions} questões na área'
            : widget.countLabel,
        onTap: _openSubjectsArea,
      ),
      TrainingQuickActionData(
        icon: Icons.article_rounded,
        label: 'Ver Resumo',
        subtitle: 'Mapa mental interativo',
        onTap: _openSummary,
      ),
    ];
  }

  Future<void> _openTrainingSession() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrainingSessionScreen(
          title: widget.title,
          discipline: widget.discipline,
          subcategory: widget.title,
          surfaceContainer: widget.surfaceContainerHigh,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
    await _refreshProgress();
  }

  void _openSubjectsArea() {
    final area = widget.area ?? subjectsAreaFromTitle(widget.discipline);
    if (area == null) {
      showCognixMessage(
        context,
        'Não foi possível identificar a área de conhecimento.',
        type: CognixMessageType.error,
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubjectsAreaScreen(
          area: area,
          surfaceContainer: widget.surfaceContainerHigh,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
  }

  void _openSummary() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrainingSummaryScreen(
          title: widget.title,
          discipline: widget.discipline,
          surfaceContainer: widget.surfaceContainerHigh,
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
    _refreshProgress();
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
    return Scaffold(
      backgroundColor: const Color(0xFF060E20),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: widget.surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: widget.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainingDetailHeader(
              title: widget.title,
              countLabel: widget.countLabel,
              primary: widget.primary,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
            ),
            const SizedBox(height: 18),
            FutureBuilder<TrainingProgressData>(
              future: _progressFuture,
              builder: (context, snapshot) {
                return TrainingDetailActiveCard(
                  title: widget.title,
                  badgeLabel: widget.badgeLabel,
                  badgeColor: widget.badgeColor,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  primary: widget.primary,
                  cta: _buildPrimaryCta(snapshot.data),
                  onPressed: _openTrainingSession,
                );
              },
            ),
            const SizedBox(height: 18),
            TrainingDetailQuickActions(
              actions: _buildQuickActions(),
              surfaceContainerHigh: widget.surfaceContainerHigh,
              onSurfaceMuted: widget.onSurfaceMuted,
            ),
            const SizedBox(height: 18),
            TrainingDetailProgressSection(
              progressFuture: _progressFuture,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
          ],
        ),
      ),
    );
  }
}
