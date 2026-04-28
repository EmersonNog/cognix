part of '../requests.dart';

Future<WritingSubmissionsData> fetchWritingSubmissions({
  int limit = 5,
  int offset = 0,
}) async {
  final payload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/writing/submissions',
    ).replace(queryParameters: {'limit': '$limit', 'offset': '$offset'}),
    errorMessage: 'Não consegui carregar seu histórico de redações',
  );
  return parseWritingSubmissionsData(payload);
}

Future<WritingSubmissionDetail> fetchWritingSubmissionDetail(
  int submissionId, {
  int versionsLimit = 5,
  int versionsOffset = 0,
}) async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/writing/submissions/$submissionId').replace(
      queryParameters: {
        'versions_limit': '$versionsLimit',
        'versions_offset': '$versionsOffset',
      },
    ),
    errorMessage: 'Não consegui carregar os detalhes da redação',
  );
  return parseWritingSubmissionDetail(payload);
}
