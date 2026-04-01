import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_mind_map/reactive_mind_map.dart';

import '../../../services/summaries/summaries_api.dart';

class TrainingSummaryMapPanel extends StatelessWidget {
  const TrainingSummaryMapPanel({
    super.key,
    required this.summary,
    required this.subcategoryTitle,
    required this.isCompact,
    required this.constraints,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.primary,
  });

  final SummaryData summary;
  final String subcategoryTitle;
  final bool isCompact;
  final BoxConstraints constraints;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final mapPadding = isCompact ? 10.0 : 12.0;
    final mapNodeFontSize = isCompact ? 11.5 : 13.5;
    final levelSpacing = isCompact ? 110.0 : 160.0;
    final nodeMargin = isCompact ? 20.0 : 26.0;
    final nodeHorizontalPadding = isCompact ? 9.0 : 14.0;
    final nodeVerticalPadding = isCompact ? 9.0 : 10.0;
    final maxNodeWidth = isCompact ? constraints.maxWidth * 0.36 : 220.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(mapPadding, 0, mapPadding, 20),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceContainer.withOpacity(0.38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withOpacity(0.14)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: MindMapWidget(
            data: _buildMindMapData(summary, subcategoryTitle),
            style: MindMapStyle(
              layout: isCompact
                  ? MindMapLayout.horizontal
                  : MindMapLayout.right,
              nodeShape: NodeShape.roundedRectangle,
              backgroundColor: const Color(0xFF060E20),
              connectionColor: primary.withOpacity(0.32),
              connectionWidth: isCompact ? 1.1 : 1.4,
              nodeMargin: nodeMargin,
              levelSpacing: levelSpacing,
              minNodeWidth: isCompact ? 82 : 100,
              maxNodeWidth: isCompact ? maxNodeWidth : 240,
              minNodeHeight: isCompact ? 64 : 48,
              minCustomNodeWidth: isCompact ? 82 : 100,
              maxCustomNodeWidth: isCompact ? maxNodeWidth : 240,
              minCustomNodeHeight: isCompact ? 64 : 48,
              maxCustomNodeHeight: isCompact ? 148 : 140,
              textPadding: EdgeInsets.symmetric(
                horizontal: nodeHorizontalPadding,
                vertical: nodeVerticalPadding,
              ),
              defaultTextStyle: GoogleFonts.manrope(
                color: onSurface,
                fontSize: mapNodeFontSize,
                fontWeight: FontWeight.w700,
              ),
              selectionBorderColor: primary.withOpacity(0.6),
              selectionBorderWidth: 2,
              enableNodeShadow: false,
              nodeBuilder:
                  (node, isSelected, onTap, onLongPress, onDoubleTap) {
                    return GestureDetector(
                      onTap: onTap,
                      onLongPress: onLongPress,
                      onDoubleTap: onDoubleTap,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isCompact ? maxNodeWidth : 240,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: nodeHorizontalPadding,
                            vertical: nodeVerticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? primary.withOpacity(0.5)
                                  : primary.withOpacity(0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0C1426,
                                ).withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            node.title,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: GoogleFonts.manrope(
                              color: onSurface,
                              fontSize: mapNodeFontSize,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
            ),
            viewerOptions: InteractiveViewerOptions(
              boundaryMargin: EdgeInsets.all(isCompact ? 80 : 120),
              minScale: isCompact ? 0.6 : 0.45,
              maxScale: isCompact ? 2.4 : 3.0,
            ),
            minCanvasSize: Size(
              isCompact ? 900 : 1200,
              isCompact ? 720 : 900,
            ),
            canvasPadding: EdgeInsets.all(isCompact ? 140 : 220),
            cameraFocus: isCompact
                ? CameraFocus.rootNode
                : CameraFocus.fitAll,
            initialScale: isCompact ? 0.92 : 1.0,
            focusAnimation: const Duration(milliseconds: 420),
          ),
        ),
      ),
    );
  }

  MindMapData _buildMindMapData(SummaryData summary, String subcategoryTitle) {
    return MindMapData(
      id: 'root',
      title: _rootTitle(summary, subcategoryTitle),
      children: [
        for (final node in summary.nodes)
          MindMapData(
            id: node.title,
            title: node.title,
            children: [
              for (final item in node.items)
                MindMapData(id: '${node.title}::$item', title: item),
            ],
          ),
      ],
    );
  }

  String _rootTitle(SummaryData summary, String subcategoryTitle) {
    final title = subcategoryTitle.trim();
    if (title.isNotEmpty) {
      return title;
    }

    final sanitized = summary.title.replaceFirst(' - Resumo', '').trim();
    return sanitized.isEmpty ? 'Resumo' : sanitized;
  }
}
