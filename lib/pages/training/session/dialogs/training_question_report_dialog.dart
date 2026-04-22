import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingQuestionReportDraft {
  const TrainingQuestionReportDraft({required this.reasons, this.details});

  final List<String> reasons;
  final String? details;
}

class TrainingQuestionReportReason {
  const TrainingQuestionReportReason({
    required this.code,
    required this.label,
    required this.description,
  });

  final String code;
  final String label;
  final String description;
}

const trainingQuestionReportReasons = [
  TrainingQuestionReportReason(
    code: 'missing_statement',
    label: 'Falta enunciado',
    description: 'A pergunta veio vazia, cortada ou sem contexto suficiente.',
  ),
  TrainingQuestionReportReason(
    code: 'missing_image',
    label: 'Imagem faltando',
    description: 'A questão depende de uma imagem que não apareceu.',
  ),
  TrainingQuestionReportReason(
    code: 'broken_image',
    label: 'Imagem não carrega',
    description: 'Existe uma imagem, mas ela esta quebrada ou indisponível.',
  ),
  TrainingQuestionReportReason(
    code: 'alternatives_issue',
    label: 'Alternativas com problema',
    description: 'As opções estão repetidas, incompletas ou incoerentes.',
  ),
  TrainingQuestionReportReason(
    code: 'wrong_answer',
    label: 'Gabarito incorreto',
    description: 'A resposta marcada como correta parece estar errada.',
  ),
  TrainingQuestionReportReason(
    code: 'other',
    label: 'Outro problema',
    description: 'Use quando o problema não se encaixar nas opções acima.',
  ),
];

Future<TrainingQuestionReportDraft?> showTrainingQuestionReportDialog(
  BuildContext context, {
  required Color surfaceContainer,
  required Color surfaceContainerHigh,
  required Color onSurface,
  required Color onSurfaceMuted,
  required Color primary,
}) {
  return showDialog<TrainingQuestionReportDraft>(
    context: context,
    builder: (context) => _TrainingQuestionReportDialog(
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
    ),
  );
}

class _TrainingQuestionReportDialog extends StatefulWidget {
  const _TrainingQuestionReportDialog({
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
  State<_TrainingQuestionReportDialog> createState() =>
      _TrainingQuestionReportDialogState();
}

class _TrainingQuestionReportDialogState
    extends State<_TrainingQuestionReportDialog> {
  final TextEditingController _detailsController = TextEditingController();
  final Set<String> _selectedReasons = {};

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  bool get _requiresDetails => _selectedReasons.contains('other');

  bool get _canSubmit {
    if (_selectedReasons.isEmpty) {
      return false;
    }
    if (_requiresDetails && _detailsController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void _toggleReason(String code) {
    setState(() {
      if (code == 'other') {
        _selectedReasons
          ..clear()
          ..add(code);
        return;
      }

      _selectedReasons.remove('other');
      if (_selectedReasons.contains(code)) {
        _selectedReasons.remove(code);
      } else {
        _selectedReasons.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        'Reportar questão',
        style: GoogleFonts.plusJakartaSans(
          color: widget.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione um ou mais problemas. "Outro" exige detalhe.',
              style: GoogleFonts.inter(
                color: widget.onSurfaceMuted,
                fontSize: 12,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                for (final reason in trainingQuestionReportReasons) ...[
                  _ReasonOption(
                    reason: reason,
                    selected: _selectedReasons.contains(reason.code),
                    surfaceContainerHigh: widget.surfaceContainerHigh,
                    onSurface: widget.onSurface,
                    onSurfaceMuted: widget.onSurfaceMuted,
                    primary: widget.primary,
                    onTap: () => _toggleReason(reason.code),
                  ),
                  if (reason != trainingQuestionReportReasons.last)
                    const SizedBox(height: 7),
                ],
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _detailsController,
              maxLines: 2,
              maxLength: 1000,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(color: widget.onSurface, fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                counterStyle: GoogleFonts.inter(
                  color: widget.onSurfaceMuted,
                  fontSize: 10.5,
                ),
                counterText: '',
                hintText: _requiresDetails
                    ? 'Descreva o outro problema'
                    : 'Detalhe opcional',
                hintStyle: GoogleFonts.inter(
                  color: widget.onSurfaceMuted.withValues(alpha: 0.72),
                  fontSize: 13,
                ),
                helperText: _requiresDetails
                    ? 'Obrigatório para "Outro problema".'
                    : null,
                helperStyle: GoogleFonts.inter(
                  color: widget.onSurfaceMuted,
                  fontSize: 10.5,
                ),
                filled: true,
                fillColor: widget.surfaceContainerHigh.withValues(alpha: 0.35),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: widget.onSurfaceMuted.withValues(alpha: 0.18),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: widget.primary),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: GoogleFonts.plusJakartaSans(
              color: widget.onSurfaceMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: widget.surfaceContainerHigh,
            disabledForegroundColor: widget.onSurfaceMuted,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: _canSubmit
              ? () {
                  final details = _detailsController.text.trim();
                  final reasons = trainingQuestionReportReasons
                      .where((reason) => _selectedReasons.contains(reason.code))
                      .map((reason) => reason.code)
                      .toList(growable: false);
                  Navigator.of(context).pop(
                    TrainingQuestionReportDraft(
                      reasons: reasons,
                      details: details.isEmpty ? null : details,
                    ),
                  );
                }
              : null,
          child: Text(
            'Enviar',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.reason,
    required this.selected,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onTap,
  });

  final TrainingQuestionReportReason reason;
  final bool selected;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final VoidCallback onTap;

  IconData _iconForReason() {
    return switch (reason.code) {
      'missing_statement' => Icons.notes_rounded,
      'missing_image' => Icons.image_not_supported_rounded,
      'broken_image' => Icons.broken_image_rounded,
      'alternatives_issue' => Icons.rule_rounded,
      'wrong_answer' => Icons.fact_check_rounded,
      _ => Icons.more_horiz_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? primary.withValues(alpha: 0.72)
        : onSurfaceMuted.withValues(alpha: 0.12);
    final backgroundColor = selected
        ? primary.withValues(alpha: 0.13)
        : surfaceContainerHigh.withValues(alpha: 0.28);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected
                      ? primary.withValues(alpha: 0.18)
                      : surfaceContainerHigh.withValues(alpha: 0.46),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  _iconForReason(),
                  color: selected ? primary : onSurfaceMuted,
                  size: 16,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reason.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: onSurface,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reason.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 10.6,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected
                    ? primary
                    : onSurfaceMuted.withValues(alpha: 0.7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
