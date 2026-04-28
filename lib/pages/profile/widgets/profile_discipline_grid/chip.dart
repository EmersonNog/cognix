part of '../profile_discipline_grid.dart';

class _DisciplineChip extends StatelessWidget {
  const _DisciplineChip({
    required this.definition,
    required this.count,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.previewMode,
  });

  final _DisciplineDefinition definition;
  final int count;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            colors.surfaceContainer,
            Color.alphaBlend(
              definition.accent.withValues(alpha: 0.10),
              colors.surfaceContainerHigh,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: definition.accent.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: definition.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  definition.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: definition.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.45,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (previewMode)
                Icon(
                  Icons.lock_rounded,
                  color: onSurface.withValues(alpha: 0.82),
                  size: 22,
                )
              else
                Text(
                  '$count',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                previewMode
                    ? 'Disponível com assinatura'
                    : _questionsLabel(count),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurfaceMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: definition.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  definition.icon,
                  color: definition.accent,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  previewMode ? 'Painel premium' : _disciplineCaption(count),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurfaceMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
