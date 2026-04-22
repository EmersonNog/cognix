import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../subjects/subjects_area_screen.dart';
import '../../subjects/subjects_data.dart';
import 'training_area_models.dart';
import 'training_areas_data_loader.dart';
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
  final _dataLoader = TrainingAreasDataLoader();
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
          'QUESTÕES POR ÁREA',
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
          children: [
            Text(
              'Escolha uma área para comecar seu treino e explorar os temas disponíveis.',
              style: GoogleFonts.inter(
                color: widget.onSurfaceMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            FutureBuilder<Map<SubjectsArea, int>>(
              future: _areaTotalsFuture,
              builder: (context, snapshot) {
                final totals = snapshot.data ?? const <SubjectsArea, int>{};
                final totalQuestions = totals.values.fold<int>(
                  0,
                  (sum, value) => sum + value,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Áreas disponíveis',
                                style: GoogleFonts.manrope(
                                  color: widget.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Selecione uma trilha para praticar agora',
                                style: GoogleFonts.inter(
                                  color: widget.onSurfaceMuted,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: widget.surfaceContainer,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: widget.surfaceContainerHigh,
                            ),
                          ),
                          child: Text(
                            '$totalQuestions questões',
                            style: GoogleFonts.plusJakartaSans(
                              color: widget.onSurfaceMuted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
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
                      const SizedBox(height: 14),
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
