import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/questions/questions_api.dart';
import '../../services/study_plan/study_plan_api.dart';
import '../../services/study_plan/study_plan_refresh_notifier.dart';
import 'widgets/study_plan_widgets.dart';

part 'study_plan_screen_actions.dart';
part 'study_plan_screen_body.dart';
part 'study_plan_screen_models.dart';
part 'study_plan_screen_shell.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  static const _periodOptions = <String, String>{
    'flexivel': 'Flexivel',
    'manha': 'Manha',
    'tarde': 'Tarde',
    'noite': 'Noite',
  };

  static const _minutesOptions = <int>[30, 45, 60, 90, 120, 150];
  static const _questionOptions = <int>[20, 40, 60, 80, 120, 160];
  static const _previewDebounceDuration = Duration(milliseconds: 180);

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  List<String> _availableDisciplines = const [];
  StudyPlanData _plan = const StudyPlanData.empty();
  StudyPlanData _previewPlan = const StudyPlanData.empty();
  _StudyPlanDraft _draft = _StudyPlanDraft.fromPlan(
    const StudyPlanData.empty(),
  );
  Timer? _previewDebounce;
  int _previewRequestToken = 0;

  @override
  void initState() {
    super.initState();
    _loadForState(this);
  }

  @override
  void dispose() {
    _previewDebounce?.cancel();
    super.dispose();
  }

  void _applyState(VoidCallback update) {
    if (!mounted) {
      return;
    }
    setState(update);
  }

  @override
  Widget build(BuildContext context) {
    const palette = _StudyPlanPalette();

    return Scaffold(
      backgroundColor: palette.surface,
      body: SafeArea(
        child: Stack(
          children: [
            _StudyPlanBackground(palette: palette),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _StudyPlanHeader(
                    palette: palette,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildBodyForState(
                    this,
                    palette: palette,
                    displayPlan: _previewPlan,
                  ),
                ),
                _StudyPlanFooterBar(
                  palette: palette,
                  isSaving: _isSaving,
                  onSave: () => _saveForState(this),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
