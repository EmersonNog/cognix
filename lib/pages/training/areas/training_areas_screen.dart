import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/core/api_client.dart'
    show isSubscriptionRequiredError;
import '../../subjects/subjects_area_screen.dart';
import '../../subjects/subjects_data.dart';
import 'training_area_models.dart';
import 'training_areas_data_loader.dart';
import 'widgets/training_area_card.dart';

part 'screen/training_areas_screen_view.dart';

class TrainingAreasScreen extends StatefulWidget {
  const TrainingAreasScreen({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingAreasScreen> createState() => _TrainingAreasScreenState();
}

class _TrainingAreasScreenState extends State<TrainingAreasScreen> {
  final _dataLoader = TrainingAreasDataLoader();
  late Future<Map<SubjectsArea, int>> _areaTotalsFuture;

  @override
  void initState() {
    super.initState();
    _areaTotalsFuture = _dataLoader.loadAreaTotals();
  }

  Future<void> _refresh() async {
    final nextFuture = _dataLoader.loadAreaTotals();
    setState(() {
      _areaTotalsFuture = nextFuture;
    });
    try {
      await nextFuture;
    } catch (_) {}
  }

  void _openArea(TrainingAreaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubjectsAreaScreen(
          area: item.area,
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildScreenForState(this);
  }
}
