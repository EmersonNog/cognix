part of '../writing_editor_screen.dart';

extension _WritingEditorScanFlow on _WritingEditorScreenState {
  Future<void> _chooseImageScanSource() async {
    if (_isScanningImage || _isAnalyzing) {
      return;
    }

    final colors = context.cognixColors;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colors.surfaceContainer,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escanear com IA',
                style: GoogleFonts.manrope(
                  color: colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Envie uma foto nítida da redação para o Gemini transcrever.',
                style: GoogleFonts.inter(
                  color: colors.onSurfaceMuted,
                  fontSize: 12.8,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              _ImageScanSourceTile(
                icon: Icons.photo_camera_rounded,
                title: 'Tirar foto',
                subtitle: 'Capture a folha inteira, sem sombras fortes.',
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              const SizedBox(height: 10),
              _ImageScanSourceTile(
                icon: Icons.photo_library_rounded,
                title: 'Escolher da galeria',
                subtitle: 'Use uma foto já salva no aparelho.',
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) {
      return;
    }

    await _scanImageWithAi(source);
  }

  Future<void> _scanImageWithAi(ImageSource source) async {
    _setScanningImage(true);
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 2200,
        imageQuality: 84,
      );
      if (image == null) {
        return;
      }

      final result = await _runWithAiLoading(
        title: 'Transcrevendo sua redação',
        subtitle: 'A IA está lendo a foto e transformando em texto editável.',
        steps: _imageScanLoadingSteps,
        action: () => scanWritingImage(image),
      );
      if (!mounted) return;

      if (!result.hasText) {
        showCognixMessage(
          context,
          'A IA não conseguiu encontrar texto nessa imagem. Tente outra foto.',
          type: CognixMessageType.error,
        );
        return;
      }

      final reviewedText = await _reviewScannedText(result);
      if (reviewedText == null || reviewedText.trim().isEmpty) {
        return;
      }

      if (!mounted) return;
      final finalText = reviewedText.trim();
      _setFinalText(finalText);
      showCognixMessage(
        context,
        'Texto transcrito pela IA. Revise antes de analisar.',
        type: result.needsReview
            ? CognixMessageType.info
            : CognixMessageType.success,
      );
    } catch (error) {
      if (!mounted) return;
      showCognixMessage(
        context,
        error.toString().replaceFirst('Exception: ', ''),
        type: CognixMessageType.error,
      );
    } finally {
      _setScanningImage(false);
    }
  }

  Future<String?> _reviewScannedText(WritingImageScanResult result) async {
    var reviewedText = result.text;
    final colors = context.cognixColors;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceContainer,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, bottomInset + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revisar transcrição',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A IA pode errar palavras em fotos cortadas, tremidas ou com letra difícil.',
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 12.8,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                _ImageScanConfidenceCard(result: result),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.48,
                  ),
                  child: TextFormField(
                    initialValue: result.text,
                    onChanged: (value) => reviewedText = value,
                    minLines: 8,
                    maxLines: null,
                    style: GoogleFonts.inter(
                      color: colors.onSurface,
                      fontSize: 13.4,
                      height: 1.45,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surface,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colors.primary.withValues(alpha: 0.08),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colors.primary.withValues(alpha: 0.08),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(reviewedText),
                        child: const Text('Usar texto'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
