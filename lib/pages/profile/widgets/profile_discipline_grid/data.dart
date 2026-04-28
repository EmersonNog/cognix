part of '../profile_discipline_grid.dart';

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
