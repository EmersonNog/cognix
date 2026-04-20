import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';
import '../../../theme/cognix_theme_colors.dart';

const List<String> _disciplineOrder = <String>[
  'linguagens',
  'ciencias_humanas',
  'ciencias_natureza',
  'matematica',
];

const Map<String, _DisciplineDefinition> _disciplineDefinitionsByKey =
    <String, _DisciplineDefinition>{
      'linguagens': _DisciplineDefinition(
        label: 'Linguagens',
        accent: Color(0xFF7C9BFF),
        icon: Icons.menu_book_rounded,
      ),
      'ciencias_humanas': _DisciplineDefinition(
        label: 'Ciências Humanas',
        accent: Color(0xFFFF8A65),
        icon: Icons.public_rounded,
      ),
      'ciencias_natureza': _DisciplineDefinition(
        label: 'Ciências da Natureza',
        accent: Color(0xFF49D7A8),
        icon: Icons.eco_rounded,
      ),
      'matematica': _DisciplineDefinition(
        label: 'Matemática',
        accent: Color(0xFFFFC857),
        icon: Icons.calculate_rounded,
      ),
    };

class ProfileDisciplineGrid extends StatelessWidget {
  const ProfileDisciplineGrid({
    super.key,
    required this.items,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final List<ProfileDisciplineStat> items;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final visibleItems = _buildVisibleItems(items);

    return GridView.builder(
      itemCount: visibleItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.28,
      ),
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        return _DisciplineChip(
          definition: item.definition,
          count: item.count,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        );
      },
    );
  }

  List<_DisciplineTileData> _buildVisibleItems(
    List<ProfileDisciplineStat> source,
  ) {
    final counts = <String, int>{for (final key in _disciplineOrder) key: 0};

    for (final item in source) {
      final key = _canonicalDisciplineKey(item.discipline);
      if (key == null) {
        continue;
      }
      counts[key] = (counts[key] ?? 0) + item.count;
    }

    return _disciplineOrder
        .map(
          (key) => _DisciplineTileData(
            definition: _disciplineDefinitionsByKey[key]!,
            count: counts[key] ?? 0,
          ),
        )
        .toList(growable: false);
  }
}

class _DisciplineChip extends StatelessWidget {
  const _DisciplineChip({
    required this.definition,
    required this.count,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final _DisciplineDefinition definition;
  final int count;
  final Color onSurface;
  final Color onSurfaceMuted;

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
                _questionsLabel(count),
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
                  _disciplineCaption(count),
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

class _DisciplineDefinition {
  const _DisciplineDefinition({
    required this.label,
    required this.accent,
    required this.icon,
  });

  final String label;
  final Color accent;
  final IconData icon;
}

class _DisciplineTileData {
  const _DisciplineTileData({required this.definition, required this.count});

  final _DisciplineDefinition definition;
  final int count;
}

String? _canonicalDisciplineKey(String value) {
  switch (_normalizeDiscipline(value)) {
    case 'linguagens':
    case 'linguagens, codigos e suas tecnologias':
      return 'linguagens';
    case 'ciencias humanas':
    case 'ciencias humanas e suas tecnologias':
      return 'ciencias_humanas';
    case 'ciencias da natureza':
    case 'ciencias da natureza e suas tecnologias':
      return 'ciencias_natureza';
    case 'matematica':
    case 'matematica e suas tecnologias':
      return 'matematica';
    default:
      return null;
  }
}

String _normalizeDiscipline(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('à', 'a')
      .replaceAll('â', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('é', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c')
      .replaceAll('Ã¡', 'a')
      .replaceAll('Ã ', 'a')
      .replaceAll('Ã¢', 'a')
      .replaceAll('Ã£', 'a')
      .replaceAll('Ã©', 'e')
      .replaceAll('Ãª', 'e')
      .replaceAll('Ã­', 'i')
      .replaceAll('Ã³', 'o')
      .replaceAll('Ã´', 'o')
      .replaceAll('Ãµ', 'o')
      .replaceAll('Ãº', 'u')
      .replaceAll('Ã§', 'c');
}

String _questionsLabel(int count) {
  return count == 1 ? 'questão respondida' : 'questões respondidas';
}

String _disciplineCaption(int count) {
  if (count == 1) {
    return 'Início';
  }

  if (count < 10) {
    return 'Primeiros passos';
  }

  if (count < 100) {
    return 'Em evolução';
  }

  return 'Consistente';
}
