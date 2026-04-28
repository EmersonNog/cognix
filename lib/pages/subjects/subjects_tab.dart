import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/core/api_client.dart' show isSubscriptionRequiredError;
import '../../services/questions/questions_api.dart';
import '../../services/summaries/summaries_api.dart';
import '../../widgets/subscription/subscription_required_card.dart';
import '../training/detail/training_detail_screen.dart';
import 'subjects_data.dart';
import 'widgets/subject_card.dart';
import 'widgets/subject_category_header.dart';
import 'widgets/subjects_hero_card.dart';

part 'subjects_tab/content.dart';
part 'subjects_tab/helpers.dart';
part 'subjects_tab/models.dart';
part 'subjects_tab/state_widgets.dart';

class SubjectsTab extends StatefulWidget {
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
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab> {
  late Future<List<_SubjectCardData>> _subcategoriesFuture;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = _loadSubjectCards();
  }

  void _refreshSubjectCards() {
    if (!mounted) {
      return;
    }
    setState(() {
      _subcategoriesFuture = _loadSubjectCards();
    });
  }

  Future<List<_SubjectCardData>> _loadSubjectCards() async {
    final discipline = subjectsAreaTitle(widget.area);
    final items = await fetchSubcategories(discipline);

    return Future.wait(
      items.map((item) async {
        try {
          final progress = await fetchTrainingProgress(
            discipline: discipline,
            subcategory: item.name,
          );
          return _SubjectCardData(
            item: item,
            status: _statusFromProgress(progress),
          );
        } catch (_) {
          return _SubjectCardData(
            item: item,
            status: const _SubjectCardStatus.available(),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSubjectsTabForState(this);
  }
}
