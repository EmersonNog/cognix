import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/summaries/summaries_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import 'widgets/training_summary_map_card.dart';
import 'widgets/training_summary_map_panel.dart';
import 'widgets/training_summary_stats_card.dart';

class TrainingSummaryScreen extends StatefulWidget {
  const TrainingSummaryScreen({
    super.key,
    required this.title,
    required this.discipline,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String discipline;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingSummaryScreen> createState() => _TrainingSummaryScreenState();
}

class _TrainingSummaryScreenState extends State<TrainingSummaryScreen> {
  late final Future<SummaryData> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = fetchPersonalSummary(
      discipline: widget.discipline,
      subcategory: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final pageBackgroundColor = colors.surface;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        surfaceTintColor: pageBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: widget.onSurface),
        title: Text(
          'Mapa mental - ${widget.title}',
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<SummaryData>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Não foi possível carregar o resumo.',
                  style: GoogleFonts.inter(
                    color: widget.onSurfaceMuted,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final summary = snapshot.data;
          final isLocked = summary?.lockedUntilComplete ?? false;
          final nodes = summary?.nodes ?? const <SummaryNode>[];
          if (summary == null || (nodes.isEmpty && !isLocked)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Nenhum resumo disponível para esta disciplina.',
                  style: GoogleFonts.inter(
                    color: widget.onSurfaceMuted,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;
              final horizontalPadding = isCompact ? 16.0 : 20.0;
              final titleSize = isCompact ? 18.0 : 22.0;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.title,
                          style: GoogleFonts.manrope(
                            color: widget.onSurface,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          summary.discipline,
                          style: GoogleFonts.inter(
                            color: widget.onSurfaceMuted,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TrainingSummaryStatsCard(
                          stats: summary.stats,
                          surfaceContainer: widget.surfaceContainer,
                          onSurface: widget.onSurface,
                          onSurfaceMuted: widget.onSurfaceMuted,
                          primary: widget.primary,
                          isLocked: isLocked,
                        ),
                        const SizedBox(height: 12),
                        TrainingSummaryMapCard(
                          isCompact: isCompact,
                          surfaceContainer: widget.surfaceContainer,
                          onSurface: widget.onSurface,
                          onSurfaceMuted: widget.onSurfaceMuted,
                          primary: widget.primary,
                          isLocked: isLocked,
                          lockedMessage: summary.lockedMessage,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TrainingSummaryMapPanel(
                      summary: summary,
                      subcategoryTitle: widget.title,
                      isCompact: isCompact,
                      constraints: constraints,
                      surfaceContainer: widget.surfaceContainer,
                      surfaceContainerHigh: widget.surfaceContainerHigh,
                      onSurface: widget.onSurface,
                      onSurfaceMuted: widget.onSurfaceMuted,
                      primary: widget.primary,
                      lockedMessage: summary.lockedMessage,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
