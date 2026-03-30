import 'package:flutter/material.dart';

import 'subjects_data.dart';
import 'widgets/subject_card.dart';
import 'widgets/subject_category_header.dart';
import 'widgets/subjects_hero_card.dart';

class SubjectsTab extends StatelessWidget {
  const SubjectsTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.area,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final SubjectsArea area;

  @override
  Widget build(BuildContext context) {
    return _AreaSubjectsList(
      area: area,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
    );
  }
}

class _AreaSubjectsList extends StatelessWidget {
  const _AreaSubjectsList({
    required this.area,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final SubjectsArea area;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final content = subjectsAreaContent(area);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        SubjectsHeroCard(
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 20),
        SubjectCategoryHeader(
          title: content.title,
          subtitle: '${content.items.length} Matérias Disponíveis',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 14),
        for (final item in content.items) ...[
          SubjectCard(
            title: item.title,
            description: item.description,
            footerText: item.footerText,
            icon: item.icon,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
