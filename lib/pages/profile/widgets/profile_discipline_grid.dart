import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';
import '../../../theme/cognix_theme_colors.dart';

part 'profile_discipline_grid/chip.dart';
part 'profile_discipline_grid/data.dart';
part 'profile_discipline_grid/helpers.dart';

class ProfileDisciplineGrid extends StatelessWidget {
  const ProfileDisciplineGrid({
    super.key,
    required this.items,
    required this.onSurface,
    required this.onSurfaceMuted,
    this.previewMode = false,
  });

  final List<ProfileDisciplineStat> items;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool previewMode;

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
          previewMode: previewMode,
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
