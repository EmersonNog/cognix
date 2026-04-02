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
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleItems = items.take(4).toList();
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
            'questões respondidas',
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
      case 'linguagens, códigos e suas tecnologias':
      case 'linguagens, codigos e suas tecnologias':
        return 'Linguagens';
      case 'ciências humanas e suas tecnologias':
      case 'ciencias humanas e suas tecnologias':
        return 'Ciências Humanas';
      case 'ciências da natureza e suas tecnologias':
      case 'ciencias da natureza e suas tecnologias':
        return 'Ciências da Natureza';
      case 'matemática e suas tecnologias':
      case 'matematica e suas tecnologias':
        return 'Matemática';
      default:
        return value;
    }
  }

  Color _disciplineAccent(String value) {
    switch (value.trim().toLowerCase()) {
      case 'linguagens, códigos e suas tecnologias':
      case 'linguagens, codigos e suas tecnologias':
        return const Color(0xFF7C9BFF);
      case 'ciências humanas e suas tecnologias':
      case 'ciencias humanas e suas tecnologias':
        return const Color(0xFFFF8A65);
      case 'ciências da natureza e suas tecnologias':
      case 'ciencias da natureza e suas tecnologias':
        return const Color(0xFF49D7A8);
      case 'matemática e suas tecnologias':
      case 'matematica e suas tecnologias':
        return const Color(0xFFFFC857);
      default:
        return const Color(0xFF8E7CFF);
    }
  }

  IconData _disciplineIcon(String value) {
    switch (value.trim().toLowerCase()) {
      case 'linguagens, códigos e suas tecnologias':
      case 'linguagens, codigos e suas tecnologias':
        return Icons.menu_book_rounded;
      case 'ciências humanas e suas tecnologias':
      case 'ciencias humanas e suas tecnologias':
        return Icons.public_rounded;
      case 'ciências da natureza e suas tecnologias':
      case 'ciencias da natureza e suas tecnologias':
        return Icons.eco_rounded;
      case 'matemática e suas tecnologias':
      case 'matematica e suas tecnologias':
        return Icons.calculate_rounded;
      default:
        return Icons.school_rounded;
    }
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
}
