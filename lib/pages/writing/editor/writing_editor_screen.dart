import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import '../models/writing_route_args.dart';
import '../shared/writing_theme_hero.dart';

part 'flows/editor_analysis_flow.dart';
part 'flows/editor_loading_flow.dart';
part 'flows/editor_scan_flow.dart';
part 'flows/editor_state_flow.dart';
part 'sections/editor_body.dart';
part 'sections/editor_sections.dart';
part 'shared/editor_loading_steps.dart';
part 'widgets/editor_checklist.dart';
part 'widgets/editor_image_scan.dart';
part 'widgets/editor_inputs.dart';
part 'widgets/editor_loading.dart';
part 'widgets/editor_privacy_info.dart';
part 'widgets/editor_theme.dart';

class WritingEditorScreen extends StatefulWidget {
  const WritingEditorScreen({super.key, required this.args});

  final WritingEditorArgs args;

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  final _writingService = const WritingService();
  final _imagePicker = ImagePicker();
  bool _isAnalyzing = false;
  bool _isScanningImage = false;
  late final TextEditingController _thesisController;
  late final TextEditingController _repertoireController;
  late final TextEditingController _argumentOneController;
  late final TextEditingController _argumentTwoController;
  late final TextEditingController _interventionController;
  late final TextEditingController _finalTextController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _refreshDraftMetrics() {
    if (mounted) {
      setState(() {});
    }
  }

  void _setScanningImage(bool value) {
    if (mounted) {
      setState(() => _isScanningImage = value);
    }
  }

  void _setFinalText(String value) {
    setState(() {
      _finalTextController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    });
  }

  void _setAnalyzing(bool value) {
    if (mounted) {
      setState(() => _isAnalyzing = value);
    }
  }

  @override
  Widget build(BuildContext context) => _buildEditorScaffold();
}
