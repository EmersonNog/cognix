import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../training_flashcards_models.dart';
import 'create_sheet/training_flashcard_image_field_button.dart';
import 'create_sheet/training_flashcard_sheet_field.dart';

class TrainingFlashcardCreateSheet extends StatefulWidget {
  const TrainingFlashcardCreateSheet({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.recoveredImagePaths,
    required this.savedSubjects,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final List<String> recoveredImagePaths;
  final List<String> savedSubjects;

  @override
  State<TrainingFlashcardCreateSheet> createState() =>
      _TrainingFlashcardCreateSheetState();
}

class _TrainingFlashcardCreateSheetState
    extends State<TrainingFlashcardCreateSheet> {
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _subjectController;
  late final TextEditingController _frontController;
  late final TextEditingController _backController;

  String _frontImage = '';
  String _backImage = '';

  bool get _canCreate =>
      _frontController.text.trim().isNotEmpty &&
      _backController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
    _frontController = TextEditingController()..addListener(_refresh);
    _backController = TextEditingController()..addListener(_refresh);
    if (widget.recoveredImagePaths.isNotEmpty) {
      _frontImage = widget.recoveredImagePaths.first;
    }
    if (widget.recoveredImagePaths.length > 1) {
      _backImage = widget.recoveredImagePaths[1];
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  Future<void> _pickImage({required ValueChanged<String> onSaved}) async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;
    setState(() => onSaved(image.path));
  }

  Future<String> _normalizeImageValue(String value) async {
    final normalized = value.trim();
    if (normalized.isEmpty) return '';
    final file = File(normalized);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }
    return normalized;
  }

  Future<void> _submit() async {
    if (!_canCreate) return;
    final frontImage = await _normalizeImageValue(_frontImage);
    final backImage = await _normalizeImageValue(_backImage);
    if (!mounted) return;

    Navigator.of(context).pop(
      TrainingFlashcardDraft(
        subject: _subjectController.text.trim(),
        frontText: _frontController.text.trim(),
        frontImage: frontImage,
        backText: _backController.text.trim(),
        backImage: backImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: widget.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: widget.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.onSurfaceMuted.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Criar Flashcard',
                        style: GoogleFonts.manrope(
                          color: widget.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: widget.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TrainingFlashcardSheetField(
                  label: 'Materia (opcional)',
                  hintText: 'Ex: Biologia',
                  controller: _subjectController,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  primary: widget.primary,
                  isCompact: true,
                  suggestions: widget.savedSubjects,
                ),
                const SizedBox(height: 14),
                TrainingFlashcardSheetField(
                  label: 'Frente (Pergunta)',
                  hintText: 'Ex: Qual a capital da Franca?',
                  controller: _frontController,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  primary: widget.primary,
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                TrainingFlashcardImageFieldButton(
                  label: _frontImage.isEmpty
                      ? 'Adicionar imagem da galeria'
                      : 'Imagem da frente selecionada',
                  onTap: () =>
                      _pickImage(onSaved: (value) => _frontImage = value),
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                ),
                const SizedBox(height: 14),
                TrainingFlashcardSheetField(
                  label: 'Verso (Resposta)',
                  hintText: 'Ex: Paris',
                  controller: _backController,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  primary: widget.primary,
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                TrainingFlashcardImageFieldButton(
                  label: _backImage.isEmpty
                      ? 'Adicionar imagem da galeria'
                      : 'Imagem do verso selecionada',
                  onTap: () =>
                      _pickImage(onSaved: (value) => _backImage = value),
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canCreate ? _submit : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      disabledBackgroundColor: widget.surfaceContainerHigh,
                      foregroundColor: Colors.black,
                      disabledForegroundColor: widget.onSurfaceMuted,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      'Criar Flashcard',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
