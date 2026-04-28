part of '../requests.dart';

Future<WritingFeedback> analyzeWritingDraft(WritingDraft draft) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/writing/analyze'),
    body: {
      if (draft.submissionId != null) 'submission_id': draft.submissionId,
      'theme': {
        'id': draft.theme.id,
        'title': draft.theme.title,
        'category': draft.theme.category,
        'description': draft.theme.description,
        'keywords': draft.theme.keywords,
      },
      'thesis': draft.thesis,
      'repertoire': draft.repertoire,
      'argument_one': draft.argumentOne,
      'argument_two': draft.argumentTwo,
      'intervention': draft.intervention,
      'final_text': draft.finalText,
    },
    errorMessage: 'Revise o texto antes de pedir a análise',
    timeout: const Duration(seconds: 45),
  );
  return parseWritingFeedback(payload);
}
