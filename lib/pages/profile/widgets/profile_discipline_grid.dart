import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';

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
          label: item.discipline,
          count: item.count,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        );
      },
    );
  }

  List<ProfileDisciplineStat> _buildVisibleItems(
    List<ProfileDisciplineStat> source,
  ) {
    final counts = <String, int>{};
    for (final item in source) {
      final key = _canonicalDisciplineKey(item.discipline);
      if (key == null) {
        continue;
      }
      counts[key] = (counts[key] ?? 0) + item.count;
    }

    return [
      ProfileDisciplineStat(
        discipline: 'Linguagens',
        count: counts['linguagens'] ?? 0,
      ),
      ProfileDisciplineStat(
        discipline: 'Ciencias Humanas',
        count: counts['ciencias_humanas'] ?? 0,
      ),
      ProfileDisciplineStat(
        discipline: 'Ciencias da Natureza',
        count: counts['ciencias_natureza'] ?? 0,
      ),
      ProfileDisciplineStat(
        discipline: 'Matematica',
        count: counts['matematica'] ?? 0,
      ),
    ];
  }

  String? _canonicalDisciplineKey(String value) {
    final normalized = _normalizeDiscipline(value);
    switch (normalized) {
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
        .replaceAll('ã', 'a')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }
}

class _DisciplineChip extends StatelessWidget {
  const _DisciplineChip({
    required this.label,
    required this.count,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String label;
  final int count;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _disciplineAccent(label);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF101A33),
            Color.alphaBlend(accent.withOpacity(0.10), const Color(0xFF152243)),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _shortDisciplineLabel(label).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.45,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
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
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurfaceMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(_disciplineIcon(label), color: accent, size: 15),
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

  String _shortDisciplineLabel(String value) {
    switch (value.trim().toLowerCase()) {
      case 'linguagens':
      case 'linguagens, codigos e suas tecnologias':
        return 'Linguagens';
      case 'ciencias humanas':
      case 'ciencias humanas e suas tecnologias':
        return 'Ciencias Humanas';
      case 'ciencias da natureza':
      case 'ciencias da natureza e suas tecnologias':
        return 'Ciencias da Natureza';
      case 'matematica':
      case 'matematica e suas tecnologias':
        return 'Matematica';
      default:
        return value;
    }
  }

  Color _disciplineAccent(String value) {
    switch (value.trim().toLowerCase()) {
      case 'linguagens':
      case 'linguagens, codigos e suas tecnologias':
        return const Color(0xFF7C9BFF);
      case 'ciencias humanas':
      case 'ciencias humanas e suas tecnologias':
        return const Color(0xFFFF8A65);
      case 'ciencias da natureza':
      case 'ciencias da natureza e suas tecnologias':
        return const Color(0xFF49D7A8);
      case 'matematica':
      case 'matematica e suas tecnologias':
        return const Color(0xFFFFC857);
      default:
        return const Color(0xFF8E7CFF);
    }
  }

  IconData _disciplineIcon(String value) {
    switch (value.trim().toLowerCase()) {
      case 'linguagens':
      case 'linguagens, codigos e suas tecnologias':
        return Icons.menu_book_rounded;
      case 'ciencias humanas':
      case 'ciencias humanas e suas tecnologias':
        return Icons.public_rounded;
      case 'ciencias da natureza':
      case 'ciencias da natureza e suas tecnologias':
        return Icons.eco_rounded;
      case 'matematica':
      case 'matematica e suas tecnologias':
        return Icons.calculate_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _questionsLabel(int count) {
    return count == 1 ? 'questao respondida' : 'questoes respondidas';
  }

  String _disciplineCaption(int count) {
    if (count == 1) {
      return 'Inicio';
    }

    if (count < 10) {
      return 'Primeiros passos';
    }

    if (count < 100) {
      return 'Em evolucao';
    }

    return 'Consistente';
  }
}
