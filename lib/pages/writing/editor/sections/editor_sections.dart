part of '../writing_editor_screen.dart';

extension _WritingEditorSections on _WritingEditorScreenState {
  List<Widget> _buildManualEditorContent() {
    return [
      const SizedBox(height: 18),
      const _SectionHeader(
        eyebrow: 'Roteiro',
        title: 'Estrutura guiada',
        subtitle: 'Monte as ideias principais antes de fechar o texto.',
      ),
      const SizedBox(height: 12),
      _GuideCard(
        child: Column(
          children: [
            _WritingInput(
              icon: Icons.track_changes_rounded,
              label: 'Tese',
              hint: 'Qual é a posição central do seu texto?',
              controller: _thesisController,
              minLines: 2,
              onChanged: (_) => _refreshDraftMetrics(),
            ),
            _WritingInput(
              icon: Icons.menu_book_rounded,
              label: 'Repertório',
              hint: 'Lei, dado, autor, obra ou acontecimento.',
              controller: _repertoireController,
              minLines: 2,
              onChanged: (_) => _refreshDraftMetrics(),
            ),
            _WritingInput(
              icon: Icons.looks_one_rounded,
              label: 'Argumento 1',
              hint: 'Desenvolva o primeiro ponto com clareza.',
              controller: _argumentOneController,
              minLines: 3,
              onChanged: (_) => _refreshDraftMetrics(),
            ),
            _WritingInput(
              icon: Icons.looks_two_rounded,
              label: 'Argumento 2',
              hint: 'Apresente um segundo ponto complementar.',
              controller: _argumentTwoController,
              minLines: 3,
              onChanged: (_) => _refreshDraftMetrics(),
            ),
            _WritingInput(
              icon: Icons.campaign_rounded,
              label: 'Proposta de intervenção',
              hint: 'Agente, ação, meio, finalidade e detalhamento.',
              controller: _interventionController,
              minLines: 3,
              onChanged: (_) => _refreshDraftMetrics(),
              isLast: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _ComposeButton(onTap: _composeDraftText),
      const SizedBox(height: 20),
      const _SectionHeader(
        eyebrow: 'Redação',
        title: 'Texto final',
        subtitle: 'Revise e ajuste o texto completo antes da análise.',
      ),
      const SizedBox(height: 12),
      _buildFinalTextInput(
        label: 'Redação completa',
        hint: 'Escreva ou cole a redação final aqui.',
      ),
    ];
  }

  List<Widget> _buildImageScanEditorContent(WritingDraft draft) {
    final hasScannedText = draft.finalText.trim().isNotEmpty;

    return [
      const SizedBox(height: 18),
      const _SectionHeader(
        eyebrow: 'Foto com IA',
        title: 'Escaneie sua redação',
        subtitle:
            'Tire uma foto ou escolha uma imagem. Depois revise a transcrição antes da análise.',
      ),
      const SizedBox(height: 12),
      _ImageScanButton(
        isLoading: _isScanningImage,
        isEnabled: !_isAnalyzing,
        onTap: _chooseImageScanSource,
      ),
      const SizedBox(height: 12),
      if (hasScannedText) ...[
        const _SectionHeader(
          eyebrow: 'Revisão',
          title: 'Texto transcrito',
          subtitle:
              'A IA já leu a foto. Ajuste palavras, acentos e quebras de linha antes do diagnóstico.',
        ),
        const SizedBox(height: 12),
        _buildFinalTextInput(
          label: 'Texto lido pela IA',
          hint: 'Revise a transcrição antes de analisar.',
        ),
      ] else
        const _ImageScanEmptyState(),
    ];
  }

  Widget _buildFinalTextInput({required String label, required String hint}) {
    return _GuideCard(
      child: _WritingInput(
        icon: Icons.edit_note_rounded,
        label: label,
        hint: hint,
        controller: _finalTextController,
        minLines: 12,
        onChanged: (_) => _refreshDraftMetrics(),
        isLast: true,
      ),
    );
  }
}
