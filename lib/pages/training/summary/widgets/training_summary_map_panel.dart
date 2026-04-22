import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_mind_map/reactive_mind_map.dart';

import '../../../../services/summaries/summaries_api.dart';
import 'training_summary_locked_overlay.dart';
import 'training_summary_map_node_card.dart';

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
    required this.onSurfaceMuted,
    required this.primary,
    this.lockedMessage,
  });

  final SummaryData summary;
  final String subcategoryTitle;
  final bool isCompact;
  final BoxConstraints constraints;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final String? lockedMessage;

  @override
  Widget build(BuildContext context) {
    final isLocked = summary.lockedUntilComplete;
    final config = _MapPanelConfig(
      isCompact: isCompact,
      constraints: constraints,
      isLocked: isLocked,
    );
    final displaySummary = isLocked
        ? _buildLockedMockSummary(summary, subcategoryTitle)
        : summary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        config.outerPadding,
        0,
        config.outerPadding,
        20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceContainer.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withValues(alpha: 0.14)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MindMapWidget(
                data: _buildMindMapData(displaySummary, subcategoryTitle),
                style: _buildMapStyle(config, context),
                viewerOptions: InteractiveViewerOptions(
                  boundaryMargin: EdgeInsets.all(config.boundaryMargin),
                  minScale: config.minScale,
                  maxScale: isCompact ? 2.4 : 3.0,
                ),
                minCanvasSize: Size(
                  isCompact ? 900 : 1200,
                  isCompact ? 720 : 900,
                ),
                canvasPadding: EdgeInsets.all(config.canvasPadding),
                cameraFocus: config.cameraFocus,
                initialScale: config.initialScale,
                focusAnimation: const Duration(milliseconds: 420),
              ),
              if (isLocked)
                TrainingSummaryLockedOverlay(
                  isCompact: isCompact,
                  constraints: constraints,
                  surfaceContainerHigh: surfaceContainerHigh,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  lockedMessage: lockedMessage,
                ),
            ],
          ),
        ),
      ),
    );
  }

  MindMapStyle _buildMapStyle(_MapPanelConfig config, BuildContext context) {
    final pageBackground = Theme.of(context).scaffoldBackgroundColor;

    return MindMapStyle(
      layout: isCompact ? MindMapLayout.horizontal : MindMapLayout.right,
      nodeShape: NodeShape.roundedRectangle,
      backgroundColor: pageBackground,
      connectionColor: primary.withValues(alpha: 0.32),
      connectionWidth: isCompact ? 1.1 : 1.4,
      nodeMargin: config.nodeMargin,
      levelSpacing: config.levelSpacing,
      minNodeWidth: isCompact ? 82 : 100,
      maxNodeWidth: config.maxNodeWidth,
      minNodeHeight: isCompact ? 64 : 48,
      minCustomNodeWidth: isCompact ? 82 : 100,
      maxCustomNodeWidth: config.maxNodeWidth,
      minCustomNodeHeight: isCompact ? 64 : 48,
      maxCustomNodeHeight: isCompact ? 148 : 140,
      textPadding: EdgeInsets.symmetric(
        horizontal: config.nodeHorizontalPadding,
        vertical: config.nodeVerticalPadding,
      ),
      defaultTextStyle: GoogleFonts.manrope(
        color: onSurface,
        fontSize: config.nodeFontSize,
        fontWeight: FontWeight.w700,
      ),
      selectionBorderColor: primary.withValues(alpha: 0.6),
      selectionBorderWidth: 2,
      enableNodeShadow: false,
      nodeBuilder: (node, isSelected, onTap, onLongPress, onDoubleTap) {
        return TrainingSummaryMapNodeCard(
          title: node.title,
          isCompact: isCompact,
          maxNodeWidth: config.maxNodeWidth,
          horizontalPadding: config.nodeHorizontalPadding,
          verticalPadding: config.nodeVerticalPadding,
          fontSize: config.nodeFontSize,
          isSelected: isSelected,
          isLocked: summary.lockedUntilComplete,
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          primary: primary,
        );
      },
    );
  }
}

class _MapPanelConfig {
  const _MapPanelConfig({
    required this.isCompact,
    required this.constraints,
    required this.isLocked,
  });

  final bool isCompact;
  final BoxConstraints constraints;
  final bool isLocked;

  double get outerPadding => isCompact ? 10.0 : 12.0;
  double get nodeFontSize => isCompact ? 11.5 : 13.5;
  double get levelSpacing => isCompact ? 110.0 : 160.0;
  double get nodeMargin => isCompact ? 20.0 : 26.0;
  double get nodeHorizontalPadding => isCompact ? 9.0 : 14.0;
  double get nodeVerticalPadding => isCompact ? 9.0 : 10.0;
  double get maxNodeWidth => isCompact ? constraints.maxWidth * 0.36 : 240.0;
  double get boundaryMargin => isCompact ? 80.0 : 120.0;
  double get minScale => isCompact ? 0.6 : 0.45;

  double get canvasPadding {
    if (isLocked) {
      return isCompact ? 110.0 : 160.0;
    }
    return isCompact ? 140.0 : 220.0;
  }

  CameraFocus get cameraFocus {
    if (isLocked) {
      return CameraFocus.fitAll;
    }
    return isCompact ? CameraFocus.rootNode : CameraFocus.fitAll;
  }

  double get initialScale {
    if (isLocked) {
      return isCompact ? 0.64 : 0.76;
    }
    return isCompact ? 0.92 : 1.0;
  }
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

SummaryData _buildLockedMockSummary(
  SummaryData summary,
  String subcategoryTitle,
) {
  return SummaryData(
    title: summary.title,
    discipline: summary.discipline,
    subcategory: summary.subcategory,
    nodes: [
      const SummaryNode(
        title: 'Conceitos centrais',
        items: [
          'Definições essenciais',
          'Relações principais',
          'Interpretação do tema',
        ],
      ),
      const SummaryNode(
        title: 'Padrões de questão',
        items: [
          'Leitura do enunciado',
          'Fórmulas recorrentes',
          'Erros mais comuns',
        ],
      ),
      SummaryNode(
        title: subcategoryTitle.trim().isEmpty
            ? 'Aplicações'
            : 'Aplicações em $subcategoryTitle',
        items: const [
          'Passo a passo de resolução',
          'Pontos de revisão',
          'Atenção nas alternativas',
        ],
      ),
    ],
    stats: summary.stats,
    lockedUntilComplete: true,
    lockedMessage: summary.lockedMessage,
  );
}
