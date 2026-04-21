import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../subjects/subjects_area_screen.dart';
import '../subjects/subjects_data.dart';
import 'controllers/training_tab_data_loader.dart';
import 'models/training_tab_models.dart';
import 'widgets/training_area_card.dart';

class TrainingAreasScreen extends StatefulWidget {
  const TrainingAreasScreen({
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
  State<TrainingAreasScreen> createState() => _TrainingAreasScreenState();
}

class _TrainingAreasScreenState extends State<TrainingAreasScreen> {
  final _dataLoader = TrainingTabDataLoader();
  late Future<Map<SubjectsArea, int>> _areaTotalsFuture;

  @override
  void initState() {
    super.initState();
    _areaTotalsFuture = _dataLoader.loadAreaTotals();
  }

  Future<void> _refresh() async {
    final nextFuture = _dataLoader.loadAreaTotals();
    setState(() => _areaTotalsFuture = nextFuture);
    await nextFuture;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: widget.surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: widget.onSurface),
        title: Text(
          'Questoes por area',
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: widget.primary,
        backgroundColor: widget.surfaceContainer,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          children: [
            Text(
              'Escolha uma area de conhecimento para comecar seu treino.',
              style: GoogleFonts.inter(
                color: widget.onSurfaceMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }
}
