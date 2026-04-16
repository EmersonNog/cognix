import 'package:flutter/material.dart';

import '../../navigation/app_route_observer.dart';
import '../subjects/subjects_area_screen.dart';
import '../subjects/subjects_data.dart';
import 'controllers/training_tab_data_loader.dart';
import 'models/training_tab_models.dart';
import 'widgets/training_tab_body.dart';

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
  final _dataLoader = TrainingTabDataLoader();

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
    _rhythmFuture = _dataLoader.loadRhythmData();
    _areaTotalsFuture = _dataLoader.loadAreaTotals();
  }

  Future<void> _refreshData() async {
    final rhythmFuture = _dataLoader.loadRhythmData();
    final areaTotalsFuture = _dataLoader.loadAreaTotals();
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
    return TrainingTabBody(
      rhythmFuture: _rhythmFuture,
      areaTotalsFuture: _areaTotalsFuture,
      surfaceContainer: widget.surfaceContainer,
      surfaceContainerHigh: widget.surfaceContainerHigh,
      onSurface: widget.onSurface,
      onSurfaceMuted: widget.onSurfaceMuted,
      primary: widget.primary,
      onRefresh: _handlePullToRefresh,
      onOpenArea: _openArea,
    );
  }
}
